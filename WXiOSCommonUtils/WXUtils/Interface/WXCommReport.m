//
//  CommReport.m
//  WXCommonUtils
//
//  Created by wangxu on 15/12/24.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import "WXCommReport.h"
#import "WXCommTools.h"
#import "WXCommInterface.h"
#import "WXCommDevice.h"
#import "WXUserDefaultKit.h"
#import "WXiOSCommonUtils.h"

static NSString    *m_appIdentify,*m_appType,*m_appVersion,*m_appModal,*m_userIdentify,*m_appid;
static NSDate      *m_startTime,*m_endTime;
//static NSString    *m_ytVersion;

static WXReportState m_state;

@implementation WXCommReport

+ (WXReportState)State
{
    return m_state;
}

+ (NSString *)notificationName
{
    return @"ReportStateDidChange";
}

+ (void)save
{
    m_endTime = [[NSDate date] copy];
    
    NSString *data = [self getReportData:@""];
    if (data == nil)
    {
        data = @"";
    }
    
    NSString *encString = [WXCommTools EncryptString:data];
    
    [WXUserDefaultKit saveToUserDefaultsForKey:[WXCommSettings KEY_REPORTDATA] ObjectValue:encString];
}

+ (void)updateAppInfo
{
    WXCommAppInfo *appInfo = [WXiOSCommonUtils appInfo];
    
    m_appIdentify = appInfo.product.identify;
    m_appid = Int2String(appInfo.product.identifyID);
    m_appType = appInfo.appType;
    m_appVersion = appInfo.appVersion;
    m_startTime = [WXiOSCommonUtils appStartTime];
    m_userIdentify = [WXCommDevice deviceUUID];
    m_appModal = appInfo.appModel;
}


static BOOL b_hasReported = NO; // 用来控制每个App在每次程序启动时只上报一次
+ (void)startReportWithUserEmail:(NSString *)email
{
    // 如果已经上报成功，则当次App启动不会再进行上报
    if (b_hasReported) {
        return;
    }
    
    b_hasReported = YES;
    
    [self updateAppInfo];
    m_state = WXReportStateNone;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self startReport:email];
        
    });
}

+(void)startReport:(NSString*)email
{
    m_state = WXReportStateFailed;
    if (email == nil || email.length == 0)
    {
        email = @"";
    }
    
    NSString *data = [WXUserDefaultKit getFromUserDefaults_NSString:[WXCommSettings KEY_REPORTDATA] withDefaultValue:@""];
    if (!data || data.length == 0)
    {
        data = [self getReportData:email];
    }
    else
    {
        data = [WXCommTools DecryptString:data];
        if (![data containsString:@"#time_stamp#"])
        {
            data = [self getReportData:email];
        }
    }
    
    if (data == nil)
    {
        return;
    }
    
    NSString *timestampFormat = [WXCommTools Timestamp];
    data = [data stringByReplacingOccurrencesOfString:@"#user_email#" withString:email];
    data = [data stringByReplacingOccurrencesOfString:@"#time_stamp#" withString:timestampFormat];
    WXCommInterface *interface = [[WXCommInterface alloc] init];
    NSString *response = [interface GetResponseFromServer:data timestamp:timestampFormat actionType:WXServerActionTypeReport];
    
    b_hasReported = NO;
    
    if (response)
    {
//        NSDictionary *respDict = [WXCommTools convertDataToDictionary:[response dataUsingEncoding:NSUTF8StringEncoding]];

        NSError* error;
        NSDictionary* respDict = [NSJSONSerialization JSONObjectWithData:response
                                                             options:NSJSONReadingFragmentsAllowed
                                                               error:&error];


        if (respDict)
        {
            NSString *state=[respDict objectForKey:@"state"];
            m_state = [state intValue];
            if (m_state == WXReportStateSuccess)
            {
                b_hasReported = YES;
                
                [WXUserDefaultKit saveToUserDefaultsForKey:[WXCommSettings KEY_REPORTDATA] ObjectValue:@""];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName] object:self];
}


+ (NSString *)getReportData:(NSString *)email
{
    if (m_appModal == nil || m_appModal.length == 0)
    {
        m_appModal = [@"IOS" copy];
    }
    NSString *deviceVersion = [m_appModal stringByAppendingFormat:@" %@ (%@)",[WXCommDevice deviceSystemVersion],[WXCommDevice deviceModel]];
    NSString *deviceLang = [WXCommDevice deviceCurrentLanguage];
    if (email == nil || email.length == 0)
    {
        email=@"#user_email#";
    }
    m_endTime = [[NSDate date] copy];
    long int runInterval = [m_endTime timeIntervalSinceDate:m_startTime];

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:@"1" forKey:@"protocol_version"];
    [dataDic setObject:@"IOS" forKey:@"platform"];
    [dataDic setObject:m_userIdentify forKey:@"user_id"];
    [dataDic setObject:email forKey:@"user_email"];
    [dataDic setObject:m_appType forKey:@"app_type"];
    [dataDic setObject:m_appIdentify forKey:@"app_name"];
    [dataDic setObject:m_appid forKey:@"app_id"];
    [dataDic setObject:m_appVersion forKey:@"app_version"];
    [dataDic setObject:[m_startTime description] forKey:@"start_time"];
    [dataDic setObject:[m_endTime description] forKey:@"end_time"];
    [dataDic setObject:[NSNumber numberWithInteger:runInterval] forKey:@"total_seconds"];
    [dataDic setObject:deviceVersion forKey:@"os_version"];
    [dataDic setObject:deviceLang forKey:@"os_language"];
    [dataDic setValue:@"#time_stamp#" forKey:@"time_stamp"];
//    NSData *jsonData = [WXCommTools convertDictionaryToData:dataDic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic
    options:NSJSONWritingPrettyPrinted
      error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


@end

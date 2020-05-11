//
//  WXCommFeedback.m
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommFeedback.h"
#import "WXCommTools.h"
#import "WXCommInterface.h"
#import "WXCommDevice.h"
#import "WXiOSCommonUtils.h"

static NSString        *m_appIdentify,*m_appType,*m_appVersion,*m_appLang,*m_appModal,*m_resolution,*m_appid;
static NSString        *m_description;
static NSMutableArray  *m_logs;
static NSString        *m_zipedLogFile;
//static NSString    *m_ytVersion;

static WXFeedbackState m_state = WXFeedbackStateNone;


@implementation WXCommFeedback

+ (WXFeedbackState)state
{
    return m_state;
}

+ (NSString *)notificationName
{
    return @"FeedbackStateDidChange";
}

+ (NSInteger)feedbackSendType
{
    return 1;
}

+ (void)addFeedbackDescription:(NSString *)description
{
    m_description = [description copy];
}

+ (void)addLogFiles:(NSArray *)logPaths
{
    if (logPaths == nil || logPaths.count == 0)
    {
        return;
    }
    
    if (m_logs == nil)
    {
        m_logs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    for (NSString *logPath in logPaths)
    {
        if ([WXCommTools FileExist:logPath])
        {
            [m_logs addObject:logPath];
        }
    }
}

+ (void)updateAppInfo
{
    WXCommAppInfo *appInfo = [WXiOSCommonUtils appInfo];
    
    m_appIdentify = appInfo.product.identify;
    m_appType = appInfo.appType;
    m_appVersion = appInfo.appVersion;
    m_appLang = appInfo.appLang;
    m_appModal = appInfo.appModel;
    m_resolution = [WXCommDevice formatDeviceResolution];
    m_appid = Int2String(appInfo.product.identifyID);
}

+ (void)startSubmitFeedback:(NSString *)userEmail
{
    [self updateAppInfo];
    m_state = WXFeedbackStateNone;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self startSubmit:userEmail];
        
    });
}


+ (void)startSubmit:(NSString *)userEmail
{
    m_state = WXFeedbackStateFailed;
    
    if (userEmail == nil || userEmail.length == 0)
    {
        userEmail = @"";
    }
    
    if (m_appModal == nil || m_appModal.length == 0)
    {
        m_appModal = [@"IOS" copy];
    }
    
    if (m_description == nil || m_description.length == 0)
    {
        m_description = @"";
    }
    
    NSString *deviceVersion = [m_appModal stringByAppendingFormat:@" %@ (%@)",[WXCommDevice deviceSystemVersion],[WXCommDevice deviceModel]];
    NSString *deviceLang = [WXCommDevice deviceCurrentLanguage];
    NSString *timestampFormat = [WXCommTools Timestamp];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:@"1" forKey:@"protocol_version"];
    [dict setObject:timestampFormat forKey:@"time_stamp"];
    [dict setObject:m_appIdentify forKey:@"app_name"];
    [dict setObject:m_appid forKey:@"app_id"];
    [dict setObject:m_appVersion forKey:@"app_version"];
    [dict setObject:m_appLang forKey:@"app_language"];
    [dict setObject:m_appType forKey:@"app_type"];
    [dict setObject:m_resolution forKey:@"os_resolution"];
    [dict setObject:deviceLang forKey:@"os_language"];
    [dict setObject:deviceVersion forKey:@"os_version"];
    [dict setObject:[NSNumber numberWithInteger:[self feedbackSendType]] forKey:@"feedback_type"];
    [dict setObject:userEmail forKey:@"contact"];
    [dict setObject:m_description forKey:@"description"];
    [dict setObject:@"" forKey:@"m_parameters"];
    
//    NSData *jsonData = [WXCommTools convertDictionaryToData:dict];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
    options:NSJSONWritingFragmentsAllowed
      error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (m_zipedLogFile != nil)
    {
        if ([WXCommTools FileExist:m_zipedLogFile])
        {
            [WXCommTools FileDelete:m_zipedLogFile];
        }
    }
    m_zipedLogFile = nil;
    if (m_logs && m_logs.count > 0)
    {
        m_zipedLogFile = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"zipLog.zip"] copy];
        BOOL zipResult = [WXCommTools ZipFiles:m_logs outFile:m_zipedLogFile];
        if (!zipResult)
        {
            m_zipedLogFile = nil;
        }
    }
    
    WXCommInterface *interface = [[WXCommInterface alloc] init];
    NSString *response = [interface GetResponseFromServer:jsonString timestamp:timestampFormat uploadFile:m_zipedLogFile actionType:WXServerActionTypeFeedback];

    if (m_zipedLogFile && [WXCommTools FileExist:m_zipedLogFile])
    {
        [WXCommTools FileDelete:m_zipedLogFile];
        m_zipedLogFile = nil;
    }

    if (response)
    {
//        NSDictionary *responseDic = [WXCommTools convertDataToDictionary:[response dataUsingEncoding:NSUTF8StringEncoding]];

        NSError* error;
               NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:response
                                                                    options:NSJSONReadingFragmentsAllowed
                                                                      error:&error];

        if (responseDic)
        {
            NSString *state = [responseDic objectForKey:@"state"];
            m_state = [state intValue];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName] object:self];
}




@end

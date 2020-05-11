//
//  CommSettings.m
//  WXCommonUtils
//
//  Created by wangxu on 15/12/24.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import "WXCommSettings.h"
#import "WXAppTools.h"
#import "WXiOSCommonUtils.h"

@implementation WXCommSettings
+(NSString*)    SERVER_API_URL{
    if ([WXiOSCommonUtils.appInfo.appLang isEqualToString:@"ChineseSimplified"]) {
//    if ([[WXAppTools ClientLanguage] isEqualToString:@"ChineseSimplified"]) {
       return @"http://support.apowersoft.cn/api/client";
    }
    return @"http://support.apowersoft.com/api/client";
}
+(NSString*)    DesKey{
    return @"ibmCaThj";
}
+(NSString*)    KEY_REPORTDATA{
    return @"CommonUtils.Report.Data";
}
+(NSString*)    KEY_UPDATESKIPVERSION{
    return @"CommonUtils.Update.SkipVersion";
}

+ (BOOL)isNullClass:(NSObject *)obj
{
    if ([obj isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    return NO;
}

@end

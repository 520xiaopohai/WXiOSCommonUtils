//
//  WXiOSCommonUtils.m
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXiOSCommonUtils.h"
#import "WXCommAppInfo.h"
#import "WXCommLog.h"
#import "CommPassportHeader.h"

static WXCommAppInfo *m_appInfo = nil;
static NSDate *m_appStartTime = nil;

@implementation WXiOSCommonUtils

+ (WXCommAppInfo *)appInfo
{
    return m_appInfo;
}

+ (void)updateAppInfo:(WXCommAppInfo *)newAppInfo
{
    m_appInfo = newAppInfo;
    //TODO:部分功能需要一起通知
}

+ (void)initWithCommAppInfo:(WXCommAppInfo *)appInfo
{
    m_appInfo = appInfo;
    m_appStartTime = [NSDate date];
    
    //初始化日志
    [WXCommLog init];
    
    //
    [WXCommPassportInfo initPassport];
    
    //数据上报
    //TODO:当后面本地保存用户信息时，再传入UserEmail参数
//    [WXCommReport startReportWithUserEmail:nil];
}

/// 上报数据
+ (void)startReport
{
    [WXCommReport startReportWithUserEmail:nil];
}


+ (void)dispose
{
    [WXCommReport save];
}

+ (NSDate *)appStartTime
{
    return m_appStartTime;
}


@end

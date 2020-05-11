//
//  WXiOSCommonUtils.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/15.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCommFeedback.h"
#import "WXCommReport.h"
#import "WXCommLog.h"
#import "WXCommTools.h"
#import "WXAutoCheckUpdate.h"
#import "WXCommDevice.h"
#import "WXCommShare.h"
#import "WXCommLang.h"
#import "WXDataBaseManage.h"
#import "WXAlertView.h"
//#import "AAPLSwipeTransitionDelegate.h"




#import "WXCommAppInfo.h"
#import "WXCommProductInfo.h"
#import "WXCommPassportInfo.h"

//Network
#import <AFNetworking/AFNetworking.h>
#import "WXAFNetworking.h"

#if __has_include(<YBNetwork/YBBaseRequest.h>)
#import <YBNetwork/YBBaseRequest.h>
#else
#import "YBBaseRequest.h"
#endif

#import "YBNetworkManager.h"

// category
#import "UIView+WXExtention.h"
#import "NSString+WXExtension.h"
#import "UIImage+WXExtension.h"
#import "UIButton+WXEdgeExtension.h"
#import "UIImageView+WXAnimated.h"
#import "UIButton+imageTextEdgeInsets.h"
#import "UIFont+WXExtention.h"
#import "UILabel+Gradient.h"
#import "NSObject+WXCoding.h"

//accountCenter
#import "WXAccountWebBridge.h"
//#import "WXAccountWebVC.h"
#import "WXUserDefaultKit.h"
//IAP


#import "WXCommDefine.h"

#import <YYImage/YYImage.h>


//#import "NBPhoneNumberUtil.h"

#import "ZipArchive.h"

//! Project version number for WXiOSCommonUtils.
FOUNDATION_EXPORT double WXiOSCommonUtilsVersionNumber;

//! Project version string for WXiOSCommonUtils.
FOUNDATION_EXPORT const unsigned char WXiOSCommonUtilsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WXiOSCommonUtils/PublicHeader.h>

@interface WXiOSCommonUtils : NSObject

/**
 获取AppInfo对象
 */
+ (WXCommAppInfo *)appInfo;


/**
 app启动时间
 */
+ (NSDate *)appStartTime;


/**
 在appt退出前调用，进行一些收尾工作
 */
+ (void)dispose;

/**
 更新AppInfo。部分参数改变后
 */
+ (void)updateAppInfo:(WXCommAppInfo *)newAppInfo;


+ (void)initWithCommAppInfo:(WXCommAppInfo *)appInfo;

/// 上报数据
+ (void)startReport;

@end

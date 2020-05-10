//
//  AutoCheckUpdate.h
//  WXCommonUtils
//
//  Created by wangxutech on 16/7/4.
//  Copyright © 2016年 apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUpdateAppNotify @"kUpdateAppNotify"

@interface WXAutoCheckUpdate : NSObject

+ (void)checkForUpdateWithAppId:(NSString *)appId;
+ (void)checkForUpdateWithAppId:(NSString *)appId block:(void(^)(bool shouldUpdate))handler;

+ (BOOL)version:(NSString *)oldver lessthan:(NSString *)newver;
+ (NSString*)curtVersion;
+ (NSString*)appStoreVersion;
+ (NSURL*)appDownUrl;
+ (void)getAppLinkUrlWithAppId:(NSString *)appId result:(void(^)(NSString *url))handler;

@end

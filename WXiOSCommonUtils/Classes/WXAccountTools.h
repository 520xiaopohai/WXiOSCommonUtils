//
//  WXAccountTools.h
//  WXiOSCommonUtils
//
//  Created by ian-mac on 2020/2/25.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WXAccountTools : NSObject

//webView Cookie
+ (void)setAccountCookies:(NSString *)cookies;
+ (NSString *)getAccountCookies;
+ (void)clearAccountCookies;

//登录成功获取的账户token
+ (void)setAccountIdentityToken:(NSString *)token;
+ (NSString *)getAccountIdentityToken;


@end


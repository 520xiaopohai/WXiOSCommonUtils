//
//  WXAccountTools.m
//  WXiOSCommonUtils
//
//  Created by ian-mac on 2020/2/25.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXAccountTools.h"
#import "WXUserDefaultKit.h"
#import "WXCommPassportInfo.h"

#define kUserDefaultAccountCookiesName                  @"key.userdefault.AccountCookiesName"
#define kUserDefaultAccountIdentityTokenName             @"key.userdefault.AccountIdentityToken"

@implementation WXAccountTools

+ (void)setAccountCookies:(NSString *)cookies {
    
    [WXCommPassportInfo updatePassportInfoWithLoginCookies:cookies];
    
    WXUserDefaultSetValue_NSString(cookies, kUserDefaultAccountCookiesName);
}






+ (void)clearAccountCookies {
    WXUserDefaultSetValue_NSString(@"", kUserDefaultAccountCookiesName);
}

+ (NSString *)getAccountCookies {
    return WXUserDefaultGetNSStringValue(kUserDefaultAccountCookiesName, nil);
}

+ (void)setAccountIdentityToken:(NSString *)token {
    WXUserDefaultSetValue_NSString(token, kUserDefaultAccountIdentityTokenName);
}

+ (NSString *)getAccountIdentityToken {
    return WXUserDefaultGetNSStringValue(kUserDefaultAccountIdentityTokenName, nil);
}

@end

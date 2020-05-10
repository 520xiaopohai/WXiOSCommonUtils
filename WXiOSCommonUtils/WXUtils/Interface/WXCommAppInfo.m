//
//  WXCommAppInfo.m
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommAppInfo.h"
#import "WXCommLang.h"
#import "WXCommDevice.h"
#import "NSString+WXExtension.h"

@interface WXCommAppInfo()
{
    WXCommProductInfo *_product;
}
@end

@implementation WXCommAppInfo
@synthesize product = _product;

- (void)dealloc
{
    _product = nil;
}

- (id)initWithProductInfo:(WXCommProductInfo *)productInfo
{
    if(self = [super init])
    {
        _product = productInfo;
    }
    return self;
}

#pragma mark - 只读属性
- (NSString *)getAppLangCode
{
    return [WXCommLang getLangCodeWithLangName:self.appLang];
}

- (NSString *)getAppName
{
    NSString *appName = self.product.appName;
    if (appName == nil || [appName isEmpty])
    {
        appName = self.product.identify;
    }
    return appName;
}

- (NSString *)getAppLocalizedName
{
    NSString *localizedName = self.product.localizedName;
    if (localizedName == nil || [localizedName isEmpty])
    {
        localizedName = [self getAppName];
    }
    return localizedName;
}

@end

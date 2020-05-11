//
//  WXCommAppInfo.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCommProductInfo.h"
#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface WXCommAppInfo : NSObject

//通过product获取一些app信息
@property (nonatomic,readonly,strong) WXCommProductInfo *product;
//需从外部赋值属性
@property (strong) NSString *appVersion; //版本号，例如 v1.0.1 (Build 02/16/2020)
@property (strong) NSString *appLang;
@property (strong) NSString *appType;
@property (strong) UIImage *appLogo;
@property (strong) NSString *appModel; // 默认iOS

@property (nonatomic,readonly,getter=getAppName) NSString *appName;
@property (nonatomic,readonly,getter=getAppLocalizedName) NSString *appLocalizedName;
//一些只读属性
@property (nonatomic,readonly,getter=getAppLangCode) NSString *appLangCode;


- (id)initWithProductInfo:(WXCommProductInfo *)productInfo;

@end

//NS_ASSUME_NONNULL_END

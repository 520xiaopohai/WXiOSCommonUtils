//
//  WXCommLang.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXCommLang : NSObject


/**
 主要是为了兼容一些语言简写，比如传入 jp 或者 ja，都会返回 @[@"jp",@"ja"]
 */
+ (NSArray *)GetlangCodesWithLangCode:(NSString *)langCode;


/**
 获取相应语言的简称
 */
+ (NSString *)getLangCodeWithLangName:(NSString *)langName;


/**
  当前设备语言映射的程序语言名称 , 默认为"English"。
  该方法主要是在程序第一次启动时调用，来获取与设备
  相对应的语言
 */
+ (NSString *)deviceLangName;


/**
  所有语言名称
 */
+ (NSArray *)allLangNames;


/**
 所有本地化语言名称
 */
+ (NSArray *)allLangLocalNames;

/**
 通过LangCode获取本地化语言名称，比如jp -> 日本语
 特殊字段 : pt  分为 pt 和 pt-br
 */
+ (NSString *)getLocalizationLangNameWithLangCode:(NSString *)langCode;


/**
 通过LangCode获取语言名称
 */
+ (NSString *)getLangNameWithLangCode:(NSString *)langCode;


/**
 获取当前语言的简称
 */
+ (NSString*)curtLanguageCode;

#pragma mark - -------多语言翻译模块---------

#pragma mark - Json结构
+ (void)LoadLangWithJsonFiles:(NSArray *)files;
+ (BOOL)JsonLangInited;

+ (NSString *)JsonLang:(NSString *)key;

/**
 当前是否是中文

 @return 是
 */
+ (BOOL)isChinese;

@end

NS_ASSUME_NONNULL_END

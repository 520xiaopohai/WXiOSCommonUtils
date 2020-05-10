//
//  WXAppTools.h
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAppTools : NSObject

#pragma mark - language

/**
 获取当前语言

 @return 语言
 */
+ (NSString *)ClientLanguage;

+ (NSString *)getValueForKeywords:(NSString *)keywords;


#pragma mark 文件路径

+ (NSString *)tmpDownloadFilePathForFileName:(NSString *)fileName;

#pragma mark - Date to String
+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format;

+ (NSData *)dataFromDictionary:(NSDictionary *)dic;

+ (NSDictionary *)dictionatyFromData:(NSData *)jsonData;
@end

NS_ASSUME_NONNULL_END

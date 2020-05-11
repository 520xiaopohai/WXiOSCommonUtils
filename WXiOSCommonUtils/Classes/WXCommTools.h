//
//  WXCommTools.h
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZipArchive.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXCommTools : NSObject


#pragma mark -- NSDictionary转NSData

+ (NSData *)convertDictionaryToData:(NSDictionary *)fromDic;

#pragma mark -- NSData转NSDictionary

//+ (NSDictionary *)convertDataToDictionary:(NSData *)jsonData;

#pragma mark -- NSArray转为NSData

+ (NSData *)convertArrayToData:(NSArray *)fromArray;

#pragma mark -- NSData转为NSArray
//
//+ (NSArray *)convertDataToArray:(NSData *)jsonData;

#pragma mark -- NSString转NSData

+ (NSData *)convertStringToData:(NSString *)fromString;

#pragma mark -- NSDictionary归档

+ (NSData *)archiverDictionaryToData:(NSDictionary *)dic;

#pragma mark -- NSDictionary解档

+ (NSDictionary *)unarchiverDataToDictionary:(NSData *)data;

#pragma mark -- Json To Dictionary
+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString;

#pragma mark -- 文件操作
+ (BOOL)FileCreate:(NSString *)filePath;

+ (BOOL)FileExist:(NSString*)filePath;

+ (void)FileDelete:(NSString *)filePath;

+ (void)removeFileAtFolderPath:(NSString*)folderPath;

// 文件压缩
+ (BOOL)ZipFiles:(NSArray*)files outFile:(NSString*)outfile;

/// 重命名操作
/// @param fromFilePath 检测的路径
/// @param count 一般填 1
+ (NSString *)renameFromFilePath:(NSString *)fromFilePath renameCount:(NSInteger)count;

#pragma mark - Alert 窗口

+ (void)showAlertWithOtherButtonTitle:(NSString *)otherButtonTitle Message:(NSString *)message, ...;

+ (void)showAlertWithnTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle delegete:(id)delegate message:(NSString *)message, ...;

#pragma mark- string 编解码

+ (NSString *)EncryptString:(NSString *)string;

+ (NSString *)DecryptString:(NSString *)string;

+ (NSString *)MD5:(NSString *)content;

+ (NSString *)MD5FromFile:(NSString *)filePath;

+ (NSString *)MD5FromData:(NSData *)fileData;

+ (NSString *)base64Encoded:(NSData *)data;
    
+ (NSData *)base64Decoded:(NSData *)fromData;

#pragma mark- 当前时间
+ (NSString *)Timestamp;

#pragma mark - 时间<->字符串

+ (NSString *)convertDoubleDurationToString:(NSTimeInterval)duration;

+ (NSString *)stringFromDate:(NSDate *)date dateFormatter:(NSString *)format;

+ (NSString *)timeToString:(long long)time;

+ (NSDate *)dateFromString:(NSString *)dateString dateForMatter:(NSString *)format;

#pragma mark -- 检测邮件格式

// 一个字节大小保留一位小数
+ (NSString*)formatSizeFromByte:(long long)bytes;

+ (BOOL)isValidateEmail:(NSString *)email;

#pragma mark -- 图片

+ (BOOL)isUrlString:(NSString *)urlString;

//获取图片方向
+ (int)convertImageOrientationToInt:(UIImageOrientation)orientation;


#pragma mark -- 字符处理

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

+ (BOOL)isString:(NSString *)string containsSubString:(NSString *)subString;

+ (CGSize)sizeForString:(NSString*)text font:(UIFont*)font;

+ (CGSize)sizeForString:(NSString*)text font:(UIFont*)font width:(CGFloat)width;

+ (NSComparisonResult)compareString:(NSString *)str1 andString:(NSString *)str2;


#pragma mark - 字符检查

+ (BOOL)isNullOrEmptyString:(NSString *)theString;

+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;


+ (UIImage *)imageWithColor:(UIColor *)color;

+ (long long)fileSizeAtPath:(NSString*)filePath;

+ (long long)folderSizeAtPath:(NSString*)folderPath;

@end


NS_ASSUME_NONNULL_END

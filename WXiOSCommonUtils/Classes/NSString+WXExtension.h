//
//  NSString+Extension.h
//  ApowerEdit
//
//  Created by wangxutech-Ian on 2018/10/25.
//  Copyright © 2018年 wangxutech-Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (WXExtension)

+ (NSString *)convertDoubleDurationToString:(CGFloat)second;

+ (NSString *)convertDurationFrameString:(CGFloat)second;

/**
 时间转字符串

 @param date 时间
 @return 返回yyyy-MM-dd HH:mm:ss格式字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 时间转字符串
 
 @param date 时间
 @return 返回yyyyMMddHHmmss格式字符串
 */
+ (NSString *)stringWithDefaultStyleFromDate:(NSDate *)date;

- (NSString*)md5;

- (BOOL)isEmpty;

- (BOOL)isContainsString:(NSString *)subString;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//URL
- (NSString *)URLEncode;
- (NSString *)URLDecode;


#pragma mark - Media
- (BOOL)isVideoType;
- (BOOL)isImageType;
- (BOOL)isAnimatedImage;
//获取视频第一帧图片
- (UIImage *)videoThumbnailWithSize:(CGSize)maxSize;
//获取路径图片的缩略图
- (UIImage *)imageThumbnailWithSize:(CGSize)maxSize;

#pragma mark - codeVC,获取ip等
+ (NSString *)parseCode:(NSString *)ipAddress;

+ (NSString *)decodeIP:(NSString *)ipAdreess;

+(NSString *)ToHex:(int)tmpid;
@end

NS_ASSUME_NONNULL_END

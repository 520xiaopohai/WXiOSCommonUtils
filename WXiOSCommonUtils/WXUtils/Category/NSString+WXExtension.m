//
//  NSString+Extension.m
//  ApowerEdit
//
//  Created by wangxutech-Ian on 2018/10/25.
//  Copyright © 2018年 wangxutech-Ian. All rights reserved.
//

#import "NSString+WXExtension.h"
#import  <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSString (WXExtension)

+ (NSString *)convertDoubleDurationToString:(CGFloat)second
{
    int minute = second / 60;
    int seconds = (second - minute*60);
    NSString *strDuration  = @"";
    
    strDuration = [strDuration stringByAppendingFormat:@"%02d:",minute];
    strDuration = [strDuration stringByAppendingFormat:@"%02d",seconds];
    
    return strDuration;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    dateFromatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFromatter stringFromDate:date];
    dateFromatter = nil;
    return dateString;
}

+ (NSString *)stringWithDefaultStyleFromDate:(NSDate *)date
{
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    dateFromatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateString = [dateFromatter stringFromDate:date];
    dateFromatter = nil;
    return dateString;
}

+ (NSString *)convertDurationFrameString:(CGFloat)second
{
    
    int minute = second / 60;
    int seconds = (second - minute*60);
    NSString *strDuration  = @"";
    
    NSInteger s = floor(second);
    int frame = (second - s)/0.1;
    strDuration = [strDuration stringByAppendingFormat:@"%d:",minute];
    strDuration = [strDuration stringByAppendingFormat:@"%02d.",seconds];
    strDuration = [strDuration stringByAppendingFormat:@"%d",frame];
    return strDuration;
}

- (BOOL)isEmpty
{
    if (self.length > 0)
    {
        return NO;
    }
    return YES;
}

- (NSString*)md5 {
    return [self.class md5:self];
}

+ (NSString*)md5:(NSString*)string
{
    const char *concat_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

NSString* md5Encode(const char* data, unsigned long size)
{
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, data, (CC_LONG)size);
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &ctx);
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    return CFBridgingRelease(CFStringCreateWithCString(kCFAllocatorDefault,
                                                       (const char *)hash,
                                                       kCFStringEncodingUTF8));
}

- (BOOL)isContainsString:(NSString *)subString
{
    if ([self isEmpty])
    {
        return NO;
    }
    
    if ([self rangeOfString:subString].location != NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (NSString *)URLEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)URLDecode
{
    return  [self stringByRemovingPercentEncoding];
}


#pragma mark - Media
- (BOOL)isVideoType
{
    if ([[self.pathExtension lowercaseString] isEqualToString:@"mov"] ||
        [[self.pathExtension lowercaseString] isEqualToString:@"mp4"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isImageType
{
    if ([[self.pathExtension lowercaseString] isEqualToString:@"jpg"] ||
        [[self.pathExtension lowercaseString] isEqualToString:@"jpeg"] ||
        [[self.pathExtension lowercaseString] isEqualToString:@"png"] ||
        [[self.pathExtension lowercaseString] isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isAnimatedImage
{
    @autoreleasepool {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self] options:NSDataReadingMappedIfSafe error:nil];
        if (!data) {
            return NO;
        }
        CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        if (!imageSourceRef)
            return NO;
        size_t frameCount = CGImageSourceGetCount(imageSourceRef);
        return frameCount > 1;
    }
}

- (UIImage *)videoThumbnailWithSize:(CGSize)maxSize
{
    if (![self isVideoType]) {
        return nil;
    }
    
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self]];
    if (urlAsset == nil)
    {
        return nil;
    }
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    /* 如果不需要获取缩略图，就设置为NO，如果需要获取缩略图，则maximumSize为获取的最大尺寸。
     以BBC为例，getThumbnail = NO时，打印宽高数据为：1920*1072。
     getThumbnail = YES时，maximumSize为100*100。打印宽高数据为：100*55.
     注：不乘[UIScreen mainScreen].scale，会发现缩略图在100*100很虚。
     */
    imageGenerator.maximumSize = maxSize;
    NSError *error = nil;
    CMTime time = CMTimeMake(0, 1);
    CMTime actucalTime;
    CGImageRef cgimage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        return nil;
    }
//    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    return image;
}


- (UIImage *)imageThumbnailWithSize:(CGSize)maxSize
{
    if (![self isImageType])
    {
        return nil;
    }
    
    CGImageRef cgimage;
    CGImageSourceRef imageSource;
    CFDictionaryRef imageOptions;
    
    //创建 CGImageSourceRef 对象，URL为图片的本地路径，imageOptions 为参数的设置
    imageSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:self], NULL);
    
    if (imageSource == nil) {
        return nil;
    }
    
    CFNumberRef thumbSize;
    thumbSize = CFNumberCreate(NULL, kCFNumberIntType, &maxSize);
    
    //键值对，为创建 CFDictionaryRef 做准备
    CFStringRef imageKeys[3];
    CFTypeRef imageValues[3];
    
    imageKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    imageValues[0] = (CFTypeRef)kCFBooleanTrue;
    
    imageKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    imageValues[1] = (CFTypeRef)kCFBooleanTrue;
    
    //缩放键值对
    imageKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    imageValues[2] = (CFTypeRef)thumbSize;
    
    //设置参数，为创建 CGImageSourceRef 对象做准备
    imageOptions = CFDictionaryCreate(NULL, (const void **)imageKeys, (const void **)imageValues, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    //从 CGImageSourceRef 中获取 CGImageRef 对象
    cgimage = CGImageSourceCreateImageAtIndex(imageSource, 0, imageOptions);
    
    
    CFRelease(imageOptions);
    CFRelease(imageSource);
    CFRelease(thumbSize);
    
    //从 CGImageRef 中获取 UIImage 对象
    UIImage *imageResult=[UIImage imageWithCGImage:cgimage];
    
    CFRelease(cgimage);
    
    return imageResult;
}

+ (NSString *)parseCode:(NSString *)ipAddress {
    NSString *pinStr = ipAddress;
    NSString *ipStr;
    if (pinStr.length == 4) {
        NSString *ipFirst = [NSString stringFromHexString:[pinStr substringWithRange:NSMakeRange(0, 2)]];
        NSString *ipLast = [NSString stringFromHexString:[pinStr substringWithRange:NSMakeRange(2, 2)]];
        ipStr = [NSString stringWithFormat:@"192.168.%@.%@",ipFirst,ipLast];
        
    } else if (pinStr.length == 8) {
        NSString *ip1 = [NSString stringFromHexString:[pinStr substringWithRange:NSMakeRange(0, 2)]];
        NSString *ip2 = [NSString stringFromHexString:[pinStr substringWithRange:NSMakeRange(2, 2)]];
        NSString *ip3 = [NSString stringFromHexString:[pinStr substringWithRange:NSMakeRange(4, 2)]];
        NSString *ip4 = [NSString stringFromHexString:[pinStr substringWithRange:NSMakeRange(6, 2)]];
        ipStr = [NSString stringWithFormat:@"%@.%@.%@.%@",ip1,ip2,ip3,ip4];
    }
    return ipStr;
}

+ (NSString *)stringFromHexString:(NSString *)hexString {
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([hexString UTF8String], 0, 16)];
    return result;
}

+ (NSString *)decodeIP:(NSString *)ipAdreess {
    NSString *ipStr;
    if ([ipAdreess hasPrefix:@"192.168"]) {
        NSArray *ipArray = [ipAdreess componentsSeparatedByString:@"."];
        NSString *ipFirst = [self ToHex:[ipArray[2] intValue]];
        NSString *ipSecond = [self ToHex:[ipArray[3] intValue]];
        ipStr = [NSString stringWithFormat:@"%@%@",ipFirst,ipSecond];
    } else {
        NSArray *ipArray = [ipAdreess componentsSeparatedByString:@"."];
        NSString *ip1 = [self ToHex:[ipArray[0] intValue]];
        NSString *ip2 = [self ToHex:[ipArray[1] intValue]];
        NSString *ip3 = [self ToHex:[ipArray[2] intValue]];
        NSString *ip4 = [self ToHex:[ipArray[3] intValue]];
        ipStr = [NSString stringWithFormat:@"%@%@%@%@",ip1,ip2,ip3,ip4];
    }
    return ipStr;
}

+ (NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lld",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    if (str.length == 1) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}





@end

//
//  UIFont+WXExtention.m
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/7/18.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "UIFont+WXExtention.h"
#import <CoreText/CoreText.h>
@implementation UIFont (WXExtention)


+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider =CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}



@end

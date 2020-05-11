//
//  WXAVAnimatedImageUtil.m
//  WXAVEditor
//
//  Created by wangxutech-Ian on 2018/10/12.
//  Copyright © 2018年 wangxu. All rights reserved.
//

#import "WXAnimatedImageUtil.h"
#import <ImageIO/ImageIO.h>


@implementation WXAnimatedFrame

-(id)init
{
    if (self = [super init]){
    }
    return self;
}

-(void)dealloc
{
    self.sourceImage = nil;
}

@end

@implementation WXAnimatedImageUtil

+ (CAKeyframeAnimation *)frameAnimationFromFilePath:(NSString *)filePath {
    NSData *imageData = [[NSData alloc] initWithContentsOfFile: filePath];
    
    return [self frameAnimationWidthImageData:imageData];
}

+ (CAKeyframeAnimation *)frameAnimationWidthImageData:(NSData *)imageData {
    
    NSMutableArray *imageFrames = [NSMutableArray array];
    CGFloat totalTime;
    
    [self decodeWithImageData:imageData imageFrames:imageFrames totalTime:&totalTime];
    
    if (imageFrames.count == 0)
        return nil;
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
    NSMutableArray *times = [NSMutableArray arrayWithCapacity: 3];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity: 3];
    CGFloat currentTime = 0;
    for (int i = 0; i < imageFrames.count; ++i) {
        WXAnimatedFrame *imageFrame = imageFrames[i];
        [times addObject:[NSNumber numberWithFloat: (currentTime / totalTime)]];
        currentTime += imageFrame.delayTime;
        [images addObject: imageFrame.sourceImage];
    }
    [keyFrameAnimation setKeyTimes: times];
    
    [keyFrameAnimation setValues: images];
    [keyFrameAnimation setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
    keyFrameAnimation.duration = totalTime;
    keyFrameAnimation.repeatCount = HUGE_VALF;
    keyFrameAnimation.calculationMode = kCAAnimationLinear;
    keyFrameAnimation.removedOnCompletion = NO;
    
    return keyFrameAnimation;
}


+ (void)decodeWithImageData:(NSData*)imageData imageFrames:(NSMutableArray *)imageFrames totalTime:(CGFloat *)totaltime
{
    uint8_t c;
    BOOL isGIF = NO;
    [imageData getBytes:&c length:1];
    if (c == 0x47) {
        isGIF = YES;
    }
    CFStringRef propertyDictValue = kCGImagePropertyPNGDictionary;
    CFStringRef unclampedDelayValue = kCGImagePropertyAPNGUnclampedDelayTime;
    if (isGIF) {
        propertyDictValue = kCGImagePropertyGIFDictionary;
        unclampedDelayValue = kCGImagePropertyGIFUnclampedDelayTime;
    }
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!imageSourceRef)
        return;
    size_t frameCount = CGImageSourceGetCount(imageSourceRef);
    if (frameCount == 0){
        CFRelease(imageSourceRef);
        return;
    }
    
    [imageFrames removeAllObjects];
    
    CGFloat gifWidth = 0;
    CGFloat gifHeight = 0;
    CGFloat totalTime = 0;
    for (size_t i = 0; i < frameCount; ++i) {
        CGImageRef frameImage = CGImageSourceCreateImageAtIndex(imageSourceRef, i, NULL);
        if (!frameImage)
            continue;
        
        CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, NULL);
        if (gifWidth == 0 && gifHeight == 0) {
            gifWidth =  [(NSNumber*)CFDictionaryGetValue(imageInfo, kCGImagePropertyPixelWidth) floatValue];
            gifHeight = [(NSNumber*)CFDictionaryGetValue(imageInfo, kCGImagePropertyPixelHeight) floatValue];
        }
        
        CFDictionaryRef animationInfo = CFDictionaryGetValue(imageInfo, propertyDictValue);
        if (!animationInfo){
            CFRelease(frameImage);
            CFRelease(imageInfo);
            continue;
        }
        
        CGFloat unclampedDelayTime = [(NSNumber*)CFDictionaryGetValue(animationInfo, unclampedDelayValue) floatValue];
        if (unclampedDelayTime < 0.01) unclampedDelayTime = 0.1;
        if (unclampedDelayTime > 0.2) unclampedDelayTime = 0.1;
        
        totalTime += unclampedDelayTime;
        
        WXAnimatedFrame *imageFrame = [[WXAnimatedFrame alloc] init];
        imageFrame.delayTime = unclampedDelayTime;
        imageFrame.sourceImage = (__bridge id)(frameImage);
        
        [imageFrames addObject: imageFrame];
        CFRelease(imageInfo);
        CGImageRelease(frameImage);
    }
    CFRelease(imageSourceRef);
    if (imageFrames.count == 0)
        return;
    
    *totaltime = totalTime;
}

@end

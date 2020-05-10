//
//  WXAVAnimatedImageUtil.h
//  WXAVEditor
//
//  Created by wangxutech-Ian on 2018/10/12.
//  Copyright © 2018年 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXAnimatedFrame: NSObject{
}

@property (assign) CGFloat delayTime;
@property (strong) id sourceImage;

@end

@interface WXAnimatedImageUtil : NSObject

+ (CAKeyframeAnimation *)frameAnimationFromFilePath:(NSString *)filePath;

+ (CAKeyframeAnimation *)frameAnimationWidthImageData:(NSData *)imageData;

+ (void)decodeWithImageData:(NSData*)imageData imageFrames:(NSMutableArray *)imageFrames totalTime:(CGFloat *)totaltime;

@end


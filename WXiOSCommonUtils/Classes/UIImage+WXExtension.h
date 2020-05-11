//
//  UIImage+Extension.h
//  ApowerREC
//
//  Created by wangxutech-Ian on 2018/1/6.
//  Copyright © 2018年 wangxutech-Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WXExtension)

- (UIImage *)getImageApplyingAlpha:(float)theAlpha;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)fixOrientation;

- (UIImage *)getThumbnailsFromScaleSize:(CGSize)size;

- (UIImage *)circleImage;

- (UIImage *)scaleWithFactor:(float)scaleFloat;

- (UIImage *)scaleWithFactor:(float)scaleFloat quality:(CGFloat)compressionQuality;

- (BOOL)saveWithPath:(NSString *)path;

+(UIImage *)compressImageWith:(UIImage *)image;
@end

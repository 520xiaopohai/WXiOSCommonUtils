//
//  UIImage+Extension.m
//  ApowerREC
//
//  Created by wangxutech-Ian on 2018/1/6.
//  Copyright © 2018年 wangxutech-Ian. All rights reserved.
//

#import "UIImage+WXExtension.h"

@implementation UIImage (WXExtension)

- (UIImage *)getImageApplyingAlpha:(float)theAlpha
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:theAlpha];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
+(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
- (UIImage *)fixOrientation
{
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
            // No-op if the orientation is already correct
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            return self;
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma warning  ----- 需要手动释放内存
- (UIImage *)getThumbnailsFromScaleSize:(CGSize)size
{
    CGFloat selfHeight = self.size.height;
    CGFloat selfWidth = self.size.width;
    
    float heightRadio = size.height*1.0 / selfHeight;
    float widthRadio = size.width*1.0 / selfWidth;
    
    float radio = 1;
    
    if (heightRadio > 1 && widthRadio > 1)
    {
        radio = heightRadio > widthRadio ? widthRadio : heightRadio ;
    }
    else
    {
        radio = heightRadio < widthRadio ? widthRadio : heightRadio ;
    }
    
    CGFloat scaleWidth = radio * selfWidth;
    CGFloat scaleHeight = radio * selfHeight;
    
    UIImage *scaleImage = [self scaleToSize:CGSizeMake(scaleWidth, scaleHeight)];
    
    CGRect trimRect = CGRectMake((scaleWidth - size.width)/2.0 , (scaleHeight - size.height)/2.0, size.width, size.height);
    
    CGImageRef resultImageRef = CGImageCreateWithImageInRect([scaleImage CGImage], trimRect);
    
    UIImage *newImage = [[UIImage alloc] initWithCGImage:resultImageRef];
    
    CGImageRelease(resultImageRef);
    
    return newImage;
}

- (UIImage *)circleImage
{
    CGFloat w = self.size.width;
    CGFloat h  = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextScaleCTM(context, w/2.0, h/2.0);
    CGContextMoveToPoint(context, 2, 1);
    //曲线
    //    CGContextAddQuadCurveToPoint(context, 2, 2, 1, 2);
    //    CGContextAddQuadCurveToPoint(context, 0, 2, 0, 1);
    //    CGContextAddQuadCurveToPoint(context, 0, 0, 1, 0);
    //    CGContextAddQuadCurveToPoint(context, 2, 0, 2, 1);
    //圆形
    CGContextAddArcToPoint(context, 2, 2, 1, 2, 1);//current point is (1,2)
    CGContextAddArcToPoint(context, 0, 2, 0, 1, 1);//current point is (0,1)
    CGContextAddArcToPoint(context, 0, 0, 1, 0, 1);//current point is (1,0)
    CGContextAddArcToPoint(context, 2, 0, 2, 1, 1);
    
    //other
    //    CGContextMoveToPoint(context, 1, 2);
    //    CGContextAddArcToPoint(context, 0, 2, 0, 1, 1);
    //    CGContextAddArcToPoint(context, 0, 0, 1, 0, 1);
    //    CGContextAddArcToPoint(context, 2, 0, 2, 1, 1);
    //    CGContextAddArcToPoint(context, 2, 2, 1, 2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    CGContextClip(context);
    
    CGImageRef cgImage = [self CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), cgImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *tmpImage = [[UIImage alloc] initWithCGImage:imageMasked];
    
    return tmpImage;
}

#pragma mark -- 压缩图片

- (UIImage *)scaleWithFactor:(float)scaleFloat
{
    CGSize size = CGSizeMake(self.size.width * scaleFloat, self.size.height * scaleFloat);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformScale(transform, scaleFloat, scaleFloat);
    CGContextConcatCTM(context, transform);
    
    [self drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

- (UIImage *)scaleWithFactor:(float)scaleFloat quality:(CGFloat)compressionQuality
{
    CGSize size = CGSizeMake(self.size.width * scaleFloat, self.size.height * scaleFloat);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformScale(transform, scaleFloat, scaleFloat);
    CGContextConcatCTM(context, transform);
    
    [self drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imagedata = UIImageJPEGRepresentation(newimg,compressionQuality);
    
    return [UIImage imageWithData:imagedata] ;
}

- (BOOL)saveWithPath:(NSString *)path
{
    NSData *data = UIImagePNGRepresentation(self);
    return [data writeToFile:path atomically:YES];
}

@end

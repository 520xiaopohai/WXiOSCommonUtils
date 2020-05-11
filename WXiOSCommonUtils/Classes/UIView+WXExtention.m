//
//  UIView+Extention.m
//  ApowerEdit
//
//  Created by wangxutech-Ian on 2018/10/22.
//  Copyright © 2018年 wangxutech-Ian. All rights reserved.
//

#import "UIView+WXExtention.h"

@implementation UIView (WXExtention)

- (void)setWx_x:(CGFloat)wx_x
{
    CGRect frame = self.frame;
    frame.origin.x = wx_x;
    self.frame = frame;
}

- (CGFloat)wx_x
{
    return self.frame.origin.x;
}

- (void)setWx_y:(CGFloat)wx_y
{
    CGRect frame = self.frame;
    frame.origin.y = wx_y;
    self.frame = frame;
}

- (CGFloat)wx_y
{
    return self.frame.origin.y;
}

- (void)setWx_w:(CGFloat)wx_w
{
    CGRect frame = self.frame;
    frame.size.width = wx_w;
    self.frame = frame;
}

- (CGFloat)wx_w
{
    return self.frame.size.width;
}

- (void)setWx_h:(CGFloat)wx_h
{
    CGRect frame = self.frame;
    frame.size.height = wx_h;
    self.frame = frame;
}

- (CGFloat)wx_h
{
    return self.frame.size.height;
}

- (void)setWx_size:(CGSize)wx_size
{
    CGRect frame = self.frame;
    frame.size = wx_size;
    self.frame = frame;
}

- (CGSize)wx_size
{
    return self.frame.size;
}

- (void)setWx_origin:(CGPoint)wx_origin
{
    CGRect frame = self.frame;
    frame.origin = wx_origin;
    self.frame = frame;
}

- (CGPoint)wx_origin
{
    return self.frame.origin;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (UIViewController*)wx_viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}



@end

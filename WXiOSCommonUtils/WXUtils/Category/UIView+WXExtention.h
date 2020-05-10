//
//  UIView+Extention.h
//  ApowerEdit
//
//  Created by wangxutech-Ian on 2018/10/22.
//  Copyright © 2018年 wangxutech-Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WXExtention)

@property (assign, nonatomic) CGFloat wx_x;
@property (assign, nonatomic) CGFloat wx_y;
@property (assign, nonatomic) CGFloat wx_w;
@property (assign, nonatomic) CGFloat wx_h;
@property (assign, nonatomic) CGSize wx_size;
@property (assign, nonatomic) CGPoint wx_origin;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat right;

- (UIViewController*)wx_viewController;

@end

NS_ASSUME_NONNULL_END

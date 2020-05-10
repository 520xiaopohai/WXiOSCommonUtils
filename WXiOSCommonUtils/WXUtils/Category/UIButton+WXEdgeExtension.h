//
//  UIButton+EdgeExtension.h
//  ApowerEdit-iOS
//
//  Created by wangxutech-Ian on 2018/11/21.
//  Copyright © 2018 wangxutech-Ian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (WXEdgeExtension)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end

NS_ASSUME_NONNULL_END

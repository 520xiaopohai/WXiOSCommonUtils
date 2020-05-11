//
//  UIButton+imageTextEdgeInsets.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/4/15.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WXButtonEdgeInsetsStyle_Top,
    WXButtonEdgeInsetsStyle_Left,
    WXButtonEdgeInsetsStyle_Right,
    WXButtonEdgeInsetsStyle_Bottom
} WXButtonEdgeInsetsStyle;

/*
 1、titleEdgeInsets是titleLabel相对于其上下左右的inset，跟tableView的contentInset是类似的；
 2、如果只有title，那titleLabel的 上下左右 都是 相对于Button 的；
 3、如果只有image，那imageView的 上下左右 都是 相对于Button 的；
 4、如果同时有image和label，那image的 上下左 是 相对于Button 的，右 是 相对于label 的；
 5、label的 上下右 是 相对于Button的， 左 是 相对于image 的。
  */
@interface UIButton (imageTextEdgeInsets)

- (void)layoutButtonContentWithEdgeInsetsStyle:(WXButtonEdgeInsetsStyle)insetsStyle withImageAndTitleSpace:(CGFloat)space;

@end


//
//  UIButton+imageTextEdgeInsets.m
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/4/15.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "UIButton+imageTextEdgeInsets.h"
#import "NSString+WXExtension.h"

@implementation UIButton (imageTextEdgeInsets)

- (void)layoutButtonContentWithEdgeInsetsStyle:(WXButtonEdgeInsetsStyle)insetsStyle withImageAndTitleSpace:(CGFloat)space
{
    int imageWidth = self.imageView.frame.size.width;
    int imageHeight = self.imageView.frame.size.height;
    
    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.frame.size.width, NSIntegerMax)];
    CGFloat labelWidth = labelSize.width;
    CGFloat labelHeight = labelSize.height;
//    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
//    if (version.doubleValue >= 8.0)
//    {
//        labelWidth = self.titleLabel.intrinsicContentSize.width;
//        labelHeight = self.titleLabel.intrinsicContentSize.height;
//    }
//    else
//    {
//        labelWidth = self.titleLabel.frame.size.width;
//        labelHeight = self.titleLabel.frame.size.height;
//    }
    //初始化imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    //上 左 下 右
    switch (insetsStyle)
    {
        case WXButtonEdgeInsetsStyle_Top:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-space, (self.frame.size.width - imageWidth)/2, 0,0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight - space/2, 0);
            break;
        }
        case WXButtonEdgeInsetsStyle_Left:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0 ,space);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2, 0, -space/2);
            break;
        }
        case WXButtonEdgeInsetsStyle_Bottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0 ,-labelHeight - space/2, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - space/2, -imageWidth, 0, 0);
            break;
        }
        case WXButtonEdgeInsetsStyle_Right:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space/2 ,0, -labelWidth - space/2);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - space/2, 0, imageWidth + space/2);
            break;
        }
    }
//    self.titleEdgeInsets = labelEdgeInsets;
    self.imageView.frame = CGRectMake((self.frame.size.width - imageWidth)/2, space/2, imageWidth, imageHeight);
//    self.imageEdgeInsets = imageEdgeInsets;
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake((self.frame.size.width - labelWidth)/2, (CGRectGetHeight(self.frame) - CGRectGetMaxY(self.imageView.frame) - labelHeight) * 0.5 + CGRectGetMaxY(self.imageView.frame), labelWidth, labelHeight);
}

@end

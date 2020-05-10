//
//  UIImageView+WXAnimated.m
//  WXiOSCommonUtils
//
//  Created by ian-mac on 2020/3/6.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "UIImageView+WXAnimated.h"
#import "WXAnimatedImageUtil.h"

@implementation UIImageView (WXAnimated)

- (void)wx_animtedImageWithFilePath:(NSString *)filePath
{
    CAKeyframeAnimation *gifAnimation = [WXAnimatedImageUtil frameAnimationFromFilePath:filePath];
    [self.layer addAnimation:gifAnimation forKey:@"animation"];
}

@end

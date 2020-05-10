//
//  WXAlertView.h
//  Apowersoft IOS AirMore
//
//  Created by wangxutech on 16/3/4.
//  Copyright © 2016年 Joni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXAlertView : UIView
{
    NSString *_message;
    UIImage *_leftImage;
    
    bool _bShowLeftImage;
}

@property (strong,nonatomic) UILabel *messageLabel;
@property (strong,nonatomic) UIImageView *bgView;
@property (strong,nonatomic) UIImageView *centerView;
@property (strong,nonatomic) UIImageView *leftImageView;

- (id)initWithImage:(UIImage *)leftImage andMessage:(NSString *)message bShowLeftImage:(bool)bShowLeftImage;
/**
 *  增加菊花转
 */
- (void)addActivity;
- (void)dismiss ;
- (void)dismissWithDelayTime:(NSTimeInterval )delayTime;
- (void)startAnimate;
- (void)setMesssage:(NSString*)strMessage;
/*默认居中,设置y轴距离中心的偏移量*/
- (void)setYOffset:(CGFloat)yOffset;

@end

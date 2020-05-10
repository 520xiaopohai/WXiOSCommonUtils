//
//  WXAlertView.m
//  Apowersoft IOS AirMore
//
//  Created by wangxutech on 16/3/4.
//  Copyright © 2016年 Joni. All rights reserved.
//

#import "WXAlertView.h"
#import "WXCommTools.h"

#define LEFT_IMAGE_WIDTH 20
#define LEFT_IMAGE_HEIGHT 20

#define LEFT_RIGHT_PADDING 10 
#define TOP_BUTTOM_PADDING 10

#define H_INTERVAL 8

#define LABLE_HEIGHT 30

@interface WXAlertView ()

@property (nonatomic, weak) UIActivityIndicatorView *activity;

@end

@implementation WXAlertView

@synthesize bgView = _bgView;
@synthesize messageLabel = _messageLabel;
@synthesize centerView = _centerView;

- (id)initWithImage:(UIImage *)leftImage andMessage:(NSString *)message bShowLeftImage:(bool)bShowLeft
{
    self = [super init];
    if (self) {
        _message = [message copy];
        _leftImage = leftImage ;
        _bShowLeftImage = bShowLeft ;
        [self bulidAlertView:_bShowLeftImage];
    }
    return self;
}

- (void)bulidAlertView:(bool)bShowLeftImage
{
    CGRect screen = [[UIScreen mainScreen]bounds];
    
    self.frame = CGRectMake(0,0,screen.size.width,screen.size.height);
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows lastObject];
    int i = (int)windows.count -1;
    while (i >= 0)
    {
        i--;
        if (i < 0)
        {
            i = 0;
        }
        window = [windows objectAtIndex:i];
        if ([window isKindOfClass:[UIWindow class]])
        {
            break;
        }
    }
    
    [window addSubview:self];
    
    //模糊视图
    _bgView = [[UIImageView alloc] initWithFrame:self.frame];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.alpha = 0.52f;
    
    int contentWidth = 110 ;
    int contentHeight = 50 ;
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
    _centerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    _centerView.layer.cornerRadius = 8;
    _centerView.userInteractionEnabled = YES;
    _centerView.layer.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.5].CGColor;
    _centerView.layer.shadowOffset = CGSizeMake(0, 0);
    _centerView.layer.shadowOpacity = 0.5;
    _centerView.layer.shadowRadius = 10.0;
    
    [self addSubview:_bgView];
    [self addSubview:_centerView];
    
    if(bShowLeftImage){
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_RIGHT_PADDING, (_centerView.frame.size.height - LEFT_IMAGE_HEIGHT)/2, LEFT_IMAGE_WIDTH, LEFT_IMAGE_HEIGHT)];
        _leftImageView.image = _leftImage;
        [_centerView addSubview:_leftImageView];
    }
    
    int x = _leftImageView.frame.origin.x + _leftImageView.frame.size.width + H_INTERVAL ;
    if(!bShowLeftImage){
        x = LEFT_RIGHT_PADDING ;
    }
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, TOP_BUTTOM_PADDING, screen.size.width - 2*x, LABLE_HEIGHT)];
    _messageLabel.font = [UIFont systemFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentCenter ;
    _messageLabel.lineBreakMode = NSLineBreakByCharWrapping ;
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = _message;
    [_centerView addSubview:_messageLabel];
    
    CGRect frame = _messageLabel.frame ;
    frame.size.width = [WXCommTools sizeForString:_messageLabel.text font:_messageLabel.font].width;
    if (frame.size.width > screen.size.width - 2*x) {
        frame.size.width = screen.size.width-2*x;
         frame.size.height = [WXCommTools sizeForString:_messageLabel.text font:_messageLabel.font width:(screen.size.width-2*x)].height ;
    }
    _messageLabel.frame = frame ;
    
    [self adjustView];
}


- (void)addActivity
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
    
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    activity.color = [UIColor whiteColor];
    
    activity.frame = CGRectMake(0,0,100,50);
    
    CGRect frame = _centerView.frame;
    
    if (frame.size.width < activity.frame.size.width) {
        frame.size.width = activity.frame.size.width;
    }
    
    frame.size.height = frame.size.height + activity.frame.size.height;
    
    _centerView.frame = frame;
    
    _centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
    frame = activity.frame;
    
    frame.origin.x = (_centerView.frame.size.width - frame.size.width) * 0.5;
    frame.origin.y = 8;
    
    activity.frame = frame;
    
    
    [_centerView addSubview:activity];
    
    self.activity = activity;
    
    
    frame = _messageLabel.frame;
    
    frame.size.width = _centerView.frame.size.width;
    
    frame.size.height = _centerView.frame.size.height - activity.frame.size.height;
    
    frame.origin.y = CGRectGetMaxY(activity.frame);
    
    frame.origin.x = 0;
    
    _messageLabel.frame = frame;
    
}

- (void)setMesssage:(NSString*)strMessage
{
    _messageLabel.text = strMessage ;
    
    CGRect frame = _messageLabel.frame ;
    frame.size.width = [WXCommTools sizeForString:_messageLabel.text font:_messageLabel.font].width ;
    _messageLabel.frame = frame ;
    
    [self adjustView];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        _centerView.maskView.alpha = 0;
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        _centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _centerView.alpha = 0;
            _centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        } completion:^(BOOL finished2){
            [self removeFromSuperview];
        }];
    }];
}

- (void)dismissWithDelayTime:(NSTimeInterval )delayTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:delayTime];
    });
}

- (void)startAnimate
{
    
    if (self.activity) {
        [self.activity startAnimating];
    }
    
    
    _centerView.maskView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _centerView.maskView.alpha = 1;
    }];
    
    _centerView.alpha = 0;
    _centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    [UIView animateWithDuration:0.2 animations:^{
        _centerView.alpha = 1;
        _centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _centerView.alpha = 1;
            _centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished2) {}];
    }];
}

- (void)adjustView
{
    CGRect centerNew = _centerView.frame;
    
    if(_bShowLeftImage){
        centerNew.size.width = _messageLabel.frame.size.width + LEFT_IMAGE_WIDTH + 2 * LEFT_RIGHT_PADDING + H_INTERVAL;
        NSInteger maxHeight = MAX(_leftImageView.frame.size.height, _messageLabel.frame.size.height);
        centerNew.size.height = maxHeight + 2 * TOP_BUTTOM_PADDING ;
    }else{
        centerNew.size.width = _messageLabel.frame.size.width + 2 * LEFT_RIGHT_PADDING ;
        centerNew.size.height = _messageLabel.frame.size.height + 2 * TOP_BUTTOM_PADDING ;
    }
    
    _centerView.frame = centerNew;
    _centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100);
    
    CGRect frame = _leftImageView.frame ;
    frame.origin.y = (_centerView.frame.size.height - LEFT_IMAGE_HEIGHT)/2 ;
    _leftImageView.frame = frame ;
    
    frame = _messageLabel.frame ;
    frame.origin.y = (_centerView.frame.size.height - _messageLabel.frame.size.height)/2 ;
    _messageLabel.frame = frame ;
    
    
}

- (void)setYOffset:(CGFloat)yOffset {
    self.centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - yOffset);
}

@end


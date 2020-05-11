//
//  WXTimerAlertView.m
//  PhoneTransfer
//
//  Created by wangxutech on 16/7/26.
//  Copyright © 2016年 Apowersoft. All rights reserved.
//

#import "WXTimerAlertView.h"

@interface WXTimerAlertView()
{
    
}
@property(nonatomic,strong)alertBlock mAlertBlock;

@end

@implementation WXTimerAlertView
{
    UIImageView *_bgView;
    UIImageView *_centerView;
    
    NSInteger timeOut ;
    
    NSString *titleStr;
    NSString *messageStr;
    NSString *cancelTitle;
    NSString *confirmTitle;
    
    UIButton *cancelButton;
    UIButton *comfirmButton;
    
    UILabel *titleLabel;
    UILabel *messageLabel;
    
    UIView *line1;
    UIView *line2;
    
    NSTimer *timer ;
}

@synthesize mAlertBlock ;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitles:(NSString *)okButtonTitles timeout:(NSInteger)time handler:(void (^)(NSInteger, NSDictionary *))blockHandler
{
    self = [super init];
    if(self){
        
        mAlertBlock = blockHandler;
        
        timeOut = time ;
        
        confirmTitle = okButtonTitles ;
        cancelTitle = cancelButtonTitle ;
        titleStr = title ;
        messageStr = message ;
        
        [self buildAlertView] ;
    }
    
    return self;
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)buildAlertView
{
    CGRect screen = [[UIScreen mainScreen]bounds];
    
    self.frame = CGRectMake(0,0,screen.size.width,screen.size.height);
    
    NSInteger titleViewH = 15 ;
    NSInteger messageViewH = 60 ;
    
    NSInteger intervalV = 5 ;
    NSInteger intervalH = 5 ;
    
    NSInteger tbPadding = 10 ;
    NSInteger lrPadding = 5 ;
    
    NSInteger alertViewW = 280 ;
    
    NSInteger buttonW = (alertViewW - 2 * lrPadding) / 2 ;
    NSInteger buttonH = 30 ;
    
    NSInteger alertViewH = 2 * tbPadding + titleViewH + buttonH + 2 * intervalH ;
    
    if(messageStr== nil || [messageStr isEqualToString:@""]){
        titleViewH = 60 ;
        alertViewH = 2 * tbPadding + titleViewH + buttonH + intervalH ;
    }else{
        titleViewH = 15 ;
        alertViewH = 2 * tbPadding + titleViewH + messageViewH + buttonH + 2 * intervalH ;
    }
    
    //模糊视图
    _bgView = [[UIImageView alloc]initWithFrame:self.bounds];
    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _bgView.userInteractionEnabled = YES ;
    [self addSubview:_bgView];

    _centerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, alertViewW, alertViewH)];
    [_centerView setBackgroundColor:[UIColor whiteColor]];
    [_centerView.layer setCornerRadius:10];
    [_centerView.layer setMasksToBounds:YES];
    [_centerView setCenter:_bgView.center];
    [_centerView setUserInteractionEnabled:YES];
    [_bgView addSubview:_centerView];
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = _centerView.bounds;
//    [_centerView insertSubview:effectview atIndex:0];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(lrPadding, tbPadding, alertViewW - 2 * lrPadding, titleViewH)];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter ;
    titleLabel.text = titleStr ;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
    [_centerView addSubview:titleLabel];
    
    if(messageStr && ![messageStr isEqualToString:@""]){
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(lrPadding, titleLabel.frame.origin.y + titleLabel.frame.size.height + intervalV,alertViewW - 2 * lrPadding , messageViewH)];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.textAlignment = NSTextAlignmentCenter ;
        messageLabel.text = messageStr ;
        messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        messageLabel.numberOfLines = 0;
        [_centerView addSubview:messageLabel];
    }
    
    if(messageStr && ![messageStr isEqualToString:@""]){
        line1 = [[UIView alloc]initWithFrame:CGRectMake(0, messageLabel.frame.origin.y + messageLabel.frame.size.height + intervalV / 2 + 3, alertViewW, 1)];
    }else{
        line1 = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + intervalV / 2 + 3, alertViewW, 1)];
    }
    [line1 setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    [_centerView addSubview:line1];
    
    NSString *cancelTitleStr = [NSString stringWithFormat:@"%@(%ld)",cancelTitle,timeOut];
    CGRect frame = CGRectMake(lrPadding, titleLabel.frame.origin.y + titleLabel.frame.size.height + intervalV + 5, buttonW, buttonH) ;
    if(messageStr && ![messageStr isEqualToString:@""]){
        frame = CGRectMake(lrPadding, messageLabel.frame.origin.y + messageLabel.frame.size.height + intervalV + 5, buttonW, buttonH) ;
    }
    cancelButton = [[UIButton alloc]initWithFrame:frame];
    [cancelButton setTitle:cancelTitleStr forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setTitleColor:[UIColor colorWithRed:21.0/255.0 green:125.0/255.0 blue:252.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:cancelButton];
    
    frame = CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + intervalH / 2, titleLabel.frame.origin.y + titleLabel.frame.size.height + intervalV+ 3, 1, alertViewH - titleLabel.frame.origin.y + titleLabel.frame.size.height + intervalV);
    if(messageStr && ![messageStr isEqualToString:@""]){
        frame = CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + intervalH / 2, messageLabel.frame.origin.y + messageLabel.frame.size.height + intervalV + 3, 1, alertViewH - messageLabel.frame.origin.y + messageLabel.frame.size.height + intervalV);
    }
    line2 = [[UIView alloc]initWithFrame:frame];
    [line2 setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    [_centerView addSubview:line2];
    
    comfirmButton = [[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + intervalH, cancelButton.frame.origin.y, buttonW, buttonH)];
    [comfirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [comfirmButton setBackgroundColor:[UIColor clearColor]];
    [comfirmButton setTitleColor:[UIColor colorWithRed:21.0/255.0 green:125.0/255.0 blue:252.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:comfirmButton];
}

- (void)cancelButtonClick
{
    self.mAlertBlock(0,nil);
    
    [self stopTimer];
    [self dismiss];
}

- (void)comfirmButtonClick
{
    self.mAlertBlock(1,nil);
    
    [self stopTimer];
    [self dismiss];
}

- (void)startTimer
{
    [self stopTimer];
    
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCancelTitle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}

- (void)stopTimer
{
    if(timer && [timer isValid]){
        [timer invalidate];
        timer = nil ;
    }
}

- (void)updateCancelTitle
{
    if(timeOut){
        NSString *cancelTitleStr = [NSString stringWithFormat:@"%@(%ld)",cancelTitle,timeOut];
        [cancelButton setTitle:cancelTitleStr forState:UIControlStateNormal];
        timeOut -- ;
    }else{
        self.mAlertBlock(0,nil);
        
        [self stopTimer];
        [self dismiss];
    }
}

- (void)dismiss
{
    [self stopTimer];
    
    [UIView animateWithDuration:0.2 animations:^{
        _centerView.alpha = 0 ;
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

- (void)startAnimate
{
    [[[[UIApplication sharedApplication]delegate] window] addSubview:self];
    
    [self startTimer];
    
    _centerView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _centerView.alpha = 1;
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
        } completion:^(BOOL finished2) {
        }];
    }];
}

@end

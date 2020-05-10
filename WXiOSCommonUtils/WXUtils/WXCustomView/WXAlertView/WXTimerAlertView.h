//
//  WXTimerAlertView.h
//  PhoneTransfer
//
//  Created by wangxutech on 16/7/26.
//  Copyright © 2016年 Apowersoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^alertBlock)(NSInteger buttonIndex , NSDictionary *userInfo);

@interface WXTimerAlertView : UIView

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitles:(NSString *)okButtonTitles timeout:(NSInteger)timeOut handler:(void (^)(NSInteger, NSDictionary *))blockHandler;

- (void)startAnimate;

@end

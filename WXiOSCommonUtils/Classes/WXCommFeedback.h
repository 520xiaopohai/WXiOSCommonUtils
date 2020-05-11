//
//  WXCommFeedback.h
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCommSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXCommFeedback : NSObject

+ (WXFeedbackState)state;

+ (NSString *)notificationName;

+ (NSInteger)feedbackSendType;

+ (void)addLogFiles:(NSArray *)logPaths;
+ (void)addFeedbackDescription:(NSString *)description;

+ (void)startSubmitFeedback:(NSString *)userEmail;


@end

NS_ASSUME_NONNULL_END

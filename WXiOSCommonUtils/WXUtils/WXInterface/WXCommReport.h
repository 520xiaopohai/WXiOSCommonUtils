//
//  CommReport.h
//  WXCommonUtils
//
//  Created by wangxu on 15/12/24.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCommSettings.h"

@interface WXCommReport : NSObject
+ (WXReportState)State;
+ (NSString *)notificationName;

+ (void)save;
+ (void)startReportWithUserEmail:(NSString *)email;

@end

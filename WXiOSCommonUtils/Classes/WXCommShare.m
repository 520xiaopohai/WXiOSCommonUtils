//
//  CommShare.m
//  WXCommonTools
//
//  Created by Joni.li on 2020/1/10.
//  Copyright © 2020 fingerfinger. All rights reserved.
//

#import "WXCommShare.h"
#import "WXAppSysShareController.h"

@implementation WXCommShare

+ (void)ShowAppSystemShareWithMetaData:(CommShareAppSysMetaData *)metaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect
{
    [WXAppSysShareController showShareWithMetaData:metaData withParentViewController:parentController showInSourceRect:sourceRect];
}

+ (void)ShowAppSystemShareWithMetaData:(CommShareAppSysMetaData *)metaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect completed:(WXCommShareCompletionHandler)completedHandler
{
    [WXAppSysShareController showShareWithMetaData:metaData withParentViewController:parentController showInSourceRect:sourceRect completed:^(NSString *activityType, BOOL completed) {
        if (completedHandler) {
            completedHandler(activityType,completed);
        }
    }];
}
@end

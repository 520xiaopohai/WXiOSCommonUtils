//
//  WXAppSysShareController.h
//  WXCommonTools
//
//  Created by Joni.li on 2020/1/10.
//  Copyright © 2020 fingerfinger. All rights reserved.
//

#import <UIKit/UIKit.h>

//App 调用系统的分享接口
@class CommShareAppSysMetaData;
typedef void (^WXAppSysShareControllerCompletionHandler)(NSString* activityType, BOOL completed);
@interface WXAppSysShareController : NSObject

+ (void)showShareWithMetaData:(CommShareAppSysMetaData *)shareMetaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect;

/// 调用分享面板
/// @param shareMetaData 分享参数
/// @param parentController 当前控制器
/// @param sourceRect 源frame
/// @param completionHandler 点击分享面板的回调
+ (void)showShareWithMetaData:(CommShareAppSysMetaData *)shareMetaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect completed:(WXAppSysShareControllerCompletionHandler )completionHandler;

@end

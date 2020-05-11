//
//  CommShare.h
//  WXCommonTools
//
//  Created by Joni.li on 2020/1/10.
//  Copyright © 2020 fingerfinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCommShareMetaData.h"

typedef void (^WXCommShareCompletionHandler)(NSString* activityType, BOOL completed);

@interface WXCommShare : NSObject

+ (void)ShowAppSystemShareWithMetaData:(WXCommShareAppSysMetaData *)metaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect;

/// 调用分享面板
/// @param metaData 分享参数
/// @param parentController 当前控制器
/// @param sourceRect 源frame
/// @param completedHandler 点击分享面板的回调
+ (void)ShowAppSystemShareWithMetaData:(WXCommShareAppSysMetaData *)metaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect completed:(WXCommShareCompletionHandler)completedHandler;
@end

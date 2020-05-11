//
//  WXAppSysShareController.m
//  WXCommonTools
//
//  Created by Joni.li on 2020/1/10.
//  Copyright © 2020 fingerfinger. All rights reserved.
//

#import "WXAppSysShareController.h"
#import "WXCommShareMetaData.h"
#import "WXCommLog.h"
#import "WXCommDevice.h"

@implementation WXAppSysShareController

+ (void)showShareWithMetaData:(WXCommShareAppSysMetaData *)shareMetaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect
{
    @try {
        
        if (shareMetaData == nil)
        {
            [WXCommLog LogE:@"调用系统分享失败，未设置shareMetaData"];
            return;
        }
        //init activityItems
        NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:0];
        
        //add text
        NSString *textToShare = shareMetaData.shareMessage;
        if (textToShare && textToShare.length > 0)
        {
            [activityItems addObject:textToShare];
        }
        // add icon
        UIImage *iconToShare = shareMetaData.shareIcon;
        if (iconToShare != nil)
        {
            [activityItems addObject:iconToShare];
        }
        //add url
        NSURL *urlToShare = shareMetaData.sharedURL;
        if (urlToShare != nil)
        {
            [activityItems addObject:urlToShare];
        }
        
        UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        if([WXCommDevice getDeviceType] == iPadType_ALL)
        {
            shareViewController.modalPresentationStyle = UIModalPresentationPopover;
            if([shareViewController respondsToSelector:@selector(popoverPresentationController)]) {
                shareViewController.popoverPresentationController.sourceView = parentController.view;
                shareViewController.popoverPresentationController.sourceRect = sourceRect;
            }
            [parentController presentViewController:shareViewController animated:YES completion:nil];
        }else{
            [parentController presentViewController:shareViewController animated:YES completion:nil];
        }
    } @catch (NSException *exception) {
        [WXCommLog LogEx:exception];
    }
}

/// 调用分享面板
+ (void)showShareWithMetaData:(WXCommShareAppSysMetaData *)shareMetaData withParentViewController:(UIViewController *)parentController showInSourceRect:(CGRect)sourceRect completed:(WXAppSysShareControllerCompletionHandler )completionHandler
{
    @try {
        
        if (shareMetaData == nil)
        {
            [WXCommLog LogE:@"调用系统分享失败，未设置shareMetaData"];
            return;
        }
        //init activityItems
        NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:0];
        
        //add text
        NSString *textToShare = shareMetaData.shareMessage;
        if (textToShare && textToShare.length > 0)
        {
            [activityItems addObject:textToShare];
        }
        // add icon
        UIImage *iconToShare = shareMetaData.shareIcon;
        if (iconToShare != nil)
        {
            [activityItems addObject:iconToShare];
        }
        //add url
        NSURL *urlToShare = shareMetaData.sharedURL;
        if (urlToShare != nil)
        {
            [activityItems addObject:urlToShare];
        }
        
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
                if ([activityType isEqualToString:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
                    
                }
            }
            else
            {
                NSLog(@"cancel");
            }

            if (completionHandler) {
                completionHandler(activityType,completed);
            }
            
        };
        
        UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        shareViewController.completionWithItemsHandler = myBlock;
        if([WXCommDevice getDeviceType] == iPadType_ALL)
        {
            shareViewController.modalPresentationStyle = UIModalPresentationPopover;
            if([shareViewController respondsToSelector:@selector(popoverPresentationController)]) {
                shareViewController.popoverPresentationController.sourceView = parentController.view;
                shareViewController.popoverPresentationController.sourceRect = sourceRect;
            }
            [parentController presentViewController:shareViewController animated:YES completion:nil];
        }else{
            [parentController presentViewController:shareViewController animated:YES completion:nil];
        }
    } @catch (NSException *exception) {
        [WXCommLog LogEx:exception];
    }
}

@end

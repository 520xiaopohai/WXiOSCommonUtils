//
//  WXAccountWebBridge.h
//  WXiOSCommonUtils
//
//  Created by ian-mac on 2020/2/25.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WXAccountBridgeExport <JSExport>


/**
 是否网络连接
 
 @return TRUE/FALSE
 */
- (Boolean)isNetConnect;


/**
 当前是否是wifi网络
 
 @return TRUE/FALSE
 */
- (Boolean)isWifiConnect;


/**
 注册成功回调
 */
- (void)onRegister;

/**
 Web获取登录信息
 
 @return 登录信息
 */
- (NSString *)getData;

/**
 Web模块登录成功回调该接口
 
 @param cookies 登录信息
 */
- (void)onLogin:(NSString *)cookies;

/**
 Web模块注销成功回调该接口
 */
- (void)onLogout;


/**
 Web模块回退到原生界面
 */
- (void)onBackToNative;


/**
 Web模块回退到原生界面
 */
- (void)onDataChanged:(NSString *)msg;


/**
 跳转到指定页面
 */
- (void)onWebJump;


/**
 分享内容
 */
- (void)onShare;

/**
 web端log
 
 @param log 日志
 */
- (void)onSaveLog:(NSString *)log;

@end

typedef void (^WXAccountLoginnedBlock)(NSString *idToken);

typedef void (^WXShareBlock)(NSString *openApp, NSString *content);

typedef void (^WXWebJumpBlock)(NSString *modelName, NSString *subject,NSString *content);

@interface WXAccountWebBridge : NSObject<WXAccountBridgeExport>

@property (nonatomic, weak) JSContext *jsContext;

@property (nonatomic, copy) dispatch_block_t logoutBlock;

@property (nonatomic, copy) dispatch_block_t backToNativeBlock;

@property (nonatomic, copy) dispatch_block_t registerBlock;

@property (nonatomic, copy) WXAccountLoginnedBlock loginnedBlock;

//页面跳转
@property (nonatomic, copy) WXWebJumpBlock webJumpBlock;

@property (nonatomic, copy) WXShareBlock shareBlock;

@end



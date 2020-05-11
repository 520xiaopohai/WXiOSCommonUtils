//
//  WXAccountWebBridge.m
//  WXiOSCommonUtils
//
//  Created by ian-mac on 2020/2/25.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXAccountWebBridge.h"
#import "WXAccountTools.h"
#import <AFNetworking/AFNetworking.h>
//#import "../Utils/AFNetworking/AFNetworkReachabilityManager.h"

@implementation WXAccountWebBridge

- (NSString *)getData {
    return [WXAccountTools getAccountCookies];
}

- (void)onLogin:(NSString *)cookies {
    NSData *data = [cookies dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *identityToken = dict[@"identity_token"];
    
    [WXAccountTools setAccountCookies:cookies];
    
    if (identityToken) {
        [WXAccountTools setAccountIdentityToken:identityToken];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loginnedBlock ? self.loginnedBlock(identityToken) : nil;
        });
    }
}

- (void)onLogout {
    [WXAccountTools setAccountCookies:nil];
    [WXAccountTools setAccountIdentityToken:nil];
    self.logoutBlock ? self.logoutBlock() : nil;
}

- (void)onBackToNative {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backToNativeBlock ? self.backToNativeBlock() : nil;
    });
}

- (void)setLoginnedBlock:(void (^)(NSString *))block {
    _loginnedBlock = block;
}

- (void)onDataChanged:(NSString *)msg {
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *identityToken = dict[@"identity_token"];
    if (identityToken) {
        [WXAccountTools setAccountIdentityToken:identityToken];
    }
    [WXAccountTools setAccountCookies:msg];
}

- (void)onWebJump {
    id args = [JSContext currentArguments];
    if ([args isKindOfClass:[NSArray class]]) {
        if (((NSArray *)args).count > 3) {
            JSValue *modelName = args[0];
            JSValue *toModelName = args[1];
            JSValue *path = args[2];
            JSValue *parameter = args[3];
            [self jumpToModel:[toModelName toString] path:[path toString] parameter:[parameter toString]];
        }
    }
    NSLog(@"account onWebJump args:%@",args);
}

- (void)jumpToModel:(NSString *)modelName path:(NSString *)path parameter:(NSString *)parameter {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.webJumpBlock ? self.webJumpBlock(modelName,path,parameter) : nil;
    });
}

- (void)onShare {
    id args = [JSContext currentArguments];
    if ([args isKindOfClass:[NSArray class]]) {
        if (((NSArray *)args).count > 1) {
            JSValue *appName = args[0];
            JSValue *content = args[1];
            [self share:[appName toString] content:[content toString]];
        }
    }
}

- (void)share:(NSString *)openApp content:(NSString *)content {
    NSLog(@"分享:%@,content:%@",openApp,content);
    self.shareBlock ? self.shareBlock(openApp,content) : nil;
}

#pragma - mark 网络状态

- (Boolean)isNetConnect {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    return manager.isReachable;
}

- (Boolean)isWifiConnect {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    return manager.reachableViaWiFi;
}

- (void)onRegister {
    self.registerBlock ? self.registerBlock() : nil;
}

- (void)onSaveLog:(NSString *)log {
    NSLog(@"web log:%@",log);
}

@end

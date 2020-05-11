//
//  CommLog.h
//  WXCommonUtils
//
//  Created by wangxu on 15/12/25.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WXCommSettings;

#ifdef DEBUG
#    define WXLog(...) NSLog(__VA_ARGS__)
#else
#    define WXLog(...)
#endif

@interface WXCommLog : NSObject

+ (void)init;
+ (void)initLog;

+ (void)LogI:(NSString *)format ,...;     //info
+ (void)LogW:(NSString *)format ,...;     //warning
+ (void)LogE:(NSString *)error;            //error
+ (void)LogEx:(NSException *)exception;    //exception
+ (void)LogC:(NSString *)format ,...;

//support swift
+ (void)logI:(NSString *)infoLog;
+ (void)logW:(NSString *)warnLog;

+ (NSString *)logFolderPath;
+ (NSString *)logFilePath;

@end

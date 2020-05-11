//
//  CommLog.m
//  WXCommonUtils
//
//  Created by wangxu on 15/12/25.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import "WXCommLog.h"
#import "WXCommTools.h"
#import "WXCommSettings.h"
#import "WXCommDevice.h"
static NSString *_logFilePath = nil;

@implementation WXCommLog

+ (void)init
{
    [self initLog];
    //写入基本信息
}

+ (void)initLog
{
    NSString *logFolderPath = [self logFolderPath];
    if (logFolderPath != nil)
    {
        NSString *strNow = [WXCommTools stringFromDate:[NSDate date] dateFormatter:@"yyyy-MM-dd hh-mm-ss"];
        NSString *newLogFilePath = [logFolderPath stringByAppendingPathComponent:strNow];
        newLogFilePath = [newLogFilePath stringByAppendingPathExtension:@"txt"];
        
        if (![WXCommTools FileExist:newLogFilePath])
        {
            if([WXCommTools FileCreate:newLogFilePath])
            {
                _logFilePath = [newLogFilePath copy];
            }
        }
        else
        {
            _logFilePath = [newLogFilePath copy];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self checkLogFiles];
        
        [self logDevic];
        
    });
}

+ (void)logDevic
{
    [WXCommLog LogI:[NSString stringWithFormat:@"deviceName %@,deviceUUID %@, deviceModel %@,deviceSystemName %@, deviceSystemVersion %@, deviceCurrentLanguage %@, getIphoneType %@, deviceBatteryValue %d", [WXCommDevice deviceName],[WXCommDevice deviceUUID], [WXCommDevice deviceModel], [WXCommDevice deviceSystemName], [WXCommDevice deviceSystemVersion], [WXCommDevice deviceCurrentLanguage],[WXCommDevice getIphoneType], [WXCommDevice deviceBatteryValue]]];
}


+ (void)checkLogFiles
{
    NSString *folderPath = [self logFolderPath];
    if (folderPath == nil)
    {
        return;
    }
    
    @try {
        NSArray *subFiles = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
        for (NSString *subFileName in subFiles)
        {
            NSString *name = [subFileName stringByDeletingPathExtension];
            name = [[name componentsSeparatedByString:@" "] firstObject];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSArray *lastClearDateCompents = [name componentsSeparatedByString:@"-"];
            long long lastClearDays = ([[lastClearDateCompents objectAtIndex:0] integerValue] * 12 * 30 + [[lastClearDateCompents objectAtIndex:1] integerValue] * 30 + [[lastClearDateCompents objectAtIndex:2] integerValue]);
            
            NSArray *nowDatecomponents = [[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
            long long nowDays = ([[nowDatecomponents objectAtIndex:0] integerValue] * 12 * 30 + [[nowDatecomponents objectAtIndex:1] integerValue] * 30 + [[nowDatecomponents objectAtIndex:2] integerValue]);
            
            NSInteger days = (NSInteger)(nowDays - lastClearDays);
            if (days >= 7)
            {
                //clear log file
                NSString *logFilePath = [folderPath stringByAppendingPathComponent:subFileName];
                [WXCommTools FileDelete:logFilePath];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

+ (void)writeLog:(NSString *)logContents threadStackName:(NSString *)statckName logType:(WXLogType)logType
{
    if (![self logFilePath])
    {
        return;
    }
    
    NSString *dateString = [WXCommTools stringFromDate:[NSDate date] dateFormatter:@"yyyy-MM-dd hh:mm:ss:sss"];
    NSString *logTypeString = @"INFO:";
    switch (logType)
    {
        case WXLogTypeInfo:
        {
            logTypeString = @"INFO:";
            break;
        }
        case WXLogTypeWarn:
        {
            logTypeString = @"WARNING:";
            break;
        }
        case WXLogTypeError:
        {
            logTypeString = @"ERROR:";
            break;
        }
        case WXLogTypeException:
        {
            logTypeString = @"EXCEPTION:";
            break;
        }
        case WXLogTypeCrash:
        {
            logTypeString = @"CRASH:";
            break;
        }
        default:
        {
            logTypeString = @"INFO:";
            break;
        }
    }
    
    NSString *_statckName = statckName;
    if (_statckName == nil || _statckName.length == 0)
    {
        _statckName = @"statck unknow";
    }
    
    NSString *appendString = [NSString stringWithFormat:@"\n[%@] (%@) %@ %@\n",dateString,_statckName,logTypeString,logContents];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self logFilePath]];
    [fileHandle seekToEndOfFile];
    
    WXLog(@"%@", appendString);
    
    [fileHandle writeData:[appendString dataUsingEncoding:NSUTF8StringEncoding]];

}

+ (NSString *)getStatckSymbolFromThreadCallStatckSymbols:(NSArray *)statckSymbols
{
    NSString *stackSymbol = nil;
    stackSymbol = [statckSymbols objectAtIndex:1];
    if (stackSymbol != nil)
    {
        if ([stackSymbol rangeOfString:@"-"].location != NSNotFound)
        {
            stackSymbol = [[stackSymbol componentsSeparatedByString:@"-"] lastObject];
        }
        else if ([stackSymbol rangeOfString:@"+"].location != NSNotFound)
        {
            stackSymbol = [[stackSymbol componentsSeparatedByString:@"+"] objectAtIndex:1];
        }
        
        if ([stackSymbol rangeOfString:@" + "].location != NSNotFound)
        {
            stackSymbol = [[stackSymbol componentsSeparatedByString:@" + "] firstObject];
        }
    }
    return stackSymbol;
}

//support swift
+ (void)logI:(NSString *)infoLog
{
    [self writeLog:infoLog threadStackName:[self getStatckSymbolFromThreadCallStatckSymbols:[NSThread callStackSymbols]] logType:WXLogTypeInfo];
}

+ (void)logW:(NSString *)warnLog
{
    [self writeLog:warnLog threadStackName:[self getStatckSymbolFromThreadCallStatckSymbols:[NSThread callStackSymbols]] logType:WXLogTypeWarn];
}

//info
+ (void)LogI:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    
    NSString *outputString = [[NSString alloc] initWithFormat:format arguments:argList];
    
    va_end(argList);
    
    [self logI:outputString];
    
}

//warning
+ (void)LogW:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    
    NSString *outputString = [[NSString alloc] initWithFormat:format arguments:argList];
    
    va_end(argList);
    
    [self logW:outputString];
}

//error
+ (void)LogE:(NSString *)error
{
    [self writeLog:error threadStackName:[self getStatckSymbolFromThreadCallStatckSymbols:[NSThread callStackSymbols]] logType:WXLogTypeError];
    
//    NSLog(@"ERROR:%@",error);
}

//exception
+ (void)LogEx:(NSException *)exception
{
    NSString *_exception = [NSString stringWithFormat:@"%@",exception];
    
    [self writeLog:_exception threadStackName:[self getStatckSymbolFromThreadCallStatckSymbols:[NSThread callStackSymbols]] logType:WXLogTypeException];
    
    NSLog(@"EXCEPTION:%@",_exception);
}

//Crash
+ (void)LogC:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    
    NSString *outputString = [[NSString alloc] initWithFormat:format arguments:argList];
    
    va_end(argList);
    
    [self writeLog:outputString threadStackName:[self getStatckSymbolFromThreadCallStatckSymbols:[NSThread callStackSymbols]] logType:WXLogTypeCrash];
    
//    NSLog(@"INFO:%@",outputString);
}


+ (NSString *)logFilePath
{
    if (_logFilePath == nil)
    {
        [self initLog];
    }
    return _logFilePath;
}

+ (NSString *)logFolderPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *logFolderPath = [documentPath stringByAppendingPathComponent:@"Log"];
    
    BOOL isDirectory = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:logFolderPath isDirectory:&isDirectory] && isDirectory)
    {
        return logFolderPath;
    }
    
    if ([[NSFileManager defaultManager] createDirectoryAtPath:logFolderPath withIntermediateDirectories:YES attributes:nil error:NULL])
    {
        return logFolderPath;
    }
    
    return nil;
}

@end

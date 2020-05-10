//
//  WXAppTools.m
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXAppTools.h"
#import "WXUserDefaultKit.h"
#import "WXParserManager.h"

#define kDefalutLangName  @"English"

// ip
static NSString *_localhostIP = nil;

@implementation WXAppTools


+ (NSString *)getValueForKeywords:(NSString *)keywords
{
    return [WXParserManager getValueForKeywords:keywords parserIdentifier:[self ClientLanguage]];
}

+ (NSString *)getValueForKeywords:(NSString *)keywords langName:(NSString *)langName
{
    return [WXParserManager getValueForKey:keywords parserIdentifier:langName];
}

+ (void)setCurrentLangName:(NSString *)currentLangName
{
    [WXUserDefaultKit saveToUserDefaultsForKey:@"clientLang" ObjectValue:currentLangName];
    
    [self parserLang];
}

+ (void)parserLang
{
    NSString *curLangName = [self ClientLanguage];
    
    NSString *langFilePath = [[NSBundle mainBundle] pathForResource:curLangName ofType:@"xml"];
    
    if (langFilePath != nil){
        
        if([WXParserManager parseWithFilePath:langFilePath error:nil]){
            NSLog(@"init lang succ : %@",curLangName);
        }
        
    }
}

+ (NSString *)ClientLanguage
{
    NSObject *obj = [WXUserDefaultKit getFromUserDefaults_Object:@"clientLang"];
    if (obj != nil && [obj isKindOfClass:[NSString class]])
    {
        NSString *lang = (NSString *)obj;
        return lang;
    }
    return kDefalutLangName;
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//临时视频、照片照片文件存放路径
+ (NSString *)tmpDownloadFilePathForFileName:(NSString *)fileName
{
    NSString *documentPath = [self documentPath];
    
    NSString *tmpFolderPath = [documentPath stringByAppendingPathComponent:@"tmp"];
    
    BOOL isDirectory = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:tmpFolderPath isDirectory:&isDirectory]){
        //创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [tmpFolderPath stringByAppendingPathComponent:fileName];
}

#pragma mark - Date to String
+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSData *)dataFromDictionary:(NSDictionary *)dic
{
    if([NSJSONSerialization isValidJSONObject:dic])
    {
        return [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    return nil;
}

+ (NSDictionary *)dictionatyFromData:(NSData *)jsonData
{
    if (jsonData)
    {
        return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return nil;
}

@end

//
//  WXCommTools.m
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommTools.h"
#import "ZipArchive.h"
//#import "JSONKit.h"
#import "DES.h"
#import "WXCommSettings.h"
#import "WXcommLog.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+WXExtension.h"

static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };


@implementation WXCommTools


#pragma mark -- NSDictionary转NSData

+ (NSData *)convertDictionaryToData:(NSDictionary *)fromDic
{
    if([NSJSONSerialization isValidJSONObject:fromDic]){
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fromDic options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData){
            return jsonData;
        }
    }else{
//        [CommLog LogE:@"can not json "];
    }
    
    return nil;
}

#pragma mark -- NSData转NSDictionary

//+ (NSDictionary *)convertDataToDictionary:(NSData *)jsonData
//{
//    if (jsonData == nil || jsonData.length == 0){
//        return nil;
//    }
//
//    JSONDecoder *jsonDecoder = [JSONDecoder decoder];
//
//    id result = [jsonDecoder mutableObjectWithData:jsonData];
//    if (result != nil){
//        NSDictionary *dic = [(NSDictionary *)result copy];
//        return dic;
//    }
//
//    return nil;
//}

#pragma mark -- NSArray转为NSData

+ (NSData *)convertArrayToData:(NSArray *)fromArray
{
    if ([NSJSONSerialization isValidJSONObject:fromArray]){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fromArray options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData){
            return jsonData;
        }
    }
    
    return nil;
}

#pragma mark -- NSData转为NSArray

//+ (NSArray *)convertDataToArray:(NSData *)jsonData
//{
//    if (jsonData == nil || jsonData.length == 0){
//        return nil;
//    }
//
//    JSONDecoder *jsonDecoder = [JSONDecoder decoder];
//    id result = [jsonDecoder mutableObjectWithData:jsonData];
//    if (result != nil){
//        return [(NSArray *)result copy];
//    }
//
//    return nil;
//}

#pragma mark -- NSString转NSData

+ (NSData *)convertStringToData:(NSString *)fromString
{
    if ([NSJSONSerialization isValidJSONObject:fromString])
    {
        NSError *error;
        NSData *jsondData = [NSJSONSerialization dataWithJSONObject:fromString options:NSJSONWritingPrettyPrinted error:&error];
        return jsondData;
    }
    return nil;
}

#pragma mark -- NSDictionary归档

+ (NSData *)archiverDictionaryToData:(NSDictionary *)dic
{
    NSMutableData *mutData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutData];
    [archiver encodeObject:dic forKey:@"dictionaryValue"];
    [archiver finishEncoding];
    
    return mutData;
}

#pragma mark -- NSDictionary解档

+ (NSDictionary *)unarchiverDataToDictionary:(NSData *)data
{
    if (data == nil)
    {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dic = [unarchiver decodeObjectForKey:@"dictionaryValue"];
    [unarchiver finishDecoding];
    
    return dic;
}

#pragma mark -- Json To Dictionary
+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    @try {
        if (!jsonString)
        {
            return nil;
        }
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error)
        {
            NSString *err = [NSString stringWithFormat:@"NSJSONSerialization Error: %@",error];
            [WXCommLog LogE:err];
        }
        return parsedData;
        
    }@catch (NSException *exception)
    {
        [WXCommLog LogEx:exception];
    }
}


#pragma mark -- 文件操作

+ (BOOL)FileCreate:(NSString *)filePath
{
    if (filePath){
        return [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return NO;
}

+ (BOOL)FileExist:(NSString*)filePath
{
    BOOL isDir=NO;
    if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        return !isDir;
    }
    return NO;
}

+ (void)FileDelete:(NSString *)filePath
{
    if(filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (void)removeFileAtFolderPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]){
        return ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName = nil ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        BOOL isDir = false ;
        if([manager fileExistsAtPath:fileAbsolutePath isDirectory:&isDir]){
            if(isDir){
                [self removeFileAtFolderPath:fileAbsolutePath];
            }else{
                [manager removeItemAtPath:fileAbsolutePath error:nil];
            }
        }
    }
    
}

+ (BOOL)ZipFiles:(NSArray*)files outFile:(NSString*)outfile
{
//    ZipArchive  *zip=[[ZipArchive alloc] init];
//    BOOL ret = [zip CreateZipFile2:outfile];
//    BOOL all_files_not_exist=YES;
//    if (ret)
//    {
//        for (NSString *file in files)
//        {
//            if ([self FileExist:file])
//            {
//                all_files_not_exist=NO;
//                NSString *filename=[file lastPathComponent];
//                [zip addFileToZip:file  newname:filename];
//            }
//        }
//    }
//    BOOL result = [zip CloseZipFile2];
//
//    if (all_files_not_exist)
//    {
        return NO;
//    }
//    return result;
}


/// 重命名操作
/// @param fromFilePath 检测的路径
/// @param count 一般填 1
+ (NSString *)renameFromFilePath:(NSString *)fromFilePath renameCount:(NSInteger)count
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:fromFilePath]){
        return fromFilePath;
    }
    
    NSString *fileExtension = [[[fromFilePath lastPathComponent] componentsSeparatedByString:@"."] lastObject];
//    if (fileExtension == nil){
//        //folder
//        fileExtension = @"";
//    }
    
    NSString *fileName = [[fromFilePath lastPathComponent] stringByDeletingPathExtension];
    if (count == 0){
        fileName = [fileName stringByAppendingFormat:@"(1)"];
    }else{
        if (count == 1) {
            fileName = [fileName stringByAppendingFormat:[NSString stringWithFormat:@"(%d)",count]];
        }
        else{
        fileName = [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%d)",count - 1] withString:[NSString stringWithFormat:@"(%d)",count]];
        }
        
    }
    count ++;
    NSString *_fromFilePath = [[fromFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:fileExtension]];
    
    return [self renameFromFilePath:_fromFilePath renameCount:count];
}

#pragma mark - Alert 窗口

+ (void)showAlertWithOtherButtonTitle:(NSString *)otherButtonTitle Message:(NSString *)message, ...
{
    if (message == nil)
    {
        return;
    }
    
    va_list arglist;
    va_start(arglist, message);
    
    NSString *alertMessage = [[NSString alloc] initWithFormat:message arguments:arglist];
    
    va_end(arglist);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:otherButtonTitle, nil] ;
    
    [alert show];
}

+ (void)showAlertWithnTitle:(NSString *)title
          cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitle:(NSString *)otherButtonTitle
                   delegete:(id)delegate
                    message:(NSString *)message, ...
{
    if (message == nil){
        return;
    }
    
    va_list arglist;
    va_start(arglist, message);
    
    NSString *alertMessage = [[NSString alloc] initWithFormat:message arguments:arglist];
    
    va_end(arglist);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    
    alert.delegate = delegate;
    
    [alert show];
}

#pragma mark- string 编解码

+ (NSString *)EncryptString:(NSString *)string
{
    return [DES doCipher:string key:[WXCommSettings DesKey] context:kCCEncrypt];
}

+ (NSString *)DecryptString:(NSString *)string
{
    return [DES doCipher:string key:[WXCommSettings DesKey] context:kCCDecrypt];
}

+ (NSString *)MD5:(NSString *)content
{
    const char *concat_str = [content UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)MD5FromFile:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        
        CC_MD5([fileData bytes], fileData.length, result);
        NSMutableString *hash = [NSMutableString string];
        for (int i = 0; i < 16; i++)
            [hash appendFormat:@"%02X", result[i]];
        return [hash lowercaseString];
    }
    
    return @"";
}

+ (NSString *)MD5FromData:(NSData *)fileData
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([fileData bytes], fileData.length, result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)base64Encoded:(NSData *)data
{
    const unsigned char    *bytes = [data bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[data length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [data length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    unsigned short i = 0;
    unsigned short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while( YES )
    {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining )
        {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        
        for( i = ctcopy; i < 4; i++ )
            [result appendString:@"="];
        
        ixtext += 3;
        charsonline += 4;
    }
    
    return [NSString stringWithString:result];
}

+ (NSData *)base64Decoded:(NSData *)fromData
{
    const unsigned char    *bytes = [fromData bytes];
    NSMutableData *result = [NSMutableData dataWithCapacity:[fromData length]];
    
    unsigned long ixtext = 0;
    unsigned long lentext = [fromData length];
    unsigned char ch = 0;
    unsigned char inbuf[4], outbuf[3];
    short i = 0, ixinbuf = 0;
    BOOL flignore = NO;
    BOOL flendtext = NO;
    
    while( YES )
    {
        if( ixtext >= lentext ) break;
        ch = bytes[ixtext++];
        flignore = NO;
        
        if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
        else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
        else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
        else if( ch == '+' ) ch = 62;
        else if( ch == '=' ) flendtext = YES;
        else if( ch == '/' ) ch = 63;
        else flignore = YES;
        
        if( ! flignore )
        {
            short ctcharsinbuf = 3;
            BOOL flbreak = NO;
            
            if( flendtext )
            {
                if( ! ixinbuf ) break;
                if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
                else ctcharsinbuf = 2;
                ixinbuf = 3;
                flbreak = YES;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if( ixinbuf == 4 )
            {
                ixinbuf = 0;
                outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
                outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
                outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
                
                for( i = 0; i < ctcharsinbuf; i++ )
                [result appendBytes:&outbuf[i] length:1];
            }
            
            if( flbreak )  break;
        }
    }
    
    return [NSData dataWithData:result];
}


#pragma mark- 当前时间
+ (NSString *)Timestamp
{
    NSDate *date = [[NSDate alloc] init];
    return [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]];
}


#pragma mark - 时间<->字符串

+ (NSString *)convertDoubleDurationToString:(NSTimeInterval)duration
{
    int hour = duration / 3600;
    int minute = (duration - hour*3600) / 60;
    int seconds = (duration - hour *3600 - minute*60);
    NSString *strDuration  = @"";
    
    strDuration = [NSString stringWithFormat:@"%02d:",hour];
    strDuration = [strDuration stringByAppendingFormat:@"%02d:",minute];
    strDuration = [strDuration stringByAppendingFormat:@"%02d",seconds];
    
    return strDuration;
}

+ (NSString *)stringFromDate:(NSDate *)date dateFormatter:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}


+ (NSDate *)dateFromString:(NSString *)dateString dateForMatter:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
    
}
+ (NSString *)timeToString:(long long)time
{
    if (time>0)
    {
        int hour = (int)(time / 3600);
        int minute = (int)((time % 3600) / 60);
        int second = (int)((time) % 60);
        if (hour>0)
        {
            return [NSString stringWithFormat:@"%02d:%02d:%02d",hour, minute, second];
        }
        else
        {
            return [NSString stringWithFormat:@"%02d:%02d", minute, second];
        }
    }
    else
    {
        return @"00:00";
    }
    
}

#pragma mark - 字节数转字符串

+ (NSString*)formatSizeFromByte:(long long)bytes
{
    int multiplyFactor = 0;
    double convertedValue = bytes;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    while (convertedValue >= 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.0f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}


#pragma mark -- 图片

+ (int)convertImageOrientationToInt:(UIImageOrientation)orientation
{
    switch (orientation)
    {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            return 0;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            return 90;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            return 180;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            return 270;
            
        default:
            return 0;
    }
}

#pragma mark -- 检测邮件格式

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isUrlString:(NSString *)urlString;
{
    
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:urlString];
    
    
};




#pragma mark -- 字符处理

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (BOOL)isString:(NSString *)string containsSubString:(NSString *)subString
{
    if (string != nil && subString != nil){
        return ([string rangeOfString:subString].location != NSNotFound);
    }
    
    return NO;
}

+ (CGSize)sizeForString:(NSString*)text font:(UIFont*)font
{
    //    CGRect screen = [UIScreen mainScreen].bounds;
    //    CGFloat maxWidth = screen.size.width;
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    CGSize textSize = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    
    return textSize;
}

+ (CGSize)sizeForString:(NSString*)text font:(UIFont*)font width:(CGFloat)width
{
    //    CGRect screen = [UIScreen mainScreen].bounds;
    //    CGFloat maxWidth = screen.size.width;
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    CGSize textSize = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    
    return textSize;
}


/**
 
 @return NSComparisonResult
 
 NSOrderedAscending 第二个大,
 NSOrderedSame 相等
 NSOrderedDescending 第一个大
 
 */
+ (NSComparisonResult)compareString:(NSString *)str1 andString:(NSString *)str2
{
    return [str1 compare:str2];
}


#pragma mark - 字符检查

+ (BOOL)isNullOrEmptyString:(NSString *)theString
{
    if (theString == nil)
    {
        return YES;
    }
    else
    {
        if ([theString isEmpty])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect =CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}
#pragma mark -- 计算文件大小

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (long long)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]){
        return 0;
    }
    
    NSError *error = nil ;
    NSArray *fileList = [manager contentsOfDirectoryAtPath:folderPath error:&error];
    
    long long folderSize = 0;
    for(NSString *fileName in fileList){
        NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
        bool isDir = false ;
        if([manager fileExistsAtPath:fullPath isDirectory:&isDir]){
            if(isDir){
                folderSize += [self folderSizeAtPath:fullPath];
            }else{
                folderSize += [self fileSizeAtPath:fullPath];
            }
        }
    }
    
    return folderSize ;
}

@end


//
//  DES.m
//  Apowersoft.CommonUtils
//
//  Created by coffeliu on 8/6/15.
//  Copyright (c) 2015 Apowersoft. All rights reserved.
//

#import "DES.h"

@implementation DES
+ (NSString *) encode:(NSString *)str key:(NSString *)key
{
    // doCipher 不能编汉字，所以要进行 url encode
    NSMutableString* str1 = [self urlEncode:str];
    NSMutableString* encode = [NSMutableString stringWithString:[self doCipher:str1 key:key context:kCCEncrypt]];
    [self formatSpecialCharacters:encode];
    return encode;
}

+ (NSString *) decode:(NSString *)str key:(NSString *)key
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    [self reformatSpecialCharacters:str1];
    NSString *rt = [self doCipher:str1 key:key context:kCCDecrypt];
    
    return rt;
}

+ (NSMutableString *)urlEncode:(NSString*)str
{
    NSMutableString* encodeStr = [NSMutableString stringWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [encodeStr replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    [encodeStr replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    return encodeStr;
}

+ (void)formatSpecialCharacters:(NSMutableString *)str
{
    [str replaceOccurrencesOfString:@"+" withString:@"$$" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"/" withString:@"@@" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
}


+ (void)reformatSpecialCharacters:(NSMutableString *)str
{
    [str replaceOccurrencesOfString:@"$$" withString:@"+" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"@@" withString:@"/" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return [self encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}


+ (NSString *)encodeBase64WithData:(NSData *)objData {
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        static char encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        static NSUInteger paddingTable[] = {0,2,1};
        
        NSUInteger dataLength = [objData length];
        NSUInteger encodedBlocks = (dataLength * 8) / 24;
        NSUInteger padding = paddingTable[dataLength % 3];
        if( padding > 0 ) encodedBlocks++;
        NSUInteger encodedLength = encodedBlocks * 4;
        
        encodingBytes = malloc(encodedLength);
        if( encodingBytes != NULL ) {
            NSUInteger rawBytesToProcess = dataLength;
            NSUInteger rawBaseIndex = 0;
            NSUInteger encodingBaseIndex = 0;
            unsigned char *rawBytes = (unsigned char *)[objData bytes];
            unsigned char rawByte1, rawByte2, rawByte3;
            while( rawBytesToProcess >= 3 ) {
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];
                
                rawBaseIndex += 3;
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
            }
            rawByte2 = 0;
            switch (dataLength-rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex+1];
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                    encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) ];
                    // we can skip rawByte3 since we have a partial block it would always be 0
                    break;
            }
            // compute location from where to begin inserting padding, it may overwrite some bytes from the partial block encoding
            // if their value was 0 (cases 1-2).
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
        NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
    }
    @finally {
        if( encodingBytes != NULL ) {
            free( encodingBytes );
        }
    }
    return encoding;
    
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    NSData *data = nil;
    unsigned char *decodedBytes = NULL;
    @try {
#define __ 255
        static char decodingTable[256] = {
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x00 - 0x0F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x10 - 0x1F
            __,__,__,__, __,__,__,__, __,__,__,62, __,__,__,63,  // 0x20 - 0x2F
            52,53,54,55, 56,57,58,59, 60,61,__,__, __, 0,__,__,  // 0x30 - 0x3F
            __, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x40 - 0x4F
            15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x50 - 0x5F
            __,26,27,28, 29,30,31,32, 33,34,35,36, 37,38,39,40,  // 0x60 - 0x6F
            41,42,43,44, 45,46,47,48, 49,50,51,__, __,__,__,__,  // 0x70 - 0x7F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x80 - 0x8F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x90 - 0x9F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xA0 - 0xAF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xB0 - 0xBF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xC0 - 0xCF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xD0 - 0xDF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xE0 - 0xEF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xF0 - 0xFF
        };
        strBase64 = [strBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSData *encodedData = [strBase64 dataUsingEncoding:NSASCIIStringEncoding];
        unsigned char *encodedBytes = (unsigned char *)[encodedData bytes];
        
        NSUInteger encodedLength = [encodedData length];
        NSUInteger encodedBlocks = (encodedLength+3) >> 2;
        NSUInteger expectedDataLength = encodedBlocks * 3;
        
        unsigned char decodingBlock[4];
        
        decodedBytes = malloc(expectedDataLength);
        if( decodedBytes != NULL ) {
            
            NSUInteger i = 0;
            NSUInteger j = 0;
            NSUInteger k = 0;
            unsigned char c;
            while( i < encodedLength ) {
                c = decodingTable[encodedBytes[i]];
                i++;
                if( c != __ ) {
                    decodingBlock[j] = c;
                    j++;
                    if( j == 4 ) {
                        decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                        decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                        decodedBytes[k+2] = (decodingBlock[2] << 6) | (decodingBlock[3]);
                        j = 0;
                        k += 3;
                    }
                }
            }
            
            // Process left over bytes, if any
            if( j == 3 ) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                k += 2;
            } else if( j == 2 ) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                k += 1;
            }
            data = [[NSData alloc] initWithBytes:decodedBytes length:k];
        }
    }
    @catch (NSException *exception) {
        data = nil;
        NSLog(@"WARNING: error occured while decoding base 32 string: %@", exception);
    }
    @finally {
        if( decodedBytes != NULL ) {
            free( decodedBytes );
        }
    }
    return data;
    
}

+(NSString*) StringWithHexBytesFromNSData:(NSData*)data {
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
    const unsigned char *dataBuffer = [data bytes];
    int i;
    for (i = 0; i < [data length]; ++i) {
        [stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
    }
    return [stringBuffer copy];
}

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt {
    
    const void *dataIn;
    size_t dataInLength;
    
    NSMutableData *dTextIn;
    if (encryptOrDecrypt == kCCDecrypt)
    {
        dTextIn=[[self dataFromHexString:sTextIn] mutableCopy];
        dataInLength = [dTextIn length];
        dataIn = [dTextIn bytes];
        if(!dTextIn)
        {
            return sTextIn;
        }
    }
    else  //encrypt
    {
        NSData* encryptData = [sTextIn dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",encryptData);
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    NSStringEncoding EnC = NSUTF8StringEncoding;
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOrDecrypt,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,
                       [dKey bytes], // const void *key
                       [dKey length], // size_t keyLength //
                       [dKey bytes], // const void *iv
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {

        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
         if (!result || result.length==0) {
         return sTextIn;
         }
         return result;
    }
    else
    {
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [self StringWithHexBytesFromNSData:data];
    }
    
    return result;
    
}


+ (NSData *)dataFromHexString:(NSString *)originalHexString
{
    @try {
        NSString *hexString = [originalHexString stringByReplacingOccurrencesOfString:@"[ <>]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [originalHexString length])]; // strip out spaces (between every four bytes), "<" (at the start) and ">" (at the end)
        NSMutableData *data = [NSMutableData dataWithCapacity:[hexString length] / 2];
        for (NSInteger i = 0; i < hexString.length; i += 2)
        {
            @try {
                
                NSInteger lenght = 2;
                
                if (i+2 > hexString.length) {
                    lenght = 1;
                }
                
                NSString *hexChar = [hexString substringWithRange: NSMakeRange(i, lenght)];
                int value;
                
//                const char  *cString = [hexChar UTF8String];
//                if (strlen(cString) < 3) {
                    sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
                    uint8_t byte = value;
                    [data appendBytes:&byte length:1];
//                }
               
            } @catch (NSException *exception) {
                
            }

        }
        return data;
    }
    @catch (NSException *exception) {
        
    }
    return nil;
}


- (NSString *)hexRepresentation:(NSData *)data;
{
    int row, addr, currentByte = 0;
    int dataLength = (int)[data length];
    int rows = (dataLength / 16) + ((dataLength % 16)? 1:0);
    char buffer[16*3], byte, hex1, hex2;
    NSMutableString *representation = [NSMutableString string];
    
    // draw bytes
    for( row = 0; row < rows; row++ )
    {
        for( addr = 0; addr < 16; addr++ )
        {
            if( currentByte < dataLength )
            {
                [data getBytes:&byte range:NSMakeRange(currentByte, 1)];
                hex1 = byte;
                hex2 = byte;
                hex1 >>= 4;
                hex1 &= 0x0F;
                hex2 &= 0x0F;
                hex1 += (hex1 < 10)? 0x30 : 0x37;
                hex2 += (hex2 < 10)? 0x30 : 0x37;
                
                buffer[addr*3]  = hex1;
                buffer[addr*3 +1] = hex2;
                buffer[addr*3 +2] = 0x20;
                
                // advance current byte
                currentByte++;
            }
            else
            {
                buffer[addr*3] = 0x00;
                break;
            }
        }
        
        // clear last byte on line
        buffer[16*3 -1] = 0x00;
        
        // append buffer to representation
        [representation appendString:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding]];
        if( currentByte != dataLength || dataLength % 16 == 0 )
            [representation appendString:@"\n"];
    }
    
    return representation;
}

@end

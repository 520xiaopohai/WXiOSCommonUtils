//
//  DES.h
//  Apowersoft.CommonUtils
//
//  Created by coffeliu on 8/6/15.
//  Copyright (c) 2015 Apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface DES : NSObject
+ (NSString *) encode:(NSString *)str key:(NSString *)key;
+ (NSString *) decode:(NSString *)str key:(NSString *)key;

+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key;
@end

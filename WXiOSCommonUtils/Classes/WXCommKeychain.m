//
//  CommKeychain.m
//  WXCommonUtils
//
//  Created by wangxu on 15/12/24.
//  Copyright © 2015年 apowersoft-. All rights reserved.
//

#import "WXCommKeychain.h"

@implementation WXCommKeychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                (NSString *)kSecClassGenericPassword,kSecClass,
                                service,kSecAttrService,
                                service,kSecAttrAccount,
                                kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible,
                                nil];
    return dic;
}

+ (BOOL)save:(NSString *)service data:(id)data
{
    //get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(NSString *)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status == noErr)
    {
        return YES;
    }
    return NO;
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(NSNumber *)kCFBooleanTrue forKey:(NSString *)kSecReturnData];
    [keychainQuery setObject:(NSString *)kSecMatchLimitOne forKey:(NSString *)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData)  == noErr)
    {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"unarchive of %@ failed :%@",service,exception);
        }
    }
    return ret;
}

+ (void)deleteService:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end

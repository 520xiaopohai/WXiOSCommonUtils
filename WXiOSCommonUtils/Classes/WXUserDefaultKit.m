//
//  UserDefaultKit.m
//  ScreenRecorderDemo
//
//  Created by wangxu on 15/6/9.
//  Copyright (c) 2015年 Joni. All rights reserved.
//

#import "WXUserDefaultKit.h"

@implementation WXUserDefaultKit

#pragma mark -- GET

+ (double)getFromUserDefaults_Double:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

+ (double)getFromUserDefaults_Double:(NSString*)key withDefaultValue:(double)defaultValue
{
    NSObject *obj=[self getFromUserDefaults_Object:key];
    if (obj) {
        NSString *content=[NSString stringWithFormat:@"%@",obj];
        if (content) {
            return [content doubleValue];
        }
    }
    
    return defaultValue;
}

+ (int)getFromUserDefaults_Integer:(NSString*)key
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (int)getFromUserDefaults_Integer:(NSString*)key withDefaultValue:(int)defaultValue
{
    NSObject *obj=[self getFromUserDefaults_Object:key];
    if (obj) {
        NSString *content=[NSString stringWithFormat:@"%@",obj];
        if (content) {
            return [content intValue];
        }
    }
    
    return defaultValue;
}

+ (BOOL)getFromUserDefaults_BOOL:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (BOOL)getFromUserDefaults_BOOL:(NSString*)key withDefaultValue:(BOOL)defaultValue
{
    NSObject *obj=[self getFromUserDefaults_Object:key];
    if (obj) {
        NSString *content=[NSString stringWithFormat:@"%@",obj];
        if (content) {
            return [content boolValue];
        }
    }
    return defaultValue;
}

+ (NSString*)getFromUserDefaults_NSString:(NSString*)key
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString*)getFromUserDefaults_NSString:(NSString*)key withDefaultValue:(NSString*)defaultValue
{
    NSObject *obj=[self getFromUserDefaults_Object:key];
    if (obj) {
        NSString *content = [NSString stringWithFormat:@"%@",obj];
        if (content) {
            return content;
        }
    }
    return defaultValue;
}

+ (NSObject*)getFromUserDefaults_Object:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSData*)getFromUserDefaults_Data:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] dataForKey:key];
}

#pragma mark -- SET

+ (void)saveToUserDefaultsForKey:(NSString*)key BOOLValue:(BOOL)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (void)saveToUserDefaultsForKey:(NSString*)key IngeterValue:(int)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (void)saveToUserDefaultsForKey:(NSString*)key ObjectValue:(NSObject*)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (void)saveToUserDefaultsForKey:(NSString*)key DoubleValue:(double)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setDouble:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (void)saveToUserDefaultsForKey:(NSString*)key NSStringValue:(NSString*)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if (key == nil) {
            return;
        }
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}
#pragma mark 删除
+ (void)removeObjectWithUserDefaultKey:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:key];
        [standardUserDefaults synchronize];
    }
}
@end


#define kStandradUserdefaults [NSUserDefaults standardUserDefaults]
#define kUserDefaultsSync     [kStandradUserdefaults synchronize]

#define NumberValueOfKey(key)    ((NSNumber *)[kStandradUserdefaults objectForKey:key])

#pragma mark - init

void UserDefaultInit()
{

}

#pragma mark ------------------------User Default Setter------------------------

BOOL WXUserDefaultSetValue_NSInteger(NSInteger value , NSString *key)
{
    if (kStandradUserdefaults){
        
        [kStandradUserdefaults setObject:[NSNumber numberWithInteger:value] forKey:key];
        
        return kUserDefaultsSync;
    }
    
    return NO;
}

BOOL WXUserDefaultSetValue_NSString(NSString *value , NSString *key)
{
    if (kStandradUserdefaults){
        
        [kStandradUserdefaults setObject:value forKey:key];
        
        return kUserDefaultsSync;
    }
    return NO;
}

//BOOL
BOOL WXUserDefaultSetValue_BOOL(BOOL value , NSString *key)
{
    if (kStandradUserdefaults){
        
        [kStandradUserdefaults setObject:[NSNumber numberWithBool:value] forKey:key];
        
        return kUserDefaultsSync;
        
    }
    
    return NO;
}

//double
BOOL WXUserDefaultSetValue_Double(double value , NSString *key)
{
    if (kStandradUserdefaults){
        
        [kStandradUserdefaults setObject:[NSNumber numberWithDouble:value] forKey:key];
        
        return kUserDefaultsSync;
        
    }
    
    return NO;
}

//NSRect
BOOL WXUserDefaultSetValue_Rect(CGRect rect , NSString *key)
{
    if (kStandradUserdefaults){
        
        NSValue *value = [NSValue valueWithCGRect:rect];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        [kStandradUserdefaults setObject:data forKey:key];
        
        return kUserDefaultsSync;
        
    }
    
    return NO;
}

//NSArry
BOOL WXUserDefaultSetValue_Array(NSArray *array , NSString *key)
{
    if (kStandradUserdefaults){
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [kStandradUserdefaults setObject:data forKey:key];
        
        return kUserDefaultsSync;
    }
    
    return NO;
}

//Dict
BOOL WXUserDefaultSetValue_Dict(NSDictionary *dict , NSString *key)
{
    if (kStandradUserdefaults){
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [kStandradUserdefaults setObject:data forKey:key];
        
        return kUserDefaultsSync;
    }
    
    return NO;
}



//NSObject  泛型
BOOL WXUserDefaultSetValue_Object(NSObject *value , NSString *key)
{
    if (kStandradUserdefaults){
        
        [kStandradUserdefaults setObject:value forKey:key];
        
        return kUserDefaultsSync;
        
    }
    
    return NO;
}


/*
 * ---------------------------------------
 *           User Default Getter
 * ---------------------------------------
 */

#pragma mark ------------------------User Default Getter------------------------

NSString *WXUserDefaultGetNSStringValue(NSString *key , NSString *defaultValue)
{
    if (kStandradUserdefaults){
        
        NSString *getValue = (NSString *)[kStandradUserdefaults objectForKey:key];
        if (getValue == nil){
            return defaultValue;
        }
        return getValue;
    }
    return defaultValue;
}

//NSInteger
NSInteger WXUserDefaultGetNSIntegerValue(NSString *key , NSInteger defaultValue)
{
    if (kStandradUserdefaults){
        NSNumber *number = NumberValueOfKey(key);
        
        if (number == nil){
            return defaultValue;
        }
        return [number integerValue];
    }
    return defaultValue;
}

//BOOL
BOOL WXUserDefaultGetBoolValue(NSString *key , BOOL defaultValue)
{
    if (kStandradUserdefaults){
        
        NSNumber *number = NumberValueOfKey(key);
        
        if (number == nil){
            return defaultValue;
        }
        return [number boolValue];
    }
    return defaultValue;
}

//double
double WXUserDefaultGetDoubleValue(NSString *key , double defaultValue)
{
    if (kStandradUserdefaults){
        
        NSNumber *number = NumberValueOfKey(key);
        if (number == nil){
            return defaultValue;
        }
        return [number doubleValue];
    }
    return defaultValue;
}


//NSArray
NSArray* WXUserDefaultGetArray(NSString *key , NSArray *defaultValue)
{
    if (kStandradUserdefaults){
        
        NSData *data = [kStandradUserdefaults dataForKey:key];
        if (data != nil && data.length >0){
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return arr;
        }
        return defaultValue;
    }
    return defaultValue;
}

NSDictionary *WXUserDefaultGetDict(NSString *key , NSDictionary *dict)
{
    if (kStandradUserdefaults){
        
        NSData *data = [kStandradUserdefaults dataForKey:key];
        if (data != nil && data.length >0){
            NSDictionary *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            if (arr.allKeys.count) {
                return arr;

            }else
            {
                return dict;

            }
        }
        return dict;
    }
    return dict;
}


//NSRect
CGRect WXUserDefaultGetRect(NSString *key , CGRect defaultValue)
{
    if (kStandradUserdefaults){
        
        NSData *data = [kStandradUserdefaults objectForKey:key];
        if (data != nil && data.length > 0){
            
            NSValue *value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (value != nil){
                CGRect rect;
                [value getValue:&rect];
                return rect;
            }
        }
    }
    return defaultValue;
}

//data
NSData* WXUserDefaultGetDataValue(NSString *key , NSData *defaultValue)
{
    if (kStandradUserdefaults){
        NSData *getData = [kStandradUserdefaults dataForKey:key];
        if (getData == nil){
            return defaultValue;
        }
        return getData;
    }
    return defaultValue;
}

//NSObject
NSObject* WXUserDefaultGetObjectValue(NSString *key , NSObject *defaultValue)
{
    if (kStandradUserdefaults){
        NSObject *getObj = [kStandradUserdefaults objectForKey:key];
        if (getObj == nil){
            return defaultValue;
        }
        return getObj;
    }
    return defaultValue;
}

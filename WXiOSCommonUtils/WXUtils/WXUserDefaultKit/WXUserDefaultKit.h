//
//  UserDefaultKit.h
//  ScreenRecorderDemo
//
//  Created by wangxu on 15/6/9.
//  Copyright (c) 2015年 Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXUserDefaultKit : NSObject

#pragma mark -- GET

+ (double)getFromUserDefaults_Double:(NSString*)key;
+ (double)getFromUserDefaults_Double:(NSString*)key withDefaultValue:(double)defaultValue;

+ (int)getFromUserDefaults_Integer:(NSString*)key;
+ (int)getFromUserDefaults_Integer:(NSString*)key withDefaultValue:(int)defaultValue;

+ (BOOL)getFromUserDefaults_BOOL:(NSString*)key;
+ (BOOL)getFromUserDefaults_BOOL:(NSString*)key withDefaultValue:(BOOL)defaultValue;

+ (NSString*)getFromUserDefaults_NSString:(NSString*)key;
+ (NSString*)getFromUserDefaults_NSString:(NSString*)key withDefaultValue:(NSString*)defaultValue;

+ (NSObject*)getFromUserDefaults_Object:(NSString*)key;

+ (NSData*)getFromUserDefaults_Data:(NSString*)key;

#pragma mark -- SET

+ (void)saveToUserDefaultsForKey:(NSString*)key BOOLValue:(BOOL)value;

+ (void)saveToUserDefaultsForKey:(NSString*)key IngeterValue:(int)value;

+ (void)saveToUserDefaultsForKey:(NSString*)key ObjectValue:(NSObject*)value;

+ (void)saveToUserDefaultsForKey:(NSString*)key DoubleValue:(double)value;

+ (void)saveToUserDefaultsForKey:(NSString*)key NSStringValue:(NSString*)value;

#pragma mark 删除
+ (void)removeObjectWithUserDefaultKey:(NSString *)key;
@end


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

// init
//void UserDefaultInit();

// ------------------------User Default Setter------------------------

//NSInteger
BOOL WXUserDefaultSetValue_NSInteger(NSInteger value , NSString *key);

//BOOL
BOOL WXUserDefaultSetValue_BOOL(BOOL value , NSString *key);

//double
BOOL WXUserDefaultSetValue_Double(double value , NSString *key);

//NSRect
BOOL WXUserDefaultSetValue_Rect(CGRect rect,NSString *key);

//NSArry
BOOL WXUserDefaultSetValue_Array(NSArray *array , NSString *key);

//NSObject  泛型
BOOL WXUserDefaultSetValue_Object(NSObject *value , NSString *key);

//NSString
BOOL WXUserDefaultSetValue_NSString(NSString *value , NSString *key);

BOOL WXUserDefaultSetValue_Dict(NSDictionary *dict , NSString *key);



// ------------------------User Default Getter------------------------

//NSString
NSString* WXUserDefaultGetNSStringValue(NSString *key , NSString *defaultValue);

//NSInteger
NSInteger WXUserDefaultGetNSIntegerValue(NSString *key , NSInteger defaultValue);

//BOOL
BOOL WXUserDefaultGetBoolValue(NSString *key , BOOL defaultValue);

//Double
double WXUserDefaultGetDoubleValue(NSString *key , double defaultValue);

//NSArray
NSArray* WXUserDefaultGetArray(NSString *key , NSArray *defaultValue);

//NSRect
CGRect WXUserDefaultGetRect(NSString *key , CGRect defaultValue);

//Data
NSData* WXUserDefaultGetDataValue(NSString *key , NSData *defaultValue);

NSDictionary *WXUserDefaultGetDict(NSString *key , NSDictionary *dict);

//NSObject 泛型
NSObject* WXUserDefaultGetObjectValue(NSString *key , NSObject *defaultValue);


//
//  WXParserManager.h
//  LangDemo
//
//  Created by wangxu on 14/12/20.
//  Copyright (c) 2014年 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXParserManager : NSObject

+ (BOOL)parseWithFilePath:(NSString *)filePath error:(NSError **)error;

+ (NSString *)getValueForKey:(NSString *)key parserIdentifier:(NSString *)identifier;

+ (NSString *)getValueForkey:(NSString *)key withSuperKeys:(NSArray *)superKeys parserIdentifier:(NSString *)identifier;
// superKeys is use to exact match , the superKeys order is fixed and one of the superkeys isn't nil. eg. oneSubNode-->twoSubNode-->threeSubNode

+ (NSArray *)getValuesForKey:(NSString *)key parserIdentifier:(NSString *)identifier;

/*
 * keywords : eg rootNodeName:SubOneNodeName:SubTwoNodeName:...:the need Key name
 */
+ (NSString *)getValueForKeywords:(NSString *)keywords parserIdentifier:(NSString *)identifier;

/*
 * when app will exit, call this method
 */
+ (void)clearCache;

@end

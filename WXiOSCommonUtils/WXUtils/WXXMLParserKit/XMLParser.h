//
//  XMLParser.h
//  LangDemo
//
//  Created by wangxu on 14/12/20.
//  Copyright (c) 2014年 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject<NSXMLParserDelegate>

- (BOOL)parseWithFilePath:(NSString *)filePath error:(NSError **)error;

- (NSString *)getValueForkey:(NSString *)key;

- (NSString *)getValueForkey:(NSString *)key withSuperKeys:(NSArray *)superKeys;
// superKeys is use to exact match , the superKeys order is fixed and one of the superkeys isn't nil. eg. oneSubNode-->twoSubNode-->threeSubNode

- (NSArray *)getValuesForKey:(NSString *)key;

- (NSString *)getValueForKeywords:(NSString *)keywords;

- (NSString *)identifiter;


@end

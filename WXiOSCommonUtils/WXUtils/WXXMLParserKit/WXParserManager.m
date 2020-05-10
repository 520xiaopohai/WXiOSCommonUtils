//
//  WXParserManager.m
//  LangDemo
//
//  Created by wangxu on 14/12/20.
//  Copyright (c) 2014年 wangxu. All rights reserved.
//

#import "WXParserManager.h"
#import "XMLParser.h"

static NSMutableArray *mutlPaserCache = nil;

@implementation WXParserManager

+ (BOOL)isExistWithParserIdentifier:(NSString *)pIdentifier
{
    if (mutlPaserCache !=nil && mutlPaserCache.count >0)
    {
        for (XMLParser *parser in mutlPaserCache)
        {
            if ([parser.identifiter isEqualToString:pIdentifier])
            {
                return YES;
            }
        }
    }
    return NO;
}

+ (XMLParser *)getParserWithIdentifier:(NSString *)pIdentifier
{
    if (mutlPaserCache != nil && mutlPaserCache.count >0)
    {
        for (XMLParser *parser in mutlPaserCache)
        {
            if ([parser.identifiter isEqualToString:pIdentifier])
            {
                return parser;
            }
        }
    }
    return nil;
}

#pragma mark -  -------------------------------------------------------
+ (BOOL)parseWithFilePath:(NSString *)filePath error:(NSError **)error
{
    if (mutlPaserCache == nil)
    {
        mutlPaserCache = [[NSMutableArray alloc] initWithCapacity:0];
    }
    XMLParser *newParser = [[XMLParser alloc] init];
    if ([newParser parseWithFilePath:filePath error:error])
    {
        // parse succ
        if (![self isExistWithParserIdentifier:newParser.identifiter])
        {
            //add new parser
            [mutlPaserCache addObject:newParser];
        }
        return YES;
    }
    return NO;
}

+ (NSString *)getValueForKey:(NSString *)key parserIdentifier:(NSString *)identifier
{
    XMLParser *parser = [self getParserWithIdentifier:identifier];
    if (parser != nil)
    {
        return [parser getValueForkey:key];
    }
    return nil;
}

+ (NSString *)getValueForkey:(NSString *)key withSuperKeys:(NSArray *)superKeys parserIdentifier:(NSString *)identifier
{
    XMLParser *parser = [self getParserWithIdentifier:identifier];
    if (parser != nil)
    {
        return [parser getValueForkey:key withSuperKeys:superKeys];
    }
    return nil;
}

+ (NSArray *)getValuesForKey:(NSString *)key parserIdentifier:(NSString *)identifier
{
    XMLParser *parser = [self getParserWithIdentifier:identifier];
    if (parser != nil)
    {
        return [parser getValuesForKey:key];
    }
    return nil;
}

+ (NSString *)getValueForKeywords:(NSString *)keywords parserIdentifier:(NSString *)identifier
{
    XMLParser *parser = [self getParserWithIdentifier:identifier];
    if (parser != nil)
    {
        return [parser getValueForKeywords:keywords];
    }
    return @"";
}






+ (void)clearCache
{
    if (mutlPaserCache != nil ){
        [mutlPaserCache removeAllObjects];
        mutlPaserCache = nil;
    }
}



@end

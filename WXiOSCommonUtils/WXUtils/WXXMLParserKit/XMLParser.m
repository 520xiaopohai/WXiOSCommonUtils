//
//  XMLParser.m
//  LangDemo
//
//  Created by wangxu on 14/12/20.
//  Copyright (c) 2014年 wangxu. All rights reserved.
//

#import "XMLParser.h"
#import "XMLNode.h"

static NSString *startElementName = nil;

static NSString *elementCharacters = nil;

static NSMutableArray *mutlEditingNodes = nil;

@interface XMLParser()
{
    NSXMLParser *mParser;
    
    NSString *mIdenfiter;
    
    NSMutableDictionary *mParsedDic;
    
    BOOL isStartElement;
}
@end

@implementation XMLParser
- (void)dealloc
{
}

- (id)init
{
    self = [super init];
    if (self)
    {
        mIdenfiter = nil;
        mParser = nil;
    }
    return self;
}

- (NSString *)identifiter
{
    return mIdenfiter;
}

- (BOOL)parseWithFilePath:(NSString *)filePath error:(NSError **)error
{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if (url == nil)
    {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
        return NO;
    }
    if (![url isFileURL])
    {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"the url is not file url",@"NSErrorParseMessage", nil]];
    }
    if (mParser != nil)
    {
        mParser = nil;
    }
    mParser  = [[NSXMLParser alloc] initWithContentsOfURL:url];
    if (mParser == nil)
    {
        *error = [NSError errorWithDomain:NSXMLParserErrorDomain code:(- 1) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"init Parser failed",@"NSErrorParseMessage", nil]];
        return NO;
    }
//    *error = [mParser parserError];
//    if (*error != nil)
//    {
//        return NO;
//    }
    mParser.delegate = self;
    if ([mParser parse])
    {
        //create parser identifier
        if (mIdenfiter != nil)
        {
            mIdenfiter = nil;
        }
        mIdenfiter = [[[filePath lastPathComponent] stringByDeletingPathExtension] copy];
        return YES;
    }
    if (error != nil)
    {
        *error = [mParser parserError];
    }
    
    mParser.delegate = nil;
    return NO;
}

- (NSString *)getValueForkey:(NSString *)key
{
    if (mParsedDic !=nil && key!=nil)
    {
        id value = [mParsedDic objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            return value;
        }
        else if ([value isKindOfClass:[XMLNode class]])
        {
            return @"";
        }
    }
    return @"";
}

- (XMLNode *)getValueFormNode:(XMLNode *)node withKey:(NSString *)key
{
    if ([node.key isEqualToString:key])
    {
        return node;
    }
    else if (node.childs!= nil && node.childs.count >0)
    {
        for (XMLNode *subNode in node.childs)
        {
            XMLNode *getNode = [self getValueFormNode:subNode withKey:key];
            if (getNode != nil)
            {
                return getNode;
            }
        }
    }
    return nil;
}

- (XMLNode *)getSubNodeFormPerentChilds:(NSArray *)childs withKey:(NSString *)key
{
    for (XMLNode *subNode in childs)
    {
        if ([subNode.key isEqualToString:key])
        {
            return subNode;
        }
    }
    return nil;
}

- (NSString *)getValueForkey:(NSString *)key withSuperKeys:(NSArray *)superKeys
{
    NSArray *allRootValues = [mParsedDic allValues];
    XMLNode *rootNode = nil;
    for (id rootValue in allRootValues)
    {
        if ([rootValue isKindOfClass:[XMLNode class]])
        {
            rootNode = (XMLNode *)rootValue;
            break;
        }
    }
    if (rootNode !=nil && rootNode.childs != nil && rootNode.childs.count>0)
    {
        XMLNode *subNode = rootNode;

        if (subNode.childs !=nil && subNode.childs.count>0)
        {
            for (NSString *superKey  in superKeys)
            {
                subNode = [self getSubNodeFormPerentChilds:subNode.childs withKey:superKey];
                if ([subNode.key isEqualToString:key])
                {
                    return subNode.value;
                }
            }
            if (subNode !=nil)
            {
                if (subNode.childs != nil && subNode.childs.count>0)
                {
                    for (XMLNode *getNode in subNode.childs)
                    {
                        if ([getNode.key isEqualToString:key])
                        {
                            return getNode.value;
                        }
                    }
                }
            }
        }
    }
    return @"";
}

- (NSArray *)getValuesForKey:(NSString *)key
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *allRootValues = [mParsedDic allValues];
    XMLNode *rootNode = nil;
    for (id rootValue in allRootValues)
    {
        if ([rootValue isKindOfClass:[XMLNode class]])
        {
            rootNode = (XMLNode *)rootValue;
            break;
        }
    }
    if (rootNode !=nil && rootNode.childs != nil && rootNode.childs.count>0)
    {
        XMLNode *parentNode = rootNode;
        for (XMLNode *childNode in parentNode.childs)
        {
            XMLNode *getNode = [self getValueFormNode:childNode withKey:key];
            if (getNode != nil)
            {
                [values addObject:getNode];
            }
        }
    }
    return values;
}

- (NSString *)getValueForKeywords:(NSString *)keywords
{
    if ([keywords rangeOfString:@":"].location == NSNotFound)
    {
        return [self getValueForkey:keywords];
    }
    NSArray *keyList = [keywords componentsSeparatedByString:@":"];
    if (keyList != nil && keyList.count >0)
    {
        if (keyList.count == 1)
        {
            return [self getValueForkey:[keyList objectAtIndex:0]];
        }
        else
        {
            NSString *key = [keyList objectAtIndex:(keyList.count - 1)];
            NSMutableArray *superKeys = [[NSMutableArray alloc] initWithArray:keyList copyItems:YES];
            return [self getValueForkey:key withSuperKeys:superKeys];
        }
    }
    return @"";
}

#pragma mark - XML Parser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (startElementName !=nil)
    {
        //[startElementName release];
        startElementName = nil;
    }
    startElementName = [elementName copy];
    
    isStartElement = YES;
    
    if (elementCharacters !=nil)
    {
        //[elementCharacters release];
        elementCharacters = nil;
    }
    
    if (mParsedDic == nil)
    {
        mParsedDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    if (attributeDict != nil && attributeDict.count>0)
    {
        [mParsedDic addEntriesFromDictionary:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (elementCharacters != nil)
    {
        elementCharacters = [[elementCharacters stringByAppendingString:string] copy];
    }
    else
    {
        elementCharacters = [string copy];
    }
    if (isStartElement)
    {
        if ([string rangeOfString:@"\n"].location != NSNotFound || [string rangeOfString:@"\n\t"].location != NSNotFound)
        {
            // create new node
            if (mutlEditingNodes == nil)
            {
                mutlEditingNodes = [[NSMutableArray alloc] initWithCapacity:0];
            }
            if (mutlEditingNodes.count == 0)
            {
                XMLNode *root = [[XMLNode alloc] initWithKey:startElementName value:nil parent:nil];
                [root startEditing];
                [mParsedDic setObject:root forKey:startElementName];
                [mutlEditingNodes addObject:root];
                //[root release];
            }
            else
            {
                for (NSInteger i = (mutlEditingNodes.count - 1); i>=0; i--)
                {
                    XMLNode *node = [mutlEditingNodes objectAtIndex:i];
                    if ([node isEditing])
                    {
                        XMLNode *subNode = [[XMLNode alloc] initWithKey:startElementName value:nil parent:node];
                        [subNode startEditing];
                        [node addChild:subNode];
                        [mutlEditingNodes addObject:subNode];
                        //[subNode release];
                        break;
                    }
                }
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementCharacters rangeOfString:@"\n"].location == NSNotFound)
    {
        for (NSInteger i = (mutlEditingNodes.count - 1); i>=0; i--)
        {
            XMLNode *node = [mutlEditingNodes objectAtIndex:i];
            if ([node isEditing])
            {
                XMLNode *subNode = [[XMLNode alloc] initWithKey:startElementName value:elementCharacters parent:node];
                [subNode startEditing];
                [node addChild:subNode];
                [mutlEditingNodes addObject:subNode];
                //[subNode release];
                break;
            }
        }
    }
    isStartElement = NO;
    for (NSInteger i = (mutlEditingNodes.count - 1); i>=0; i--)
    {
        XMLNode *node = [mutlEditingNodes objectAtIndex:i];
        if ([node.key isEqualToString:elementName])
        {
            [node endEditing];
            [mutlEditingNodes removeObject:node];
            break;
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (elementCharacters != nil)
    {
        //[elementCharacters release];
        elementCharacters = nil;
    }
    if (mutlEditingNodes !=nil)
    {
        //[mutlEditingNodes release];
        mutlEditingNodes = nil;
    }
    if (startElementName != nil)
    {
        //[startElementName release];
        startElementName = nil;
    }
    isStartElement = NO;
    
    
}

@end

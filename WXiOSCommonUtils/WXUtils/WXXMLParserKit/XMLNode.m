//
//  XMLNode.m
//  LangDemo
//
//  Created by wangxu on 14/12/20.
//  Copyright (c) 2014年 wangxu. All rights reserved.
//

#import "XMLNode.h"

@implementation XMLNode

- (void)dealloc
{
}

- (id)initWithKey:(NSString *)key value:(NSString *)value parent:(XMLNode *)parent
{
    self = [super init];
    if (self)
    {
        mKey = [key copy];
        mValue = [value copy];
        mParent = parent;
        
        mChilds = nil;
    }
    return self;
}

- (void)startEditing
{
    bIsEditing = YES;
}

- (BOOL)isEditing
{
    return bIsEditing;
}

- (void)endEditing
{
    bIsEditing = NO;
}

- (void)addChild:(XMLNode *)childNode
{
    if (mChilds == nil)
    {
        mChilds = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [mChilds addObject:childNode];
}

- (NSString *)key
{
    return mKey;
}

- (NSString *)value
{
    return mValue;
}

- (XMLNode *)parent
{
    return mParent;
}

- (NSMutableArray *)childs
{
    return mChilds;
}
@end

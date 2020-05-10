//
//  XMLNode.h
//  LangDemo
//
//  Created by wangxu on 14/12/20.
//  Copyright (c) 2014年 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLNode : NSObject
{
    NSString *mKey;
    
    NSString *mValue;
    
    XMLNode *mParent;
    
    NSMutableArray *mChilds;
    
    BOOL bIsEditing;
}

- (id)initWithKey:(NSString *)key value:(NSString *)value parent:(XMLNode *)parentNode;

- (void)addChild:(XMLNode *)childNode;

- (NSString *)key;

- (NSString *)value;

- (NSMutableArray *)childs;

- (XMLNode *)parent;

- (void)startEditing;

- (void)endEditing;

- (BOOL)isEditing;



@end

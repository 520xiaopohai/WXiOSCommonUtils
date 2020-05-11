//
//  CommKeychain.h
//  WXCommonUtils
//
//  Created by wangxu on 15/12/24.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCommKeychain : NSObject

+ (BOOL)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

@end

//
//  CommInterface.h
//  WXCommonUtils
//
//  Created by wangxu on 15/12/25.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCommSettings.h"

@interface WXCommInterface : NSObject

- (NSDictionary *)GetPostData:(NSString*)data timestamp:(NSString*)timestamp actionType:(WXServerActionType)actionType;

- (NSString *)GetResponseFromServer:(NSString*)json timestamp:(NSString*)timestamp actionType:(WXServerActionType)actionType;

- (NSString *)GetResponseFromServer:(NSString*)json timestamp:(NSString*)timestamp uploadFile:(NSString *)uploadFile actionType:(WXServerActionType)actionType;

@end

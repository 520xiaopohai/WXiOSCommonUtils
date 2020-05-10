//
//  CommInterface.m
//  WXCommonUtils
//
//  Created by wangxu on 15/12/25.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import "WXCommInterface.h"
#import "WXCommSettings.h"
#import "WXEasyHttp.h"
#import "WXCommTools.h"

@implementation WXCommInterface

- (NSDictionary *)GetPostData:(NSString *)data timestamp:(NSString *)timestamp actionType:(WXServerActionType)actionType
{
    data = [WXCommTools EncryptString:data];
    NSString *hash = [WXCommTools MD5:[NSString stringWithFormat:@"%@%@%@",data,[WXCommSettings DesKey],timestamp]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:data forKey:@"data"];
    [dict setObject:hash forKey:@"hash"];
    [dict setObject:[NSNumber numberWithInt:actionType] forKey:@"type"];
    [dict setObject:timestamp forKey:@"ts"];
    
    return dict;
    
}

- (NSString *)GetResponseFromServer:(NSString *)json timestamp:(NSString *)timestamp actionType:(WXServerActionType)actionType
{
    NSDictionary *postData = [self GetPostData:json timestamp:timestamp actionType:actionType];
    WXEasyHttp *http = [[WXEasyHttp alloc] init];
    NSString *response = [http POST:[WXCommSettings SERVER_API_URL] postData:postData];
    if (response)
    {
        response = [WXCommTools DecryptString:response];
    }

    return response;
}

- (NSString *)GetResponseFromServer:(NSString *)json timestamp:(NSString *)timestamp uploadFile:(NSString *)uploadFile actionType:(WXServerActionType)actionType
{
    NSDictionary *postData = [self GetPostData:json timestamp:timestamp actionType:actionType];
    WXEasyHttp *http = [[WXEasyHttp alloc] init];
    NSString *response = [http POST:[WXCommSettings SERVER_API_URL] postData:postData uploadFile:uploadFile];
    if (response)
    {
        response = [WXCommTools DecryptString:response];
    }

    return response;
}

@end

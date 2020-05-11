//
//  WXAFNetworking.h
//  WXCommonUtils
//
//  Created by wxqiu on 2018/3/30.
//  Copyright © 2018年 Apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DataBlock)(NSError * _Nullable error,id _Nullable response);

typedef void(^DataDownloadProgressBlock)(float progress,BOOL completion, NSError * _Nullable error);


@interface WXAFNetworking : NSObject

+ (instancetype)shareInstance;

/// 将从接口获取的response转换成
+ (NSDictionary *)responseToDictionary:(id)response;

/// 从Error 和 response 中获取相应的errorMessage数据， 返回的数据格式{msg:xxx , status : -111}
+ (NSDictionary *)errorMessageFromError:(NSError *)error andResponse:(id)response;

/// 停止数据请求
+ (void)stopRequest;

/// 停止下载数据
+ (void)stopDownloadRequest;

/**
 post 请求，后台body 传参模式

 @param url url
 @param dict Jason
 @param dataBlock 数据返回
 @param headDict 请求表头的附加数据，可以为nil
 */
+ (void)POSTWithUrl:(NSString *)url withDictrionary:(NSDictionary *)dict withHeaders:(NSDictionary *)headDict  withReturn:(DataBlock)dataBlock;



/// post 请求
/// @param url url
/// @param dict  字典
/// @param dataBlock 数据返回
+ (void)POSTWithUrl:(NSString *)url withDictrionary:(NSDictionary *)dict withReturn:(DataBlock)dataBlock;
/**
 getdata

 @param url <#url description#>
 @param dictionary <#dictionary description#>
 @param dataBlock <#dataBlock description#>
 */
+ (void)GETtWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock;


+ (void)DeleteWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock;

+ (void)PutWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock;

/**
 文件下载

 @param url url
 @param toFilePath tourl
 @param progressBlock <#progressBlock description#>
 */
+ (void)downloadFile:(NSString *)url withFilePath:(NSString *)toFilePath withProgressBlcok:(DataDownloadProgressBlock)progressBlock;

/// 返回类型为html、xml数据类型的请求get请求方式
/// @param url url
/// @param dictionary 参数字典
/// @param headers 请求头
/// @param dataBlock 数据返回
+ (void)GETtXMLWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock;

/**
post 请求，后台body 传参模式

@param url url
@param dict Jason
@param dataBlock 数据返回
@param headDict 请求表头的附加数据，可以为nil
*/
+ (void)POSTTaskWithUrl:(NSString *)url withDictrionary:(NSDictionary *)dict withHeaders:(NSDictionary *)headDict withReturn:(DataBlock)dataBlock;
@end


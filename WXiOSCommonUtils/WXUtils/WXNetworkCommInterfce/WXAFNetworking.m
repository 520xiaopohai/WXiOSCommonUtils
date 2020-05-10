//
//  WXAFNetworking.m
//  WXCommonUtils
//
//  Created by wxqiu on 2018/3/30.
//  Copyright © 2018年 Apowersoft. All rights reserved.
//

#import "WXAFNetworking.h"
#import "AFNetworking.h"
#import "WXCommDevice.h"
#import "WXCommlog.h"

@interface WXAFNetworking ()

@property (nonatomic, strong) NSURLSessionDataTask *currentTask;

@property (nonatomic, strong) NSURLSessionDownloadTask *currentDownloadTask;
@end
@implementation WXAFNetworking

+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

/// 停止数据请求
+ (void)stopRequest
{
    [[WXAFNetworking shareInstance].currentTask cancel];
}

/// 停止下载数据
+ (void)stopDownloadRequest
{
    [[WXAFNetworking shareInstance].currentDownloadTask cancel];
}

+ (void)POSTWithUrl:(NSString *)url withDictrionary:(NSDictionary *)dict withReturn:(DataBlock)dataBlock {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [WXAFNetworking shareInstance].currentTask = [[AFHTTPSessionManager manager] POST:url parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            } progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     dataBlock(nil, responseObject);
                });


            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                dispatch_async(dispatch_get_main_queue(), ^{
                     dataBlock(error, nil);
                });

            }];
    });


}

+ (void)POSTWithUrl:(NSString *)url withDictrionary:(NSDictionary *)dict withHeaders:(NSDictionary *)headDict withReturn:(DataBlock)dataBlock
{


    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];

    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    if (headDict != nil)
    {
        for (NSString *key in headDict)
        {
            NSString *value = [headDict objectForKey:key];
            if (value && [value isKindOfClass:[NSString class]])
            {
                [req setValue:value forHTTPHeaderField:key];
            }
        }
    }

    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (dataBlock) {

            dataBlock(error, responseObject);

        }

    }] resume];
}



+ (void)GETtWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (headers != nil)
      {
          for (NSString *key in headers)
          {
              NSString *value = [headers objectForKey:key];
              if (value && [value isKindOfClass:[NSString class]])
              {
                  [manager.requestSerializer setValue:value forHTTPHeaderField:key];
              }
          }
      }

    [manager GET:url parameters:dictionary  progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (dataBlock) {
            dataBlock(nil, responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (dataBlock) {
            dataBlock(error, nil);
        }
    }];
}

+ (void)DeleteWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (headers != nil)
      {
          for (NSString *key in headers)
          {
              NSString *value = [headers objectForKey:key];
              if (value && [value isKindOfClass:[NSString class]])
              {
                  [manager.requestSerializer setValue:value forHTTPHeaderField:key];
              }
          }
      }
    [manager DELETE:url parameters:dictionary  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (dataBlock) {
            dataBlock(nil, responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (dataBlock) {
            dataBlock(error, nil);
        }
    }];
}

+ (void)PutWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    if (headers != nil)
    {
        for (NSString *key in headers)
        {
            NSString *value = [headers objectForKey:key];
            if (value && [value isKindOfClass:[NSString class]])
            {
                [manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }
    }
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];




    [manager PUT:url parameters:dictionary  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (dataBlock) {
            dataBlock(nil, responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (dataBlock) {
            dataBlock(error, nil);
        }
    }];
}


+ (void)downloadFile:(NSString *)url withFilePath:(NSString *)toFilePath withProgressBlcok:(DataDownloadProgressBlock)progressBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];


    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

        if (progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount, NO,nil);
            });

        }

//        NSLog(@"%@", [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount]);

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接文件的全路径
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];

        return [NSURL fileURLWithPath:fullpath];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        if (!error) {
            [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:toFilePath] error:nil];

            [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];

            if (progressBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressBlock(1.0, YES,error);
                });
            }
        }else {
            if (progressBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressBlock(0, NO,error);
                });
            }
        }




    }] resume];
}


+ (NSDictionary *)responseToDictionary:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]]) {

        NSDictionary *responseDict = (NSDictionary *)response;
        return responseDict;

    } else if ([response isKindOfClass:[NSData class]]) {

        NSData *resData = (NSData *)response;
        NSString *resString = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
        NSData *utf8Data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            return (NSDictionary *)object;
        } else {
            [WXCommLog LogE:[NSString stringWithFormat:@"解析Response失败 ：Error - %@",error]];
        }

    } else if ([response isKindOfClass:[NSString class]]) {

        NSString *resString = (NSString *)response;
        NSData *utf8Data = [resString dataUsingEncoding:NSUTF8StringEncoding];

        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            return (NSDictionary *)object;
        } else {
            [WXCommLog LogE:[NSString stringWithFormat:@"解析Response失败 ：Error - %@",error]];
        }
    }


    return nil;
}

/// 从Error 和 response 中获取相应的errorMessage数据， 返回的数据格式{msg:xxx , status : -111}
+ (NSDictionary *)errorMessageFromError:(NSError *)error andResponse:(id)response
{
    // 先解析response
    if (response != nil) {
        NSDictionary *errorDict = [self responseToDictionary:response];
        return errorDict;
    } else if (error == nil) {
        return nil;
    } else {
        // 解析 error
        NSDictionary *errorUserInfo = error.userInfo;
        if (errorUserInfo == nil) {
            return nil;
        } else {

            NSArray *allKeys = errorUserInfo.allKeys;
            // com.alamofire.serialization.response.error.data
            // 怕全部的key值可能在不同的接口场景有不同的命名方式，这里处理成选择带有“error.data”
            // 字样的key值来获取相应的data数据
            for (NSString *keyString in allKeys) {
                if ([keyString rangeOfString:@"error.data"].location != NSNotFound) {
                    NSData *data = (NSData *)[errorUserInfo objectForKey:keyString];
                    return [self responseToDictionary:data];
                }
            }
        }
    }
    return nil;
}


+ (void)GETtXMLWithUrl:(NSString *)url withDictionary:(NSDictionary *)dictionary withHeaders:(NSDictionary *)headers withRerturn:(DataBlock)dataBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects: @"text/html",nil];

    if (headers != nil)
    {
        for (NSString *key in headers)
        {
            NSString *value = [headers objectForKey:key];
            if (value && [value isKindOfClass:[NSString class]])
            {
                [manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }
    }


    [manager GET:url parameters:dictionary  progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (dataBlock) {
            dataBlock(nil, responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (dataBlock) {
            dataBlock(error, nil);
        }
    }];
}

+ (void)POSTTaskWithUrl:(NSString *)url withDictrionary:(NSDictionary *)dict withHeaders:(NSDictionary *)headers withReturn:(DataBlock)dataBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    if (headers != nil)
    {
        for (NSString *key in headers)
        {
            NSString *value = [headers objectForKey:key];
            if (value && [value isKindOfClass:[NSString class]])
            {
                [manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }
    }

    [manager POST:url parameters:dict  progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (dataBlock) {
            dataBlock(nil, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (dataBlock) {
            dataBlock(error, nil);
        }
    }];
}

@end

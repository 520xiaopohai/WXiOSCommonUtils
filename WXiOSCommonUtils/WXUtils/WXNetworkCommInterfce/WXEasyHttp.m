//
//  EasyHttp.m
//  Apowersoft.CommonUtils
//
//  Created by coffeliu on 9/9/15.
//  Copyright (c) 2015 Apowersoft. All rights reserved.
//

#import "WXEasyHttp.h"
#import <AFNetworking/AFNetworking.h>
//#import "AFNetworking.h"

#define kTimeOutInterval  20

@implementation WXEasyHttp


-(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}



//-(NSData*)  GetData:(NSString*)url{
//    
//    
//    
//    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    [request startSynchronous];
//    return [request responseData];
//}
//-(NSString*) Get:(NSString*)url{
//    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    [request startSynchronous];
//    NSString *responseString= [request responseString];
//    return responseString;
//}
-(NSString*) POST:(NSString*)url postData:(NSDictionary *)dict{
    return [self POST:url postData:dict uploadFile:nil];
}
//
-(NSString*) POST:(NSString*)url postData:(NSDictionary *)dict uploadFile:(NSString*)uploadFile{
    
    AFHTTPSessionManager *manager = [self manager];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    
    __block NSString *responseString = nil;

    [manager POST:url parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (uploadFile) {
            NSData *imageData = [NSData dataWithContentsOfFile:uploadFile];
            
            if (imageData) {
              [formData appendPartWithFileData:imageData name:@"file" fileName:uploadFile.lastPathComponent mimeType:@"application/zip"];
            }
            
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"uploadProgress  %f", 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        
        dispatch_semaphore_signal(semaphore);

        NSLog(@"responseObject %@",responseString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_semaphore_signal(semaphore);

    }];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    
    return responseString;
}
@end

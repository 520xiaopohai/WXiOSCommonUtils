//
//  EasyHttp.h
//  Apowersoft.CommonUtils
//
//  Created by fred on 9/9/15.
//  Copyright (c) 2015 Apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXEasyHttp : NSObject{
    
}
-(NSData*)  GetData:(NSString*)url;
-(NSString*) Get:(NSString*)url;

// post
-(NSString*) POST:(NSString*)url postData:(NSDictionary *)dic;
// 上传日志
-(NSString*) POST:(NSString*)url postData:(NSDictionary *)dic uploadFile:(NSString*)uploadFile;
@end

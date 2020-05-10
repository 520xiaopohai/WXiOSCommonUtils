//
//  AutoCheckUpdate.m
//  WXCommonUtils
//
//  Created by wangxutech on 16/7/4.
//  Copyright © 2016年 apowersoft. All rights reserved.
//

#import "WXAutoCheckUpdate.h"

static NSString *checkVersionUrl = @"https://itunes.apple.com/lookup?id=" ;
static NSString *appStoreVersion = @"" ;
static NSString *trackViewUrl = @"" ;
static NSString *curtentVersion = @"" ;
static NSInteger tryCount = 0 ;
static NSInteger tryToConnectCount = 0 ;

/*
 该类用于检测app的版本，一天最多检测1次，总共检测5次
 */

@implementation WXAutoCheckUpdate

#pragma mark -- 自动检测升级

+ (void)checkForUpdateWithAppId:(NSString *)appId block:(void(^)(bool shouldUpdate))handler
{
    NSString *appUrl = [checkVersionUrl stringByAppendingString:appId];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:appUrl]completionHandler:^(NSData*data,NSURLResponse *response,NSError *error){
        
        if (!error){
            
            NSDictionary *rstInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if(rstInfoDic){
                
                NSArray *array = [rstInfoDic objectForKey:@"results"];
                
                if(array && array.count){
                    
                    NSDictionary *appVerInfo = [array objectAtIndex:0];
                    
                    appStoreVersion = [appVerInfo objectForKey:@"version"];
                    trackViewUrl = [appVerInfo objectForKey:@"trackViewUrl"];
                    
                    NSDictionary *indoDic = [[NSBundle mainBundle]infoDictionary];
                    curtentVersion = [indoDic objectForKey:@"CFBundleShortVersionString"];
                    
                    
                    
                    if([self version:curtentVersion lessthan:appStoreVersion]){
                        
                        tryCount = 0 ;
                        
                        handler(YES);
                        
                    }else{
                        
                        tryCount = 0 ;
                        
                        handler(NO);
                        
                    }
                    
                }else{
                    
                    if(++tryCount <= 3){
                        
                        [self checkForUpdateWithAppId:appId block:handler];
                        
                    }else{
                        
                        tryCount = 0 ;
                        
                        handler(NO);
                    }
                    
                }
                
            }else{
                
                if(++tryCount <= 3){
                    
                    [self checkForUpdateWithAppId:appId block:handler];
                    
                }else{
                    
                    tryCount = 0 ;
                    
                    handler(NO);
                }
                
            }
            
        }else{
            
            if(++tryCount <= 3){
                
                [self checkForUpdateWithAppId:appId block:handler];
                
            }else{
                
                tryCount = 0 ;
                
                handler(NO);
            }
            
        }
    }];
    
    [dataTask resume];
}

+ (void)checkForUpdateWithAppId:(NSString *)appId
{
    if(![self canCheckUpdate]){
        return ;
    }
    
    NSString *appUrl = [checkVersionUrl stringByAppendingString:appId];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:appUrl]completionHandler:^(NSData*data,NSURLResponse *response,NSError *error){
        
        if (!error){
            
            NSDictionary *rstInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if(rstInfoDic){
                
                NSArray *array = [rstInfoDic objectForKey:@"results"];
                
                if(array && array.count){
                    
                    NSDictionary *appVerInfo = [array objectAtIndex:0];
                    appStoreVersion = [appVerInfo objectForKey:@"version"];
                    trackViewUrl = [appVerInfo objectForKey:@"trackViewUrl"];
                    
                    NSDictionary *indoDic = [[NSBundle mainBundle]infoDictionary];
                    curtentVersion = [indoDic objectForKey:@"CFBundleShortVersionString"];
                    
                    if([self version:curtentVersion lessthan:appStoreVersion]){
                        
                        tryCount = 0 ;
                        
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        NSString *remainCountKey = [NSString stringWithFormat:@"remindCount_%@",curtentVersion];
                        NSInteger remindCount = [[ud objectForKey:remainCountKey]intValue] + 1;
                        [ud setObject:[NSNumber numberWithInteger:remindCount] forKey:remainCountKey];
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                        [ud setObject:currentDateStr forKey:@"lastCheckUpdateTime"];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateAppNotify object:nil];
                    }
                    
                }else{
                    
                    if(++tryCount <= 3){
                        [self checkForUpdateWithAppId:appId];
                    }else{
                        tryCount = 0 ;
                    }
                }
                
            }else{
                
                if(++tryCount <= 3){
                    [self checkForUpdateWithAppId:appId];
                }else{
                    tryCount = 0 ;
                }
            }
            
        }else{
            
            if(++tryCount <= 3){
                [self checkForUpdateWithAppId:appId];
            }else{
                tryCount = 0 ;
            }
        }
    }];
    
    [dataTask resume];
}

+ (BOOL)version:(NSString *)oldver lessthan:(NSString *)newver
{
    if ([oldver compare:newver options:NSNumericSearch] == NSOrderedAscending){
        return YES;
    }
    return NO;
}

+ (NSURL*)appDownUrl
{
    return [NSURL URLWithString:trackViewUrl];
}

+ (NSString*)curtVersion
{
    return curtentVersion ;
}

+ (NSString*)appStoreVersion
{
    return appStoreVersion ;
}

+ (bool)canCheckUpdate
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *now = [NSDate date];
    
    NSDictionary *indoDic = [[NSBundle mainBundle]infoDictionary];
    NSString *remainCountKey = [NSString stringWithFormat:@"remindCount_%@",[indoDic objectForKey:@"CFBundleShortVersionString"]];
    NSInteger remindCount = [[ud objectForKey:remainCountKey]intValue];
    if(remindCount > 5){
        return false ;
    }
    
    long long timeInterval = 24 * 60 * 60 ;
    long long lastCheckTime = 0 ;
    long long longNow = [now timeIntervalSince1970];
    
    NSString *strDate = [ud objectForKey:@"lastCheckUpdateTime"];
    if(strDate && ![strDate isEqualToString:@""]){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:strDate];
        lastCheckTime = [date timeIntervalSince1970];
    }
    
    if((longNow - lastCheckTime) > timeInterval){
        return true ;
    }
    
    return false ;
}

#pragma mark -- 获取app的appstore连接

+ (void)getAppLinkUrlWithAppId:(NSString *)appId result:(void(^)(NSString *url))handler
{
    NSString *appUrl = [checkVersionUrl stringByAppendingString:appId];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:appUrl]completionHandler:^(NSData*data,NSURLResponse *response,NSError *error){
        
        if (!error){
            
            NSDictionary *rstInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if(rstInfoDic){
                
                NSArray *array = [rstInfoDic objectForKey:@"results"];
                
                if(array && array.count){
                    
                    NSDictionary *appVerInfo = [array objectAtIndex:0];
                    trackViewUrl = [appVerInfo objectForKey:@"trackViewUrl"];
                    tryToConnectCount = 0 ;
                    if(handler){
                        handler(trackViewUrl);
                    }
                    
                }else{
                    
                    if(++tryToConnectCount <= 3){
                        [self getAppLinkUrlWithAppId:appId result:handler];
                    }else{
                        tryToConnectCount = 0 ;
                        if(handler){
                            handler(trackViewUrl);
                        }
                    }
                    
                }
                
            }else{
                
                if(++tryToConnectCount <= 3){
                    [self getAppLinkUrlWithAppId:appId result:handler];
                }else{
                    tryToConnectCount = 0 ;
                    if(handler){
                        handler(trackViewUrl);
                    }
                }
                
            }
            
        }else{
            
            if(++tryToConnectCount <= 3){
                [self getAppLinkUrlWithAppId:appId result:handler];
            }else{
                tryToConnectCount = 0 ;
                if(handler){
                    handler(trackViewUrl);
                }
            }
            
        }
    }];
    
    [dataTask resume];
}

@end

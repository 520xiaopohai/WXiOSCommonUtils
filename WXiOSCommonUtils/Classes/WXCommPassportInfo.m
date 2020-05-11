//
//  WXCommPassportInfo.m
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/4/11.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommPassportInfo.h"
#import "WXAccountTools.h"
#import "WXAFNetworking.h"
#import "WXUserDefaultKit.h"
#import "WXCommTools.h"
#import "CommPassportHeader.h"

#import "WXCommSettings.h"
#import "WXCommDevice.h"
#import "WXCommLog.h"

//tokeninfo
static NSString *_apiToken = nil;
static NSString *_identityToken = nil;

//userInfo
static NSString *_userNickName = @"";
static NSString *_userEmail = @"";
static NSString *_userAvatarUrl = nil;

//passportInfo
static NSString *_expireDateString = nil; //过期时间
static BOOL _willExpire = YES; //是否快过期
static int _remainDays = 0; //剩余天数
//static BOOL _isActivated = NO; //是否已激活
static CommPassportType _licenseType = CommPassportType_none;


static BOOL _isInit = NO;
#define PassportAweak if(!_isInit) { [WXCommPassportInfo defaultPassport]; }


@implementation WXChangeUserInfoData
@end


@implementation WXCommPassportInfo

+ (WXCommPassportInfo *)defaultPassport
{
    static dispatch_once_t onceToken;
    static WXCommPassportInfo * passportInfo;
    dispatch_once(&onceToken, ^{
        passportInfo = [[WXCommPassportInfo alloc] init];
    });
    return passportInfo;
}



- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *cookies = [WXAccountTools getAccountCookies];
        [WXCommPassportInfo updatePassportInfoWithLoginCookies:cookies];
        _isInit = YES;
    }
    return self;
}

+ (void)clearPassportInfo
{
    _apiToken = nil;
    _identityToken = nil;
    
    _userEmail = @"";
    _userNickName = @"";
    _userAvatarUrl = nil;
    [WXAccountTools clearAccountCookies];
    WXUserDefaultSetValue_NSString(nil, @"passportInfo.user.avatarData");
    
    [WXCommLog logI:[NSString stringWithFormat:@"清除用户账户信息"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:[self PassportUserInfoUpdateNotificationName] object:nil];
    });
}

+ (BOOL)isLogined
{
    PassportAweak
    
    if (_apiToken &&_apiToken.length > 0 && _identityToken && _identityToken.length > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isExpired
{
    //如果没有登录，则一定是过期状态
    if (![self isLogined])
    {
        return YES;
    }
    
    if ([self passportType] == CommPassportType_trial)
    {
        return YES;
    }
    
    //判断过期日期
    if (_willExpire)
    {
        if (_remainDays <= 0)
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)willExpired
{
    return _willExpire;
}

+ (NSString *)UserNickName
{
    PassportAweak
    if (_userNickName != nil) {
        if ([_userNickName isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)_userNickName;
            _userNickName = [NSString stringWithFormat:@"%ld",number.longValue];
        }
        return _userNickName;
    } else {
        return @"";
    }
}

+ (NSString *)UserEmail
{
    PassportAweak
    
    return _userEmail;
}

+ (NSString *)expiredDateString
{
    NSString *dateString = [_expireDateString componentsSeparatedByString:@" "].firstObject;
    if (dateString == nil || dateString.length == 0)
    {
        return @"";
    }
    return dateString;
}

+ (CommPassportType)passportType
{
    return _licenseType;
}

+ (NSString *)UserAvatarUrlStr {
    return _userAvatarUrl;
}

+ (UIImage *)UserAvatar
{
    PassportAweak
    
    NSString *base64String = WXUserDefaultGetNSStringValue(@"passportInfo.user.avatarData", nil);
    NSData *imageData = [WXCommTools base64Decoded:[base64String dataUsingEncoding:NSUTF8StringEncoding]];
    UIImage *avatar = [UIImage imageWithData:imageData];
    return avatar;
}

#pragma mark - 内部数据
+ (NSString *)IdentityToken
{
    return _identityToken;
}

+ (NSString *)ApiToken
{
    return _apiToken;
}


+ (void)clearUserPassportInfo
{
    _expireDateString = nil;
    _willExpire = YES;
    _remainDays = 0;
}


+ (void)asynDownloadUserAvatar
{
    NSString *tmpPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    tmpPath = [tmpPath stringByAppendingPathComponent:@"/avatar.jpg"];
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    [WXAFNetworking downloadFile:_userAvatarUrl withFilePath:tmpPath withProgressBlcok:^(float progress, BOOL completion, NSError * _Nullable error) {
        
        if (completion && !error) {
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:tmpPath];
            if (imageData) {
                
                UIImage *newImage = [[UIImage alloc] initWithData:imageData];
                //本地保存图片数据
                WXUserDefaultSetValue_NSString([WXCommTools base64Encoded:imageData], @"passportInfo.user.avatarData");
                
                //发出通知,用户头像已更新,已转主线程
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:[self PassportUserAvatarUpdateNotificationName] object:newImage];
                });
            }
        }
    }];
}

+ (NSString *)PassportUserAvatarUpdateNotificationName
{
    return @"notification.passportInfo.userAvatarDidChange";
}

+ (NSString *)PassportUserInfoUpdateNotificationName
{
    return @"notification.passportInfo.userPassportInfoDidChange";
}

#pragma mark - 私有方法
//更新用户信息
+ (void)updatePassportInfoWithLoginCookies:(NSString *)cookies{
    if (cookies && cookies.length > 0)
    {
        NSData *data = [cookies dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *passportInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([WXCommPassportInfo isLogined]) {
                //TODO: 暂时未给用户的账户信息进行加密
                [WXCommLog logI:[NSString stringWithFormat:@"用户账户信息 ：%@",passportInfo]];
            } else {
                [WXCommLog logI:[NSString stringWithFormat:@"没有用户账户信息"]];
            }
        });

        //passportInfo
        _apiToken = passportInfo[@"api_token"];
        _identityToken = passportInfo[@"identity_token"];
        
        // code by joni 2019-03-10
        /* <#修改原因#>
         */
        if (_apiToken &&_apiToken.length > 0 && _identityToken && _identityToken.length > 0)
        {
            
        } else {
            [self clearPassportInfo];
            return;
        }
        
        //userInfo
        NSDictionary *userInfo = passportInfo[@"userInfo"];
        _userNickName = userInfo[@"nickname"];
        _userEmail = userInfo[@"email"];
        
        NSString *appName = @"";
        
        //针对appName的单独判断 抠图项目用到
        if ([[passportInfo allKeys] containsObject: @"appName"] && [passportInfo[@"appName"] isKindOfClass:[NSString class]]) {
            appName = passportInfo[@"appName"];
        }
        
        
        
        NSString *avatarUrl = [userInfo objectForKey:@"avatar"];
        if ([avatarUrl isKindOfClass:[NSNull class]])
        {
            _userAvatarUrl = nil;
        }
        else {
            _userAvatarUrl = avatarUrl;
        }
        
        if (_userAvatarUrl != nil && _userAvatarUrl.length > 0) {
            [self asynDownloadUserAvatar];
        }
        
        // 通知客户端用户账户已更新
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:[self PassportUserInfoUpdateNotificationName] object:nil];
        });
        
        
        // code by joni 2019-03-10
        /* 目前checkVIPInfo方法里获得的数据，只有iOS PDF 转换用得到，
         * 其他项目里均用不到。如果网络差的情况下，就会出现显示登录成功
         * 但是却因为checkVIPInfo失败用的数据被清除
         */
        
        
//        if (_identityToken != nil && _identityToken.length > 0) {
//            if ([appName isEqualToString:@"backgrounderaser"]) {
//                // 抠图暂时不需要判断vip信息的产品线逻辑
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:[self PassportUserInfoUpdateNotificationName] object:nil];
//                });
//                
//            }else{ dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [WXIAPHelper checkVIPInfoWithBlock:^(int status, NSDictionary *passportInfo, NSError *error) {
//                    NSLog(@"%@",passportInfo);
//                    if (status == 1) {
//                        [self updateUserPassportInfo:passportInfo];
//                    } else {
//                        [self clearPassportInfo];
//                    }
//                }];
//            });
//            }
//            
//        }
    }
    else
    {
        [self clearPassportInfo];
    }
}






#pragma mark - WXCommPassportInfo (WXExtension)
+ (NSString *)apiToken
{
    return _apiToken;
}

+ (NSString *)identifyToken
{
    return _identityToken;
}

+ (void)initPassport
{
    PassportAweak;
}






+ (void)updateUserPassportInfo:(NSDictionary *)dictInfo
{
    if (dictInfo == nil || dictInfo.count == 0) {
        [self clearPassportInfo];
        return;
    }
    
    NSDictionary *licenseInfo = dictInfo[@"license_info"];
    if (licenseInfo == nil || licenseInfo.count == 0) {
        [self clearPassportInfo];
        return;
    }
    
    _expireDateString = licenseInfo[@"expire_date"];
    _willExpire = [licenseInfo[@"will_expire"] boolValue];
    _remainDays = [licenseInfo[@"remain_days"] intValue];
    
    _licenseType = CommPassportType_none;
    NSString *licenseType = licenseInfo[k_passport_license_type];
    if ([licenseType isEqualToString:passport_license_type_trial]) {
        _licenseType = CommPassportType_trial;
    }
    else if ([licenseType isEqualToString:passport_license_type_yearly])
    {
        _licenseType = CommPassportType_yearly;
    }
    else if ([licenseType isEqualToString:passport_license_type_quarterly])
    {
        _licenseType = CommPassportType_quarterly;
    }
    else if ([licenseType isEqualToString:passport_license_type_lifetime])
    {
        _licenseType = CommPassportType_lifetime;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:[self PassportUserInfoUpdateNotificationName] object:nil];
    });
}

#pragma mark - 修改用户基本信息

+ (NSString *)UserCenterServerAPI
{
    return @"https://passport.aoscdn.com/api/";
}

+ (void)asyncUpdateUserInfo:(WXChangeUserInfoData *)changeData completion:(void (^)(BOOL))block
{
    [WXCommLog logI:@"开始修改用户信息"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *apiToken = [self apiToken];
        NSString *uid = changeData.userId;
        NSString *requestUrl = [[self UserCenterServerAPI] stringByAppendingFormat:@"users/%@",uid];
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [headerDict setObject:[@"Bearer " stringByAppendingString:apiToken] forKey:@"Authorization"];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        // 昵称
        if (changeData.nickName != nil && changeData.nickName.length > 0) {
            [bodyDict setObject:changeData.nickName forKey:@"nickname"];
        }
        // 头像
        if (changeData.avatarUrl != nil && changeData.avatarUrl.length > 0){
            [bodyDict setObject:changeData.avatarUrl forKey:@"avatar"];
        }
        
        [WXAFNetworking PutWithUrl:requestUrl withDictionary:bodyDict withHeaders:headerDict withRerturn:^(NSError * _Nullable error, id  _Nullable response) {
            
            if (error == nil) {
                
                NSDictionary *responseDict = [WXAFNetworking responseToDictionary:response];
                if (responseDict != nil) {
                    //解析数据
                    int status = [[responseDict objectForKey:@"status"] intValue];
                    if (status == 1) {
                        NSDictionary *userDataDict = [responseDict objectForKey:@"data"];
                        
                        // 将数据组装成cookies
                        NSMutableDictionary *cookies = [[NSMutableDictionary alloc] initWithCapacity:0];
                        [cookies setObject:[self apiToken] forKey:@"api_token"];
                        [cookies setObject:[self identifyToken] forKey:@"identity_token"];
                        [cookies setObject:userDataDict forKey:@"userInfo"];
                        
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cookies options:NSJSONWritingPrettyPrinted error:nil];
                        // 本地更新缓存
                        [WXAccountTools setAccountCookies:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                        // 如果修改了头像，则先进行本地替换，再从服务器进行下载
                        if (changeData.avatarUrl != nil && changeData.avatarUrl.length > 0) {
                            _userAvatarUrl = changeData.avatarUrl;
                            if (changeData.avatarImageBase64Data != nil) { WXUserDefaultSetValue_NSString(changeData.avatarImageBase64Data, @"passportInfo.user.avatarData");
                            }
                        }
                        block(YES);
                        
                    } else {
                        [WXCommLog LogE:[NSString stringWithFormat:@"用户信息修改失败，Error code: %d",status]];
                        block(NO);
                    }
                    // 回调
                    //                    block(YES);
                } else {
                    block(NO);
                }
                
            } else {
                [WXCommLog LogE:[NSString stringWithFormat:@"修改用户信息失败，Error Code : %ld",(long)error.code]];
                block(NO);
            }
            
        }];
        
        
    });
}

@end

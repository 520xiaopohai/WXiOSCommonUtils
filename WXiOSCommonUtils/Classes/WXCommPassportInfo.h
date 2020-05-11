//
//  WXCommPassportInfo.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/4/11.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CommPassportType_none, //无VIP
    CommPassportType_trial, //试用
    CommPassportType_lifetime, //终身
    CommPassportType_yearly, //年度
    CommPassportType_quarterly, //季度
} CommPassportType;

/**
 * 注意：修改用户头像时，需要同时提供用户新头像的Base64数据
 */
///修改用户信息
@interface WXChangeUserInfoData : NSObject
// 需要提供的数据
///用户的数字id
@property (nonatomic,strong) NSString *userId;



//需要修改的数据
///新的昵称
@property (nonatomic,strong) NSString *nickName;
///新的头像本地文件地址
@property (nonatomic,strong) NSString *avatarUrl;
///新的头像ImageBase64Data,不用于上传，只用来替换本地缓存
@property (nonatomic,strong) NSString *avatarImageBase64Data;
@end


@interface WXCommPassportInfo : NSObject

@property (nonatomic, assign) BOOL needVipInfomation; //判断是否需要vip的判断 ;

+ (NSString *)PassportUserAvatarUpdateNotificationName;
+ (NSString *)PassportUserInfoUpdateNotificationName;



+ (void)updatePassportInfoWithLoginCookies:(NSString *)cookies;

#pragma mark - 用户信息
+ (BOOL)isLogined; //判断是否已登录

+ (BOOL)isExpired; //判断是否已过期
+ (BOOL)willExpired; //如果是终身VIP，则不会过期
+ (NSString *)expiredDateString; //到期时间
+ (CommPassportType)passportType; //用户当前购买的VIP类型 ，无，试用、季度、年度、终身

+ (NSString *)UserNickName;  //用户昵称
+ (NSString *)UserEmail;          //用户邮箱
+ (UIImage *)UserAvatar;         //用户头像
+ (NSString *)UserAvatarUrlStr;

#pragma mark - 修改用户信息

typedef void (^checkPassportInfoCompletedResponseBlock) (int status , NSDictionary *passportInfo ,NSError* error);
/// 异步修改用户基本信息
/// @param changeData WXChangeUserInfoData
+ (void)asyncUpdateUserInfo:(WXChangeUserInfoData *)changeData completion:(void(^)(BOOL succ))block;

#pragma mark - 内部数据
+ (NSString *)IdentityToken; // 用户查询用户账户信息的token
+ (NSString *)ApiToken;  // 用来与app功能交互的token

+ (void)clearPassportInfo;

@end

//
//  WXCommDevice.h
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

enum
{
    iPhoneType_unknow = -1,
    iPhoneType_4      = 1,
    iPhoneType_4s     = iPhoneType_4,
    iPhoneType_5      = 2,
    iPhoneType_5s     = iPhoneType_5,
    iPhoneType_5c     = iPhoneType_5,
    iPhoneType_6      = 3,
    iPhoneType_6_plus = 4,
    iPhoneType_X      = 5,
    iPadType_ALL      = 6,
};
typedef NSInteger DeviceType;


enum
{
    NetworkType_NotReachable = 0,
    NetworkType_2G           = 1,
    NetworkType_3G           = 2,
    NetworkType_4G           = 3,
    NetworkType_LTE          = 4,
    NetworkType_WIFI         = 5
};
typedef NSInteger NetworkType;




@interface WXCommDevice : NSObject


#pragma mark - 手机信息
//设备名称
+ (NSString *)deviceName;

//设备UUID
+ (NSString *)deviceUUID;

//设备类型
+ (NSString *)deviceModel;


// 手机型号
+ (NSString *)getIphoneType;
//系统名称
+ (NSString *)deviceSystemName;

//系统版本号
+ (NSString *)deviceSystemVersion;

//设备当前使用语言
+ (NSString *)deviceCurrentLanguage;

//设备当前电量
+ (int)deviceBatteryValue;

//设备分辨率
+ (CGSize)deviceResolution;

// @"%dx%d",weight,height
+ (NSString *)formatDeviceResolution;

//设备显示缩放率
+ (CGFloat)deviceScreenScale;


// 设置
+ (DeviceType)getDeviceType;

#pragma mark -- 获取设备当前ip地址

+ (void)deviceIpAddress:(void(^)(NSString *ip))resultHandler;
+ (NSString *)deviceIpAddress;

#pragma mark- 获取当前的网络类型

+ (NetworkType )getCurrentNetworkType;

#pragma mark - 获取当前已连接网络名称

+ (NSString *)getWifiName;
@end

NS_ASSUME_NONNULL_END

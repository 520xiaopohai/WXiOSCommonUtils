//
//  WXCommDevice.m
//  WXiOSCommonUtils
//
//  Created by qfh on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommDevice.h"
#import "WXCommKeychain.h"
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <net/if_dl.h>
#import <net/if.h>
#import <netinet/in.h>
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation WXCommDevice

#pragma mark - Key

+ (NSString *)deviceUUIDKeyName
{
    return @"key.device.uuid";
}

#pragma mark - 设备信息

+ (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)deviceUUID
{
    id theUUID = [WXCommKeychain load:[self deviceUUIDKeyName]];
    if (theUUID == nil){
        
        //创建一个uuid
        NSString *newUUID = [[NSUUID UUID] UUIDString];
        if (newUUID == nil){
            return @"";
        }
        
        newUUID = [newUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        newUUID = [newUUID lowercaseString];
        
        if ([WXCommKeychain save:[self deviceUUIDKeyName] data:newUUID]){
            
            return (NSString *)[WXCommKeychain load:[self deviceUUIDKeyName]];
            
        }else{
            
//            [CommLog LogE:@"Save uuid to keychain failed."];
        }
    }
    
    if(theUUID == nil){
        theUUID = @"";
    }
    
    return (NSString *)theUUID;
}

+ (NSString *)deviceSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)deviceSystemName
{
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)deviceCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    
    NSString *curLanguage = [languages objectAtIndex:0];
    
    return curLanguage;
}

+ (NSString *)getIphoneType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    ////// iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    /// if ([platform isEqualToString:@""]) return @"";
    
    
    
    //// iPod
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5";
    
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod touch 6";
    
    /// if ([platform isEqualToString:@""]) return @"";
    
    
    
    //// iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad mini";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad mini";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad mini 4";
    
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro (9.7-inch)";
    
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro (9.7-inch)";
    
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5";
    
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro (12.9-inch, 2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro (12.9-inch, 2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro (10.5-inch)";
    
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro (10.5-inch)";
    
    if ([platform isEqualToString:@"iPad7,5"]) return @"iPad 6";
    
    if ([platform isEqualToString:@"iPad7,6"]) return @"iPad 6";
    
    /// if ([platform isEqualToString:@""]) return @"";
    
    
    
    //// iWatch
    if ([platform isEqualToString:@"Watch1,1"]) return @"Apple Watch";
    
    if ([platform isEqualToString:@"Watch1,2"]) return @"Apple Watch";
    
    if ([platform isEqualToString:@"Watch2,6"]) return @"Apple Watch Series 1";
    
    if ([platform isEqualToString:@"Watch2,7"]) return @"Apple Watch Series 1";
    
    if ([platform isEqualToString:@"Watch2,3"]) return @"Apple Watch Series 2";
    
    if ([platform isEqualToString:@"Watch2,4"]) return @"Apple Watch Series 2";
    
    if ([platform isEqualToString:@"Watch3,1"]) return @"Apple Watch Series 3";
    
    if ([platform isEqualToString:@"Watch3,2"]) return @"Apple Watch Series 3";
    
    if ([platform isEqualToString:@"Watch3,3"]) return @"Apple Watch Series 3";
    
    if ([platform isEqualToString:@"Watch3,4"]) return @"Apple Watch Series 3";
    
    if ([platform isEqualToString:@"Watch4,1"]) return @"Apple Watch Series 4";
    
    if ([platform isEqualToString:@"Watch4,2"]) return @"Apple Watch Series 4";
    
    if ([platform isEqualToString:@"Watch4,3"]) return @"Apple Watch Series 4";
    
    if ([platform isEqualToString:@"Watch4,4"]) return @"Apple Watch Series 4";
    //// if ([platform isEqualToString:@""]) return @"";
    
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}



+ (int)deviceBatteryValue
{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return [device batteryLevel]*100;
}

+ (CGSize)deviceResolution
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    return CGSizeMake(screenSize.width*scale, screenSize.height*scale);
}

+ (NSString *)formatDeviceResolution
{
    CGSize size = [self deviceResolution];
    NSString *format = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.height];
    return format;
}

+ (CGFloat)deviceScreenScale
{
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    return scale;
    
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}


+ (DeviceType)getDeviceType
{
    UIUserInterfaceIdiom interfaceIdiom = [[UIDevice currentDevice] userInterfaceIdiom] ;
    
    if(interfaceIdiom == UIUserInterfaceIdiomPhone){
        return [self getIPhoneType];
    }else if(interfaceIdiom == UIUserInterfaceIdiomPad){
        return iPadType_ALL ;
    }
    
    return iPhoneType_unknow ;
}


+ (DeviceType)getIPhoneType
{
    DeviceType devType = iPhoneType_6 ;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if((CGRectGetWidth(frame) == 320) && (CGRectGetHeight(frame) == 480)){
        devType = iPhoneType_4;
    }
    
    if ((CGRectGetWidth(frame) == 320) && (CGRectGetHeight(frame) == 568)){
        devType = iPhoneType_5;
    }
    
    if ((CGRectGetWidth(frame) == 375) && (CGRectGetHeight(frame) == 667)){
        devType = iPhoneType_6;
    }
    
    if ((CGRectGetWidth(frame) == 414) && (CGRectGetHeight(frame) == 736)){
        devType = iPhoneType_6_plus;
    }
    if ((CGRectGetWidth(frame) == 375) && (CGRectGetHeight(frame) == 812)){
        devType = iPhoneType_X;
    }
    return devType;
}

#pragma mark -- 获取设备当前ip地址

+ (void)deviceIpAddress:(void(^)(NSString *ip))resultHandler
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *ip = [self deviceIpAddress] ;
        
        if(resultHandler){
            resultHandler(ip);
        }
        
    });
}

+ (NSString *)deviceIpAddress
{
    @autoreleasepool {
        
        NSMutableDictionary* result = [NSMutableDictionary dictionary];
        
        struct ifaddrs*    addrs;
        
        BOOL success = (getifaddrs(&addrs) == 0);
        
        if (success) {
            
            const struct ifaddrs* cursor = addrs;
            
            while (cursor != NULL) {
                
                NSMutableString* ip;
                
                if (cursor->ifa_addr->sa_family == AF_INET) {
                    
                    const struct sockaddr_in* dlAddr = (const struct sockaddr_in*)cursor->ifa_addr;
                    
                    const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
                    
                    ip = [NSMutableString new];
                    
                    for (int i = 0; i < 4; i++) {
                        
                        if (i != 0)
                            [ip appendFormat:@"."];
                        
                        [ip appendFormat:@"%d", base[i]];
                        
                    }
                    
                    [result setObject:(NSString*)ip forKey:[NSString stringWithFormat:@"%s", cursor->ifa_name]];
                    
                }
                
                cursor = cursor->ifa_next;
            }
            
            freeifaddrs(addrs);
        }
        
        if ([[result allKeys] containsObject:@"en0"]){
            
            return (NSString *)[result objectForKey:@"en0"];
            
        }
    }
    
    return nil ;
}


#pragma mark- 获取当前的网络类型

+ (NetworkType )getCurrentNetworkType
{
    
    //该方法需要保证statusbar没有隐藏.
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    
    for (id child in children){
        
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]){
            
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            break;
        }
    }
    
    return type;
}

#pragma mark - 获取当前已连接网络名称

+ (NSString *)getWifiName
{
    NSString *ssid = nil;
    NSArray *ifs = (__bridge   id)CNCopySupportedInterfaces();
    for (NSString *ifname in ifs) {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if (info[@"SSID"]){
            ssid = info[@"SSID"];
        }
    }
    
    return ssid;
}





@end

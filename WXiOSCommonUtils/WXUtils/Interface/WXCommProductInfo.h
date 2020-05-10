//
//  WXCommProductInfo.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    CommProductInfoIDiOSAirmore=77,
    CommProductInfoIDiOSPhoneTransfer=102,
    CommProductInfoIDiOSDataCleaner=125,
    CommProductInfoIDiOSAirmorePlus=132,
    CommProductInfoIDiOSPhoneManager=136,
    CommProductInfoIDiOSApowerMirror=144,
    CommProductInfoIDiOSApowerRec=172,
    CommProductInfoIDiOSBeeCut=247,
    CommProductInfoIDiOSPDFConvert=273,
    CommProductInfoIDiOSWatermarkManager=283,
    CommProductInfoIDiOSLightMV=315,
    CommProductInfoIDiOSLetsView=353,
    CommProductInfoIDiOSBackgroundEraser=369,
    CommProductInfoIDiOSPDFEditor=399
} CommProductInfoID;


NS_ASSUME_NONNULL_BEGIN

@interface WXCommProductInfo : NSObject

@property (assign) CommProductInfoID identifyID;
@property (strong) NSString *identify;
@property (strong) NSString *localizedName;
@property (strong) NSString *appName;
@property (strong) NSString *urlProduct;
@property (strong) NSString *urlForum;
@property (strong) NSString *urlFAQ;
@property (strong) NSString *urlHome;
@property (strong) NSString *urlSupport;
@property (strong) NSString *copyright;
@property (strong) NSString *brand; //品牌

@property (strong) NSDictionary *jsonDictionary;

/**
 通过已经支持的产品枚举值，返回固定的 程序名（用于 上报，更新，注册，反馈等等），和后台名称一致
 */
+ (NSString*)getAppIdentifyByID:(CommProductInfoID)appID;
+(CommProductInfoID)getAppIDByIdentify:(NSString*)identify;
+ (NSArray *)getAllAppIdentifies;


/**
 获取指定产品的相应语言的产品信息
 appID - 产品ID
 appLang - 当前产品使用的语言， 可以为nil,如果为nil,则自动从[WXiOSCommonUtils appInfo].appLang获取
 appType - 用来从特殊产品中来筛选
 */
+(WXCommProductInfo*)getInfoWithProductID:(CommProductInfoID)appID appLang:(NSString*)lang appType:(NSString*)type;


@end

NS_ASSUME_NONNULL_END

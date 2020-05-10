//
//  WXCommProductInfo.m
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommProductInfo.h"
#import "WXiOSCommonUtils.h"
#import "WXCommTools.h"
#import "WXCommLang.h"

static NSMutableDictionary *m_product_detail_info = nil;
//static NSMutableDictionary *m_product_id_identify_info = nil;
//static NSMutableDictionary *m_product_id_items_info = nil;

static NSMutableDictionary *m_product_id_identify_map = nil;
static NSMutableDictionary *m_product_id_items_map = nil;

@implementation WXCommProductInfo

+ (void)init
{
//    if (!m_product_detail_info || !m_product_id_identify_info || !m_product_id_items_info)
    if (!m_product_detail_info)
    {
        m_product_detail_info = [[NSMutableDictionary alloc] init];
//        m_product_id_identify_info = [[NSMutableDictionary alloc] init];
//        m_product_id_items_info = [[NSMutableDictionary alloc] init];
        
        m_product_id_items_map = [[NSMutableDictionary alloc] init];
        m_product_id_identify_map = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *enumArray = [[NSMutableArray alloc] init];
        //加载通用产品信息
        {
            NSDictionary *json = [self commonProductsInfos];
            NSArray *products = [json objectForKey:@"products"];
            for (NSDictionary *product in products)
            {
                int product_id = [[product objectForKey:@"id"] intValue];
                NSString *product_identify = [product objectForKey:@"identify"];
                [enumArray addObject:[NSString stringWithFormat:@"CommProductInfoID%@=%d",
                                      [product_identify stringByReplacingOccurrencesOfString:@" " withString:@""],
                                      product_id]];
                
                [m_product_id_identify_map setObject:product_identify forKey:[NSString stringWithFormat:@"%d",product_id]];
                NSArray *items = [product objectForKey:@"items"];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                if (![items isKindOfClass:[NSNull class]]&&items && items.count > 0)
                {
                    [m_product_id_items_map setObject:items forKey:[NSString stringWithFormat:@"%d",product_id]];
                    for (NSDictionary *item in items)
                    {
                        WXCommProductInfo *info = [self parseCommProductInfoFromDictionary:item productIdentify:product_identify];
                        info.identifyID = product_id;
                        NSString *lang_code = [item objectForKey:@"lang"];
                        NSArray *lang_codes = [WXCommLang GetlangCodesWithLangCode:lang_code];
                        for (NSString *code in lang_codes)
                        {
                            [dict setObject:info forKey:code];
                        }
                    }
                }
                else
                {
                    //没有items区分的情况
                    WXCommProductInfo *info = [self parseCommProductInfoFromDictionary:nil productIdentify:product_identify];
                    info.identifyID = product_id;
                    [dict setObject:info forKey:@"en"];
                }
                [m_product_detail_info setObject:dict forKey:Int2String(product_id)];
            }
            WXLog(@"\n%@",[enumArray componentsJoinedByString:@",\n"]);
        }
    }
}

+ (NSArray *)getAllAppIdentifies
{
    [self init];
    return [m_product_id_identify_map allValues];
}

+ (NSString *)getAppIdentifyByID:(CommProductInfoID)appID
{
    [self init];
    NSString *identify = [m_product_id_identify_map objectForKey:Int2String(appID)];
    return identify;
}

+(CommProductInfoID)getAppIDByIdentify:(NSString*)theIdentify
{
    [self init];
    NSArray *allKeys = [m_product_id_identify_map allKeys];
    for (NSString *appIdString in allKeys)
    {
        NSString *identify = [m_product_id_identify_map objectForKey:appIdString];
        if ([identify isEqualToString:theIdentify])
        {
            return [appIdString intValue];
        }
    }
    return 0;
}


+(WXCommProductInfo*)getInfoWithProductID:(CommProductInfoID)appID appLang:(NSString*)lang appType:(NSString*)type
{
    [self init];
    WXCommProductInfo *productInfo = [self getProductInfoWithProductID:appID appLang:lang];
    //暂时没有特殊产品需要处理
    return productInfo;
}

+ (WXCommProductInfo *)getProductInfoWithProductID:(CommProductInfoID)productID appLang:(NSString*)lang
{
    [self init];
    if (lang && [lang isEmpty])
    {
        lang = [WXiOSCommonUtils appInfo].appLang;
    }
    NSDictionary *infoDict = [m_product_detail_info objectForKey:Int2String(productID)];
    NSString *langCode = [WXCommLang getLangCodeWithLangName:lang];
    WXCommProductInfo *productInfo = [infoDict objectForKey:langCode];
    WXCommProductInfo *enProductInfo = [infoDict objectForKey:@"en"];
    if (!productInfo)
    {
        productInfo = enProductInfo;
    }
    else
    {
        productInfo = [self checkProductInfo:productInfo withENProductInfo:enProductInfo];
    }
    //TODO:检查FAQ
    
    //区分品牌
    productInfo.brand = [self getProductBrand:productID];
    return productInfo;
}

+ (WXCommProductInfo*)parseCommProductInfoFromDictionary:(NSDictionary*)dict productIdentify:(NSString*)productIdentify
{
    WXCommProductInfo *info = [[WXCommProductInfo alloc] init];
    info.identify = productIdentify;
    if (dict)
    {
        info.jsonDictionary = dict;
        info.localizedName = dict[@"name"];
        info.urlProduct = dict[@"product_url"];
        info.urlForum = dict[@"forum_url"];
        info.urlFAQ = dict[@"faq_url"];
        info.urlHome = dict[@"home_url"];
        info.copyright = dict[@"copyright"];
        info.urlSupport = dict[@"support_url"];
    }
    return info;
}


/**
 对指定语言的ProductInfo进行属性检查，如果为空，则将默认的English语言的ProductInfo相应属性进行赋值
 */
+ (WXCommProductInfo *)checkProductInfo:(WXCommProductInfo *)theInfo withENProductInfo:(WXCommProductInfo *)enInfo
{
    if ([WXCommTools isNullOrEmptyString:theInfo.localizedName])
    {
        theInfo.localizedName = enInfo.localizedName;
    }
    if ([WXCommTools isNullOrEmptyString:theInfo.copyright])
    {
        theInfo.copyright = enInfo.copyright;
    }
    
    if ([WXCommTools isNullOrEmptyString:theInfo.urlProduct])
    {
        theInfo.urlProduct = enInfo.urlProduct;
    }
    if ([WXCommTools isNullOrEmptyString:theInfo.urlHome])
    {
        theInfo.urlHome = enInfo.urlHome;
    }
    if ([WXCommTools isNullOrEmptyString:theInfo.urlFAQ])
    {
        theInfo.urlFAQ = enInfo.urlFAQ;
    }
    if ([WXCommTools isNullOrEmptyString:theInfo.urlForum])
    {
        theInfo.urlForum = enInfo.urlForum;
    }
    if ([WXCommTools isNullOrEmptyString:theInfo.urlSupport])
    {
        theInfo.urlSupport = enInfo.urlSupport;
    }
    return theInfo;
}



+ (NSDictionary *)commonProductsInfos
{
    NSString *jsonPath = WXCommBundleGet(@"CommiOSProductsJson", @"json");
    if (![WXCommTools FileExist:jsonPath])
    {
        NSString *err = [NSString stringWithFormat:@"CommiOSProductsJson.json 文件未找到，路径 %@",jsonPath];
        [WXCommLog LogE:err];
        return nil;
    }
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *context = [[NSString alloc] initWithContentsOfFile:jsonPath usedEncoding:&encoding error:&error];
    if (error)
    {
        NSString *errorString = [NSString stringWithFormat:@"获取CommiOSProductsJson 内容失败 %@",error];
        [WXCommLog LogE:errorString];
    }
    return [WXCommTools jsonToDictionary:context];
}

//TODO: 目前移动端只有Apowersoft 和 LightMV两个品牌
+ (NSString *)getProductBrand:(CommProductInfoID)productID
{
    /*
    if (productID == CommProductInfoIDiOSLightMV) {
        return @"LightMV";
    }
     */
    return @"Apowersoft";
}

@end

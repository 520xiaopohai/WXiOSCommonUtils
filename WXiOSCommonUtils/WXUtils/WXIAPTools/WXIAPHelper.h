//
//  WXIAPHelper.h （内购工具类）
//  ApowerPDFConvert
//
//  Created by ian-mac on 2020/2/26.
//  Copyright © 2020 wxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"
#import "WXSandBoxHelper.h"
typedef void (^IAPProductsResponseBlock)(SKProductsRequest* request , SKProductsResponse* response);

typedef void (^IAPbuyProductCompleteResponseBlock)(SKPaymentTransaction* transcation);

typedef void (^checkReceiptCompleteResponseBlock)(NSString* response,NSError* error);

typedef void (^resoreProductsCompleteResponseBlock) (SKPaymentQueue* payment,NSError* error);

typedef void (^verifyPaymentCompletedResponseBlock) (BOOL succ , NSError* error);

typedef void (^checkPassportInfoCompletedResponseBlock) (int status , NSDictionary *passportInfo ,NSError* error);

/// 产品所在的开发者账号团队的名称
typedef enum : NSUInteger {
    WXProductTeamID_ApowersoftLimited,
    WXProductTeamID_WangxuTech,
} WXProductTeamID;
@interface WXIAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic,strong) NSSet *productIdentifiers;
@property (nonatomic,strong) NSArray * products;
@property (nonatomic,strong) SKProductsRequest *request;
/// 产品所在的开发者账号团队的ID, 默认WXProductTeamID_WangxuTech
@property (nonatomic,assign) WXProductTeamID teamID;
//是否为产品模式。NO - 沙盒 、YES - 线上
@property (nonatomic) BOOL production;


/**
  WXIAPHelper实例
 */
+ (WXIAPHelper *)sharedInstance;

/// App启动时调用
- (void)Setup;

/// 检测支付成功后没有及时回调
- (void)checkIAPFiles;

/// 后续检测支付成功后的回调

@property(nonatomic, copy) void (^IPACheckSucccess)(NSDictionary *product);

/**
 根据产品ID获取产品

 @param productIds 产品id数组
 @param completion 返回请求id的所有h产品
 */
- (void)fetchProductsWithIds:(NSArray *)productIds completion:(IAPProductsResponseBlock)completion;


/// 判断是否已初始化过。根据传入的内购产品ID列表来判断这些内购产品是否都初始化过，如果有一个没有初始化，则返回false
/// @param productIds 内购产品ID列表
- (BOOL)isInitProducts:(NSArray *)productIds;

/// 通过内购产品ID获取内购产品,
/// @param theProductId 内购产品ID
- (SKProduct * _Nullable)getProduct:(NSString *_Nonnull)theProductId;

/**
 购买产品

 @param productIdentifier 通过id请求到的产品
 @param completion  返回交易结果: 成功或失败
 */
- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(IAPbuyProductCompleteResponseBlock)completion;

//恢复购买 （非消耗型，自动续费)
- (void)restoreProductsWithCompletion:(resoreProductsCompleteResponseBlock)completion;


/**
  检查是否购买过 （非消耗型，自动续费)
 */
- (BOOL)isPurchasedProductsIdentifier:(NSString*)productID;

//交易结束后要去appstore验证支付信息是否正确。只有正确后才算是用户完成了购买，并更改自己服务端的用户权限
- (void)checkReceipt:(NSData*)receiptData onCompletion:(checkReceiptCompleteResponseBlock)completion;


- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(checkReceiptCompleteResponseBlock)completion;

//交易结束后通过公司后台服务器进行验证, ads_id 用来跟踪广告的渠道，默认值“appstore”,增加交易的model，优惠券id
- (void)checkReceiptFromServer:(SKProduct *)product adsId:(NSString *)ads_id transaction:(SKPaymentTransaction *)transationModel couponId:(NSString *)coupon_id withCompletedBlock:(verifyPaymentCompletedResponseBlock)block;

//保存已购买的交易ID
- (void)provideContentWithTransaction:(SKPaymentTransaction *)transaction;

//清空已购买
- (void)clearSavedPurchasedProducts;
- (void)clearSavedPurchasedProductByID:(NSString*)productIdentifier;


//获取本地化的价格
- (NSString *)getLocalePrice:(SKProduct *)product;

//TODO：临时接口，后面会去掉
+ (void)checkVIPInfoWithBlock:(checkPassportInfoCompletedResponseBlock)block;

@end


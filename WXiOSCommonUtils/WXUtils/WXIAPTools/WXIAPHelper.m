//
//  WXIAPHelper.m
//  ApowerPDFConvert
//
//  Created by ian-mac on 2020/2/26.
//  Copyright © 2020 wxian. All rights reserved.
//

#import "WXIAPHelper.h"
#import "WXCommLog.h"
#import "NSString+WXExtension.h"
#import "WXCommLang.h"
#import "WXAFNetworking.h"
#import "WXCommPassportInfo.h"
#import "CommPassportHeader.h"
#import "WXCommDevice.h"
#import "WXiOSCommonUtils.h"
static NSString * const receiptKey = @"receipt_key";
@interface WXIAPHelper()
@property (nonatomic,copy) IAPProductsResponseBlock requestProductsBlock;
@property (nonatomic,copy) IAPbuyProductCompleteResponseBlock buyProductCompleteBlock;
@property (nonatomic,copy) resoreProductsCompleteResponseBlock restoreCompletedBlock;
@property (nonatomic,copy) checkReceiptCompleteResponseBlock checkReceiptCompleteBlock;
@property (nonatomic, strong) SKProduct *currrentProduct;
@property (nonatomic,strong) NSMutableData* receiptRequestData;

@end

@implementation WXIAPHelper

+ (WXIAPHelper *)sharedInstance{

    static dispatch_once_t onceToken;

    static WXIAPHelper * helper;

    dispatch_once(&onceToken, ^{

        helper = [[WXIAPHelper alloc] init];
        if ([SKPaymentQueue defaultQueue]) {
            //检测交易状态
            [[SKPaymentQueue defaultQueue]  addTransactionObserver:helper];
        }


    });

    return helper;
}

- (void)dealloc
{
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}


#pragma mark  持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
-(void)saveReceipt {

    NSString *fileName = @"WXipaPurcase";

    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [WXSandBoxHelper iapReceiptPath], fileName];

    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];

    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];

    NSString *receipt = [receiptData base64EncodedStringWithOptions:0];



    NSString *localIdentify = self.currrentProduct.priceLocale.localeIdentifier;
    NSString *price = self.currrentProduct.price.stringValue;
    NSString *language = [WXCommLang curtLanguageCode];
    NSString *countryCode = @"";
    NSString *currencyCode = self.currrentProduct.priceLocale.currencyCode ?: @"USD";
    NSString *productIdentifier = self.currrentProduct.productIdentifier;


    if (@available(iOS 10.0, *)) {
        countryCode = self.currrentProduct.priceLocale.countryCode;
        language = self.currrentProduct.priceLocale.languageCode;
    } else {

        countryCode = [self.currrentProduct.priceLocale objectForKey:NSLocaleCountryCode];
    }

    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        receipt,                           receiptKey,
                        localIdentify,               @"localIdentify",
                        price,                               @"price",
                        countryCode,                   @"countryCode",
                        language,                         @"language",
                        currencyCode,                 @"currencyCode",
                        productIdentifier,       @"productIdentifier",

                        nil];

    NSLog(@"%@",savedPath);

    [dic writeToFile:savedPath atomically:YES];
}



//验证成功就从plist中移除凭证
-(void)removeReceipt{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[WXSandBoxHelper iapReceiptPath]]) {
        [fileManager removeItemAtPath:[WXSandBoxHelper iapReceiptPath] error:nil];
    }
}


#pragma mark 将存储到本地的IAP文件发送给服务端 验证receipt失败,App启动后再次验证
- (void)checkIAPFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;

    //搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[WXSandBoxHelper iapReceiptPath] error:&error];

    if (error == nil) {
        for (NSString *name in cacheFileNameArray) {

            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [WXSandBoxHelper iapReceiptPath], name];
                __weak __typeof(self)weakSelf = self;
                [self checkReceiptFromServer:nil adsId:nil transaction:nil couponId:nil RecipetPath:filePath withCompletedBlock:^(BOOL succ, NSError *error) {
                }];
//                [self checkReceiptFromServer:nil adsId:nil RecipetPath:filePath withCompletedBlock:^(BOOL succ, NSError *error) {
//                }];
            }
        }

    } else {

        NSLog(@"AppStoreInfoLocalFilePath error:%@", [error domain]);
    }
}







/* code by joni 2020-12-31
 * 针对有自动订阅内购产品的App,需要在程序启动时添加监听入口，该方法已放在sharedInstance中，故
 * 暂时Setup方法里暂时没有添加任何操作
 */
- (void)Setup
{
    self.teamID = WXProductTeamID_WangxuTech;


}

- (NSString *)getTeamShortName{
    if (self.teamID == WXProductTeamID_ApowersoftLimited)
    {
        return @"apowersoft";
    }
    return @"wangxutech";
}

-(BOOL)isPurchasedProductsIdentifier:(NSString*)productID
{

    BOOL productPurchased = NO;
    //TODO: 检查本地存储的购买信息

    return productPurchased;
}

- (BOOL)isInitProducts:(NSArray *)productIds
{
    if (self.products == nil || self.products.count == 0) {
        return NO;
    }

    BOOL succ = YES;

    for (SKProduct *product in self.products) {
        NSString *theProductId = product.productIdentifier;
        if (![productIds containsObject:theProductId]){
            succ = NO;
            break;
        }
    }

    return succ;

}

- (SKProduct *)getProduct:(NSString *)theProductId
{
    if (self.products == nil || self.products.count == 0) {
        return nil;
    }

    SKProduct *theProduct = nil;
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:theProductId]) {
            theProduct = product;
            break;
        }
    }

    return theProduct;
}

- (void)fetchProductsWithIds:(NSArray *)productIds completion:(IAPProductsResponseBlock)completion {
    _productIdentifiers = [NSSet setWithArray:productIds];
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _request.delegate = self;
    self.requestProductsBlock = completion;
    [_request start];

}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    self.products = response.products;
    self.request = nil;

    if(_requestProductsBlock) {
        _requestProductsBlock (request,response);
    }

}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"error:%@",error);
}



- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // TODO: Record the transaction on the server side...
}


- (void)provideContentWithTransaction:(SKPaymentTransaction *)transaction {

    NSString* productIdentifier = @"";
    //每次购买记录生成唯一标识
    if (transaction.originalTransaction) {
        productIdentifier = transaction.originalTransaction.payment.productIdentifier;
    }
    else {
        productIdentifier = transaction.payment.productIdentifier;
    }

    //save to local

}

- (void)clearSavedPurchasedProducts {
    //清空已购买
    for (NSString * productIdentifier in _productIdentifiers) {
        [self clearSavedPurchasedProductByID:productIdentifier];
    }

}
- (void)clearSavedPurchasedProductByID:(NSString*)productIdentifier {
    //TODO : 清除已购买的产品

}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {

    // code by joni 2020-12-31
    /* 增加自动订阅模式的处理
     *
     */
    // originalTransaction
    if (transaction.originalTransaction) {
        // 如果是自动续费的订单,originalTransaction会有内容
        NSLog(@"收到了自动续期的订单通知,订单详情：%@ State: %ld",transaction.originalTransaction.transactionIdentifier,(long)transaction.originalTransaction.transactionState);
        [self completeTransaction:transaction isAutomatically:YES];
        return;
    } else {
        //普通购买，以及第一次购买自动订阅
    }


    [self recordTransaction: transaction];

    if ([SKPaymentQueue defaultQueue]) {
        /*
         购买完成必须调用，如果不调用apple会认为购买未完成，而弹出输入apple ID密码
         对于消耗型，在购买成功后调用该方法，购买信息会删除。
         */
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }

    if(_buyProductCompleteBlock)
    {
        _buyProductCompleteBlock(transaction);
    }

}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {


    [self recordTransaction: transaction];
    [self provideContentWithTransaction:transaction];

    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

        //        NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
        //        NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
        //        if (receipt) {
        //            [self checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {
        //
        //            }];
        //        }

        if(_buyProductCompleteBlock!=nil)
        {
            _buyProductCompleteBlock(transaction);
        }
    }

}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {

    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@ %ld", transaction.error.localizedDescription,(long)transaction.error.code);
    }

    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        if(_buyProductCompleteBlock) {
            _buyProductCompleteBlock(transaction);
        }
    }

}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self saveReceipt];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(IAPbuyProductCompleteResponseBlock)completion {

    self.buyProductCompleteBlock = completion;

    self.restoreCompletedBlock = nil;
    self.currrentProduct = productIdentifier;
    SKPayment *payment = [SKPayment paymentWithProduct:productIdentifier];

    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }

}

-(void)restoreProductsWithCompletion:(resoreProductsCompleteResponseBlock)completion {

    //clear it
    self.buyProductCompleteBlock = nil;

    self.restoreCompletedBlock = completion;
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    else {
        NSLog(@"Cannot get the default Queue");
    }


}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {

    NSLog(@"恢复购买失败 error: %@ %ld", error.localizedDescription,(long)error.code);
    if(_restoreCompletedBlock) {
        _restoreCompletedBlock(queue,error);
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {

    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStateRestored:
            {
                [self recordTransaction: transaction];
                [self provideContentWithTransaction:transaction];

            }
            default:
                break;
        }
    }

    if(_restoreCompletedBlock) {
        _restoreCompletedBlock(queue,nil);
    }

}

- (void)checkReceipt:(NSData*)receiptData onCompletion:(checkReceiptCompleteResponseBlock)completion
{
    [self checkReceipt:receiptData AndSharedSecret:nil onCompletion:completion];
}


- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(checkReceiptCompleteResponseBlock)completion
{

    self.checkReceiptCompleteBlock = completion;

    NSError *jsonError = nil;
    NSString *receiptBase64 = [receiptData base64EncodedStringWithOptions:0];

    NSData *jsonData = nil;

    if(secretKey !=nil && ![secretKey isEqualToString:@""]) {

        jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:receiptBase64,@"receipt-data",
                                                            secretKey,@"password",
                                                            nil]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&jsonError];

    }
    else {
        jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            receiptBase64,@"receipt-data",
                                                            nil]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&jsonError
                    ];
    }


    NSURL *requestURL = nil;
    if(_production)
    {
        requestURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    }
    else {
        requestURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    }

    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if(conn) {
        self.receiptRequestData = [[NSMutableData alloc] init];
    } else {
        NSError* error = nil;
        NSMutableDictionary* errorDetail = [[NSMutableDictionary alloc] init];
        [errorDetail setValue:@"Can't create connection" forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"WXIAPHelperError" code:100 userInfo:errorDetail];
        if(_checkReceiptCompleteBlock) {
            _checkReceiptCompleteBlock(nil,error);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Cannot transmit receipt data. %@",[error localizedDescription]);

    if(_checkReceiptCompleteBlock) {
        _checkReceiptCompleteBlock(nil,error);
    }

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receiptRequestData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiptRequestData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:self.receiptRequestData encoding:NSUTF8StringEncoding];

    if(_checkReceiptCompleteBlock) {
        _checkReceiptCompleteBlock(response,nil);
    }
}


- (NSString *)getLocalePrice:(SKProduct *)product {
    if (product) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:product.priceLocale];
        return [formatter stringFromNumber:product.price];
    }
    return @"";


}

#pragma mark - 购买完成后与后台服务器进行验证

//#define Payment_verify_URI  @"https://support.apowersoft.com/api/buy/appstore"
#define Payment_verify_URI @"https://support.aoscdn.com/api/buy/appstore"
#define Payment_verify_Debug_URI  @"http://dev040.apowersoft.com/api/buy/appstore"

//后台验证接口文档
//https://note.youdao.com/ynoteshare1/index.html?id=e996a979059eeb0ba89f2b4748135d89&type=note


- (void)checkReceiptFromServer:(SKProduct *)product adsId:(NSString *)ads_id transaction:(SKPaymentTransaction *)transationModel couponId:(NSString *)coupon_id withCompletedBlock:(verifyPaymentCompletedResponseBlock)block{
//    [self checkReceiptFromServer:product adsId:ads_id transaction:transationModel RecipetPath:@"" withCompletedBlock:block];
    [self checkReceiptFromServer:product adsId:ads_id transaction:transationModel couponId:coupon_id RecipetPath:@"" withCompletedBlock:block];
}

- (void)checkReceiptFromServer:(SKProduct *)product adsId:(NSString *)ads_id transaction:(SKPaymentTransaction *)transationModel couponId:(NSString*)coupon_id RecipetPath:(NSString*)reciptPath withCompletedBlock:(verifyPaymentCompletedResponseBlock)block
{
    [WXCommLog logI:@"开始进行后台支付票据验证"];

    NSString *localIdentify = @"";
    NSString *receipt = @"";
    NSString *price = @"";
    NSString *countryCode = @"";
    NSString *language = @"";
    NSString *country = @"";
    NSString *token = [WXCommPassportInfo identifyToken];
     if (!token || token.length == 0)
    {
        [WXCommLog LogE:@"用户账户token获取失败"];
        //block
        block(NO,nil);
        return;
    }
    ///从本地去检测有没有 没有核销掉的RecciptKey
    NSDictionary *reciptPathDic = @{};
    if (reciptPath && reciptPath.length>0) {
        reciptPathDic = [NSDictionary dictionaryWithContentsOfFile:reciptPath];

        receipt = [reciptPathDic objectForKey:receiptKey];
        localIdentify = [reciptPathDic objectForKey:@"localIdentify"];
        price = [reciptPathDic objectForKey:@"price"];
        countryCode = [reciptPathDic objectForKey:@"countryCode"];
        language = [reciptPathDic objectForKey:@"language"];

        NSString * identifier = [NSLocale localeIdentifierFromComponents:[NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode]];
        country = [[[NSLocale alloc] initWithLocaleIdentifier:countryCode] displayNameForKey:NSLocaleIdentifier value:identifier];

    }else{
        //从沙盒获取支付的数据
        NSData *receiptData = [NSData dataWithContentsOfURL:[NSBundle mainBundle].appStoreReceiptURL];
        if (receiptData == nil)
        {
            [WXCommLog LogE:@"从本地获取支付凭证失败"];
            //block
            block(NO,nil);
            return;
        }
        //将数据进行base64编码
        NSString *receiptDataBase64 = [receiptData base64EncodedStringWithOptions:0];

        //获取用户账户的token
        receipt = receiptDataBase64;

        //校验hash算法
        localIdentify = product.priceLocale.localeIdentifier;



        price = product.price.stringValue;


        //country info

        NSString *country = @"";
        language = [WXCommLang curtLanguageCode];
        if (@available(iOS 10.0, *)) {
            countryCode = product.priceLocale.countryCode;
            language = product.priceLocale.languageCode;
        } else {
            // Fallback on earlier versions
            countryCode = [product.priceLocale objectForKey:NSLocaleCountryCode];
        }

        NSString * identifier = [NSLocale localeIdentifierFromComponents:[NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode]];
        country = [[[NSLocale alloc] initWithLocaleIdentifier:countryCode] displayNameForKey:NSLocaleIdentifier value:identifier];


    }
    NSString *currentcy = @"";
    NSArray *localArray = [localIdentify componentsSeparatedByString:@"="];
    if (localArray.count > 1)
    {
        currentcy = localArray.lastObject;
    }

    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *hash_passwd = @"drZkax06JLHe2VWf";
    NSString *hash_k = [NSString stringWithFormat:@"%@%@%@%@%@%@",receipt,token,currentcy,price,time,hash_passwd];
    NSString *hash_value = [hash_k md5];
    NSString * theAdsId = ads_id;
    if (theAdsId == nil || theAdsId.length == 0) {
        theAdsId = @"appstore";
    }

    // code by joni 2020-12-31
    /* 新增字段,用户区别内购产品如果是自动续期订阅类型，需要额外的字段进行相应的数据校验
     * 自动续期订阅模式 ： 需要通过相应的产品ID拿到对应的App专享密钥再去苹果服务器验证
     *                  验证完成后，需要每次在会员到期前24小时内定时继续向苹果服务器
     *                  验证是否用户已续期
     * - app_id : 369   // 我们自己后台定义的每个app产品的ID
     * - product_type : autoSubscribe // 内购产品类型
     */
    NSDictionary *paymentInfo = @{
                                  @"receipt_data" : receipt,
                                  @"identity_token" : token,
                                  @"currency" : currentcy,
                                  @"invoice_amount" : price,
                                  @"ts" : time,
                                  @"hash" : hash_value,
                                  @"country" : country,
                                  @"country_code" : countryCode,
                                  @"debug": (!self.production ? @"1" : @"0"),
                                  @"transaction_language" : language,
                                  @"product_id":(product.productIdentifier == nil ? @"":product.productIdentifier),
                                  @"transaction_id":(transationModel.transactionIdentifier == nil ? @"":transationModel.transactionIdentifier),
//                                  @"product_team" :[self getTeamShortName],
                                  @"ads_id" : theAdsId,
                                  @"coupon" : (coupon_id == nil ? @"" : coupon_id)
                                  };
    NSLog(@"%@",paymentInfo);
    [WXCommLog LogI:@"向后台发送的验证数据:%@",paymentInfo];
    NSString *verifyURL = Payment_verify_URI;
    /*
     #ifdef DEBUG
     verifyURL = Payment_verify_Debug_URI;
     #else
     verifyURL = Payment_verify_URI;
     #endif
     */
    //发送验证请求
    __weak __typeof(self)weakSelf = self;
    [WXAFNetworking POSTWithUrl:verifyURL withDictrionary:paymentInfo withHeaders:@{} withReturn:^(NSError * _Nullable error, id  _Nullable response) {
        if (response == nil) {
            if (block)
            {
                return block(false , nil);
            }
        }
        NSDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];

        int status = [dictInfo[@"status"] intValue];
        if (status) {
            [WXCommLog logI:@"支付验证成功"];
            //如果本地存在的话 先去产生本地已存在的 key的回调
            if (reciptPath && reciptPath.length > 0) {
                if (self.IPACheckSucccess && reciptPathDic.allKeys.count > 0) {
                    self.IPACheckSucccess(reciptPathDic);
                }
            }
            [self removeReceipt];



            //查询VIP
            [WXIAPHelper checkVIPInfoWithBlock:^(int vipStatus, NSDictionary *passportInfo, NSError *error) {

                [WXCommPassportInfo updateUserPassportInfo:passportInfo];

                //暂时没有支付失败原因
                if (block)
                {
                    block(status , nil);
                }

            }];

        }
        else
        {
            NSString *info = dictInfo[@"info"];
            [WXCommLog LogE:error.description];
            [WXCommLog LogE:@"支付验证失败"];
            [WXCommLog logI:[NSString stringWithFormat:@"错误信息%@",info]];
            [WXCommLog LogE:[NSString stringWithFormat:@"错误码%zd",error.code]];
            [self removeReceipt];
            //暂时没有支付失败原因
            if (block)
            {
                block(status , nil);
            }
        }
    }];

}

//MARK: - 查询VIP信息接口，等新用户中心开发时加上
+ (void)checkVIPInfoWithBlock:(checkPassportInfoCompletedResponseBlock)block
{
    NSString *guid = [WXCommDevice deviceUUID];
    NSString *action = @"get-user-license-info";
    NSString *productName = WXiOSCommonUtils.appInfo.appName;
    NSString *token = WXCommPassportInfo.identifyToken;
    NSString *langName = [WXCommLang deviceLangName];
    NSDictionary *appendInfo = @{
        @"action" : action,
        @"guid" : guid,
        @"product_name" : productName,
        @"identity_token" : token,
        @"language" : langName
    };
    NSString *url = @"https://support.apowersoft.com/api/account";
    url = [url stringByAppendingFormat:@"?action=%@",action];
    url = [url stringByAppendingFormat:@"&product_name=%@",productName];
    url = [url stringByAppendingFormat:@"&language=%@",langName];
    url = [url stringByAppendingFormat:@"&identity_token=%@",token];
    url = [url stringByAppendingFormat:@"&guid=%@",guid];
    url = [url URLEncode];
    [WXAFNetworking POSTTaskWithUrl:url withDictrionary:appendInfo withHeaders:appendInfo withReturn:^(NSError * _Nullable error, id  _Nullable response) {

        if (response) {

            NSDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if (dictInfo)
            {
                int status = [dictInfo[@"status"] intValue];
                NSDictionary *passportInfo = dictInfo[@"data"];
                if (block) {
                    block(status,passportInfo,nil);
                }
            }
        } else {

        }

    }];
}


// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction isAutomatically:(BOOL)isAutomatically{
    // Your application should implement these two methods.
    //    票据的校验是保证内购安全完成的非常关键的一步，一般有三种方式：
    //    1、服务器验证，获取票据信息后上传至信任的服务器，由服务器完成与App Store的验证（提倡使用此方法，比较安全）
    //    2、本地票据校验
    //    3、本地App Store请求验证

    //    NSString * productIdentifier = transaction.payment.productIdentifier;
    //    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    //    if ([productIdentifier length] > 0) {
    //
    //    }
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    // 向自己的服务器验证购买凭证
    //NSError *error;
    //转化为base64字符串
    NSString *receiptString=[receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //除去receiptdata中的特殊字符
    NSString *receipt1=[receiptString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *receipt2=[receipt1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *receipt3=[receipt2 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //最终将这个receipt3的发送给服务器去验证就没问题啦！
    //自动订阅（自动续费月卡）需要多加一个参数

    NSString * product_id = transaction.payment.productIdentifier;
    NSString * transaction_id = transaction.transactionIdentifier;


    NSMutableDictionary * requestContents = [[NSMutableDictionary alloc]init];
    NSString *secretKey = @"drZkax06JLHe2VWf";

    //订阅特殊处理
    if (isAutomatically) {
         //如果是自动续费的订单originalTransaction会有内容
        NSString * transaction_id2 = transaction.originalTransaction.transactionIdentifier;
        NSString * transaction_id = transaction.transactionIdentifier;
        [requestContents addEntriesFromDictionary:@{@"receipt": receipt3,@"password":secretKey,@"product_id":product_id,@"transaction_id":transaction_id,@"originalTransaction":transaction_id2}];
    }else{
//        if (self.parmas.allKeys.count > 0) {
//            [requestContents addEntriesFromDictionary:@{@"receipt": receipt3,@"uid":self.parmas[@"uid"],@"amount":self.parmas[@"amount"],@"actorid":self.parmas[@"userRoleId"],@"server":self.parmas[@"serverId"],@"order_no":self.parmas[@"cpOrderNo"],@"password":secretKey,@"product_id":product_id,@"transaction_id":transaction_id}];
//        }
    }

    NSString * parameters = [self parameters:requestContents];
    NSURL *storeURL = [NSURL URLWithString:Payment_verify_URI];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [storeRequest setTimeoutInterval:30];

    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);


    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //服务器返回的responseObject是gbk编码的字符串，通过gbk编码转码就行了，转码方法如下：
        NSString*gbkStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //转码之后再转utf8解析
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[gbkStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];

        if (jsonDict.allKeys.count > 0) {
            if ([[jsonDict objectForKey:@"code"]intValue] == 0) {
                //[CXLoadingHud showHudWithText:@"购买成功" delay:2];
//                NSDictionary * dataDict = jsonDict[@"data"];
//                [[CXInformationCollect collectInfo]fb_mobile_purchase:dataDict[@"amount"] currency:@""];
//                [[CXInformationCollect collectInfo]af_purchase:@{@"amount":dataDict[@"amount"]}];
            }else if ([[jsonDict objectForKey:@"code"]intValue] == 1){
//                [CXLoadingHud showHudWithText:@"服务器验签失败" delay:2];

            }
        }
        dispatch_semaphore_signal(semaphore);


    }];

    [dataTask resume];

    //本地像苹果app store验证，上面是像自己的服务器验证
    //[self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    //[self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
}


-(NSString *)parameters:(NSDictionary *)parameters
{
    //创建可变字符串来承载拼接后的参数
    NSMutableString *parameterString = [NSMutableString new];
    //获取parameters中所有的key
    NSArray *parameterArray = parameters.allKeys;
    for (int i = 0;i < parameterArray.count;i++) {
        //根据key取出所有的value
        id value = parameters[parameterArray[i]];
        //把parameters的key 和 value进行拼接
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",parameterArray[i],value];
        if (i == parameterArray.count || i == 0) {
            //如果当前参数是最后或者第一个参数就直接拼接到字符串后面，因为第一个参数和最后一个参数不需要加 “&”符号来标识拼接的参数
            [parameterString appendString:keyValue];
        }else
        {
            //拼接参数， &表示与前面的参数拼接
            [parameterString appendString:[NSString stringWithFormat:@"&%@",keyValue]];
        }
    }
    return parameterString;
}

@end

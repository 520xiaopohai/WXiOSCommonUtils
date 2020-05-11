//
//  CommpassportData.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/4/22.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#ifndef CommPassportHeader_h
#define CommPassportHeader_h

static NSString *k_passport_license_type = @"passport_license_type";
static NSString *passport_license_type_trial = @"trial";
static NSString *passport_license_type_lifetime = @"lifetime";
static NSString *passport_license_type_yearly = @"yearly";
static NSString *passport_license_type_quarterly = @"quarterly";

@class WXCommPassportInfo;
@interface WXCommPassportInfo (WXExtension)

+ (void)initPassport;

//+ (NSString *)apiToken;
+ (NSString *)identifyToken;
+ (void)updateUserPassportInfo:(NSDictionary *)dictInfo;
@end

#endif /* CommpassportData_h */

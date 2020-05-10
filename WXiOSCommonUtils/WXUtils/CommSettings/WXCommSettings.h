//
//  CommSettings.h
//  WXCommonUtils
//
//  Created by wangxu on 15/12/24.
//  Copyright © 2015年 apowersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , WXLogType)
{
    WXLogTypeInfo,
    WXLogTypeWarn,
    WXLogTypeError,
    WXLogTypeException,
    WXLogTypeCrash
};

typedef NS_ENUM(NSInteger , WXReportState)
{
    WXReportStateNone,
    WXReportStateSuccess,
    WXReportStateFailed
};

typedef NS_ENUM(NSInteger , WXServerActionType)
{
    WXServerActionTypeReport = 1,
    WXServerActionTypeLicense = 2,
    WXServerActionTypeFeedback = 3,
    WXServerActionTypeUpdate = 4
};


typedef NS_ENUM(NSInteger , WXFeedbackState)
{
    WXFeedbackStateNone,
    WXFeedbackStateSuccess,
    WXFeedbackStateFailed
};


@interface WXCommSettings : NSObject
+(NSString*)    SERVER_API_URL;
+(NSString*)    DesKey;
+(NSString*)    KEY_REPORTDATA;
+(NSString*)    KEY_UPDATESKIPVERSION;

+ (BOOL)isNullClass:(NSObject *)obj;

@end

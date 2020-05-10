//
//  CommShareMetaData.h
//  WXCommonTools
//
//  Created by Joni.li on 2020/1/10.
//  Copyright © 2020 fingerfinger. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - CommShareMetaData
@interface WXCommShareMetaData : NSObject
@property (strong) UIImage *shareIcon;
@property (strong) NSURL *sharedURL;
@end

#pragma mark - CommShareMetaData
@interface WXCommShareAppSysMetaData : WXCommShareMetaData
@property (strong) NSString *shareMessage;
@end


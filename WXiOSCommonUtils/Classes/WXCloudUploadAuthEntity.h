//
//  WXCloudUploadAuthEntity.h
//  Apowersoft IOS AirMore
//
//  Created by wxian on 2019/1/14.
//  Copyright © 2019 Joni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXCloudUploadCallBackEntity : NSObject

@property (nonatomic, strong) NSString *callbackUrl;

@property (nonatomic, strong) NSString *callbackBody;

@property (nonatomic, strong) NSString *callbackBodyType;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface WXCloudUploadPathEntity : NSObject

@property (nonatomic, strong) NSString *resources;

@property (nonatomic, strong) NSString *images;

@property (nonatomic, strong) NSString *videos;

@property (nonatomic, strong) NSString *audios;

@property (nonatomic, strong) NSString *image;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface WXCloudOSSEntity : NSObject

@property (nonatomic, strong) NSString *access_id;

@property (nonatomic, strong) NSString *access_secret;

@property (nonatomic, strong) NSString *security_token;

@property (nonatomic, strong) NSString *expires_in;

@property (nonatomic, strong) NSString *cdn_domain;

@property (nonatomic, strong) NSString *bucket;

@property (nonatomic, strong) NSString *endpoint;

@property (nonatomic, strong) NSString *region_id;

@property (nonatomic, strong) NSString *region;

@property (nonatomic, strong) NSString *folder;

@property (nonatomic, strong) NSString *video_folder;

@property (nonatomic, strong) WXCloudUploadPathEntity *path;

@property (nonatomic, strong) WXCloudUploadCallBackEntity *callback;

@property (nonatomic, strong) WXCloudUploadCallBackEntity *callback_url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end


@interface WXCloudUploadAuthEntity : NSObject


@property (nonatomic, strong) WXCloudUploadCallBackEntity *callback;

@property (nonatomic, strong) WXCloudOSSEntity *oss;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

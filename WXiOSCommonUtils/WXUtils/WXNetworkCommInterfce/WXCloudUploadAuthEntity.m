//
//  WXCloudUploadAuthEntity.m
//  Apowersoft IOS AirMore
//
//  Created by wxian on 2019/1/14.
//  Copyright © 2019 Joni. All rights reserved.
//

#import "WXCloudUploadAuthEntity.h"

@implementation WXCloudUploadCallBackEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}


@end

@implementation WXCloudUploadPathEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}


@end

@implementation WXCloudOSSEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (value) {
        if ([key isEqualToString:@"path"]) {
            self.path = [[WXCloudUploadPathEntity alloc]initWithDictionary:value];
        } else if ([key isEqualToString:@"callback"]) {
            self.callback = [[WXCloudUploadCallBackEntity alloc]initWithDictionary:value];
        } else if ([key isEqualToString:@"callback_url"]) {
            self.callback_url = [[WXCloudUploadCallBackEntity alloc]initWithDictionary:value];
        } else {
            [super setValue:value forKey:key];
        }
    } else {
        [super setValue:value forKey:key];
    }
    
}

@end

@implementation WXCloudUploadAuthEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (value) {
        if ([key isEqualToString:@"oss"]) {
            self.oss = [[WXCloudOSSEntity alloc]initWithDictionary:value];
        } else if ([key isEqualToString:@"callback"]) {
            self.callback = [[WXCloudUploadCallBackEntity alloc]initWithDictionary:value];
        } else {
            [super setValue:value forKey:key];
        }
    } else {
        [super setValue:value forKey:key];
    }
    
}

@end

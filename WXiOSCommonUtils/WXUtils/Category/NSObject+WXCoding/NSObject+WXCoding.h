
#import <Foundation/Foundation.h>

@interface NSObject (HZCoding)

-(void)wx_encode:(NSCoder *)aCoder;
-(void)wx_decode:(NSCoder *)aDecoder;

-(NSArray *)getAllProperties;

/* 获取对象的所有方法 */
-(NSArray *)getAllMethods;

/* 获取对象的所有属性和属性内容 */
-(NSDictionary *)getAllPropertiesAndVaules;

#define WXCodingImplementation \
-(void)encodeWithCoder:(NSCoder *)aCoder\
{\
    [self wx_encode:aCoder];\
}\
-(instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
    if (self = [super init]) {\
        [self wx_decode:aDecoder];\
    }return self; \
}

@end

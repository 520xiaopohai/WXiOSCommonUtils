//
//  WXCommDefine.h
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/18.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#ifndef WXCommDefine_h
#define WXCommDefine_h

#pragma mark -  ----通用宏定义----

#pragma mark - Bundle
//读取存放在主程序中的非 Main Bundle
#define WXBundle(BundleName) [NSBundle bundleWithURL: [[NSBundle mainBundle] URLForResource:BundleName withExtension:@"bundle"]]
//取出非Main Bundle中的资源文件
#define WXCommBundleGet(SourceName,SourceType)  [WXBundle(@"WXiOSCommonUtilsSource") pathForResource:SourceName ofType:SourceType]
//取出Main Bundle中的资源文件
#define WXMainBundleGet(SourceName,SourceType) [[NSBundle mainBundle] pathForResource:SourceName ofType:SourceType]

#pragma mark - 数据类型转换
//int型转NSString
#define Int2String(intValue) [NSString stringWithFormat:@"%d",(int)intValue]

#endif /* WXCommDefine_h */

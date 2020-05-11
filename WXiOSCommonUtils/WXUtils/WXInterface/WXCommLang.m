//
//  WXCommLang.m
//  WXiOSCommonUtils
//
//  Created by Joni.li on 2020/2/16.
//  Copyright © 2020 Wangxu Apple Team - Joni. All rights reserved.
//

#import "WXCommLang.h"
#import "WXCommDevice.h"
#import "WXiOSCommonUtils.h"
#import "NSString+WXExtension.h"

#define kLangName          @"name"
#define kLangLocalName @"localName"

@implementation WXCommLang

+ (NSArray *)GetlangCodesWithLangCode:(NSString *)langCode
{
    NSDictionary *dict = @{
                         @"jp":@[@"jp",@"ja"],
                         @"ja":@[@"jp",@"ja"],
                         
                         @"hk":@[@"hk",@"zh",@"cn"],
                         @"zh":@[@"hk",@"zh",@"cn"],
                         @"cn":@[@"hk",@"zh",@"cn"],
                         
                         @"cz":@[@"cz",@"cs"],
                         @"cs":@[@"cz",@"cs"],
                         
                         @"dk":@[@"dk",@"da"],
                         @"da":@[@"dk",@"da"],
                         
                         @"gr":@[@"gr",@"el"],
                         @"el":@[@"gr",@"el"],
                         
                         @"se":@[@"se",@"sv"],
                         @"sv":@[@"se",@"sv"]
                         };
    
    NSArray *arr=[dict objectForKey:langCode];
    if(arr){
        return arr;
    }else{
        return @[langCode];
    }
}

+ (NSString *)getLangCodeWithLangName:(NSString *)langName
{
    if (langName && langName.length == 2)
    {
        return langName;
    }
    
    NSString *langCode = [[self GetAllLangCodes] objectForKey:langName];
    if (langCode == nil)
    {
        langCode = @"en";
    }
    return langCode;
}

+ (NSString *)deviceLangName
{
    NSString *sysLangName = [WXCommDevice deviceCurrentLanguage];
    NSString *formatLang = [self getClientLangWithSystemLang:sysLangName];
    return formatLang;
}

+ (NSString *)getClientLangWithSystemLang:(NSString *)systemLang
{
    NSString *inputLang = [systemLang lowercaseString];
    if ([inputLang isContainsString:@"zh"])
    {
        //中文简体
        if ([inputLang isContainsString:@"hans"])
        {
            return @"ChineseSimplified";
        }
        //中文繁体
        if ([inputLang isContainsString:@"hant"])
        {
            return @"ChineseTraditional";
        }
    }
    //捷克
    if ([inputLang isContainsString:@"cs"])
    {
        return @"Czech";
    }
    //丹麦
    if ([inputLang isContainsString:@"da"])
    {
        return @"Danish";
    }
    //荷兰
    if ([inputLang isContainsString:@"nl"])
    {
        return @"Dutch";
    }
    //芬兰
    if ([inputLang isContainsString:@"fi"])
    {
        return @"Finnish";
    }
    //法国
    if ([inputLang isContainsString:@"fr"])
    {
        return @"French";
    }
    //德国
    if ([inputLang isContainsString:@"de"])
    {
        return @"German";
    }
    //希腊
    if ([inputLang isContainsString:@"el"])
    {
        return @"Greek";
    }
    //匈牙利
    if ([inputLang isContainsString:@"hu"])
    {
        return @"Hungarian";
    }
    //意大利
    if ([inputLang isContainsString:@"it"])
    {
        return @"Italian";
    }
    //日本
    if ([inputLang isContainsString:@"jp"] || [inputLang isContainsString:@"ja"])
    {
        return @"Japanese";
    }
    //挪威
    if ([inputLang isContainsString:@"nb"] || [inputLang isContainsString:@"no"])
    {
        return @"Norwegian";
    }
    //波兰
    if ([inputLang isContainsString:@"pl"])
    {
        return @"Polish";
    }
    //葡萄牙
    if ([inputLang isContainsString:@"pt"] )
    {
        //葡萄牙(巴西)
        if ([inputLang isContainsString:@"br"])
        {
            return @"PortugueseBrazil";
        }
         return @"Portuguese";
    }
    //西班牙
    if ([inputLang isContainsString:@"es"])
    {
        return @"Spanish";
    }
    //瑞典
    if ([inputLang isContainsString:@"sv"])
    {
        return @"Swedish";
    }
    //土耳其
    if ([inputLang isContainsString:@"tr"])
    {
        return @"Turkish";
    }
    
    return @"English";
}

+ (NSArray *)allLangNames
{
    NSDictionary *langInfo = [self GetAllLangDicts];
    NSArray *allValues = [langInfo allValues];
    NSMutableArray *langNames = [[NSMutableArray alloc] init];
    for (NSDictionary *info in allValues)
    {
        NSString *langName = [info objectForKey:kLangName];
        [langNames addObject:langName];
    }
    return langNames;
}

+ (NSArray *)allLangLocalNames
{
    NSDictionary *langInfo = [self GetAllLangDicts];
    NSArray *allValues = [langInfo allValues];
    NSMutableArray *langLocalNames = [[NSMutableArray alloc] init];
    for (NSDictionary *info in allValues)
    {
        NSString *langName = [info objectForKey:kLangLocalName];
        [langLocalNames addObject:langName];
    }
    return langLocalNames;
}

+ (NSString *)getLocalizationLangNameWithLangCode:(NSString *)langCode
{
    NSDictionary *langInfo = [[self GetAllLangDicts] objectForKey:langCode];
    if (langInfo == nil)
    {
        langInfo = [[self GetAllLangDicts] objectForKey:@"en"];
    }
    NSString *localName = [langInfo objectForKey:kLangLocalName];
    if (localName == nil || [localName isEmpty])
    {
        localName = @"English";
    }
    
    return localName;
}

+ (NSString *)getLangNameWithLangCode:(NSString *)langCode
{
    NSDictionary *langInfo = [[self GetAllLangDicts] objectForKey:langCode];
    if (langInfo == nil)
    {
        return @"English";
    }
    NSString *langName = [langInfo objectForKey:kLangName];
    if (langName == nil || [langName isEmpty])
    {
        langName = @"English";
    }
    return langName;
}

+ (NSDictionary *)GetAllLangDicts
{
    return @{
             @"zh":@{kLangName:@"ChineseSimplified",kLangLocalName:@"中文简体"},
             @"tw":@{kLangName:@"ChineseTraditional",kLangLocalName:@"中文繁体"},
             @"cz":@{kLangName:@"Czech",kLangLocalName:@"Čeština"},
             @"da":@{kLangName:@"Danish",kLangLocalName:@"Dansk"},
             @"nl":@{kLangName:@"Dutch",kLangLocalName:@"Nederlands"},
             @"en":@{kLangName:@"English",kLangLocalName:@"English"},
             @"fi":@{kLangName:@"Finnish",kLangLocalName:@"Suomi"},
             @"fr":@{kLangName:@"French",kLangLocalName:@"Français"},
             @"de":@{kLangName:@"German",kLangLocalName:@"Deutsch"},
             @"gr":@{kLangName:@"Greek",kLangLocalName:@"Eλληνικά"},
             @"hu":@{kLangName:@"Hungarian",kLangLocalName:@"Magyar"},
             @"it":@{kLangName:@"Italian",kLangLocalName:@"Italian"},
             @"jp":@{kLangName:@"Japanese",kLangLocalName:@"日本語"},
             @"no":@{kLangName:@"Norwegian",kLangLocalName:@"Norsk"},
             @"pl":@{kLangName:@"Polish",kLangLocalName:@"Polski"},
             @"pt":@{kLangName:@"Portuguese",kLangLocalName:@"Português(PT)"},
             @"pt-br":@{kLangName:@"PortugueseBrazil",kLangLocalName:@"Português(BR)"},
             @"es":@{kLangName:@"Spanish",kLangLocalName:@"Spanish"},
             @"se":@{kLangName:@"Swedish",kLangLocalName:@"Svenska"},
             @"tr":@{kLangName:@"Turkish",kLangLocalName:@"Türkçe"},
             };
}

+ (NSDictionary *)GetAllLangCodes
{
    return @{
             @"French": @"fr",
             @"German": @"de",
             @"Deutsch": @"de",
             @"Italian": @"it",
             @"Spanish": @"es",
             @"PortugueseBrazil": @"pt",
             @"Portuguese": @"pt",
             @"Dutch": @"nl",
             @"Nederlands": @"nl",
             @"Janpanese": @"jp",
             @"Japanese": @"jp",
             @"Japan": @"jp",
             @"ChineseSimplified": @"zh",
             @"Chinese": @"zh",
             @"ChineseTraditional": @"tw",
             @"Czech": @"cz",
             @"Danish": @"da",
             @"Finnish": @"fi",
             @"Greek": @"gr",
             @"Hungarian": @"hu",
             @"Norwegian": @"no",
             @"Polish": @"pl",
             @"Swedish": @"se",
             @"Turkish": @"tr",
             @"Slovenian": @"sl",
             @"Russian": @"ru",
             @"English":@"en"
             };
}

+ (NSString*)curtLanguageCode
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *curLanguage = [languages objectAtIndex:0];
    
    if ([curLanguage rangeOfString:@"zh-Hans"].location != NSNotFound){
        return @"zh";
    }else if ([curLanguage rangeOfString:@"zh-Hant"].location != NSNotFound ||
              [curLanguage rangeOfString:@"zh-HK"].location != NSNotFound ){
        return @"tw";
    }else if ([curLanguage rangeOfString:@"ja"].location != NSNotFound ){
        return @"jp";
    }else if ([curLanguage rangeOfString:@"fr"].location != NSNotFound){
        return @"fr";
    }else if ([curLanguage rangeOfString:@"de"].location != NSNotFound){
        return @"de";
    }else if ([curLanguage rangeOfString:@"it"].location != NSNotFound){
        return @"it";
    }else if ([curLanguage rangeOfString:@"cs"].location != NSNotFound){
        return @"cz";
    }else if ([curLanguage rangeOfString:@"da"].location != NSNotFound){
        return @"dk";
    }else if ([curLanguage rangeOfString:@"nl"].location != NSNotFound){
        return @"nl";
    }else if ([curLanguage rangeOfString:@"hu"].location != NSNotFound){
        return @"hu";
    }else if ([curLanguage rangeOfString:@"nb"].location != NSNotFound){
        return @"no";
    }else if ([curLanguage rangeOfString:@"pl"].location != NSNotFound){
        return @"pl";
    }else if ([curLanguage rangeOfString:@"pt"].location != NSNotFound){
        return @"br";
    }else if ([curLanguage rangeOfString:@"es"].location != NSNotFound){
        return @"es";
    }else if ([curLanguage rangeOfString:@"sv"].location != NSNotFound){
        return @"se";
    }else if ([curLanguage rangeOfString:@"tr"].location != NSNotFound){
        return @"tr";
    }
    
    return @"en";
}

#pragma mark - -------多语言翻译模块---------

static NSMutableDictionary *jsonLangDicts = nil;
static BOOL bIsJsonLangInited = false;
#pragma mark - Json结构
+ (void)LoadLangWithJsonFiles:(NSArray *)files
{
    bIsJsonLangInited = false;
    
    if (jsonLangDicts == nil) {
        jsonLangDicts = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    for (NSString *filePath in files) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        if (data != nil && data.length > 0)
        {
            NSString *LangKey = filePath.lastPathComponent.stringByDeletingPathExtension;
            NSDictionary *langDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (langDict != nil && langDict.count > 0) {
                [jsonLangDicts setObject:langDict forKey:LangKey];
            }
        }
    }
    
    bIsJsonLangInited = YES;
}

+ (BOOL)JsonLangInited
{
    return bIsJsonLangInited;
}

+ (NSString *)JsonLang:(NSString *)key
{
    WXCommAppInfo *appInfo = [WXiOSCommonUtils appInfo];
    NSString *langCode = @"en";
    if (appInfo != nil)
    {
        langCode = appInfo.appLangCode;
    }
    else {
        langCode = [self curtLanguageCode];
    }
    
    if (langCode == nil || langCode.length == 0)
    {
        langCode = @"en";
    }
    
    if (jsonLangDicts != nil && jsonLangDicts.count > 0)
    {
        NSDictionary *langDict = [jsonLangDicts objectForKey:langCode];
        if (langDict == nil)
        {
            langDict = [jsonLangDicts objectForKey:@"en"];
        }
        NSString *keyValue = [langDict objectForKey:key];
        if (keyValue != nil || keyValue.length > 0)
        {
            return keyValue;
        }
    }
    return [NSString stringWithFormat:@"#%@#",key];
}


/**
 当前是否是中文
 
 @return 是
 */
+ (BOOL)isChinese
{
    if ([[self deviceLangName].lowercaseString isEqualToString:@"chinesesimplified"]) {
        return YES;
    }
    return NO;
}

@end

//
//  FDLocalizationManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 4/18/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDLocalizationManager.h"

@implementation FDLocalizationManager

+ (id)sharedManager
{
    static FDLocalizationManager *sharedLocalizationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocalizationManager = [[self alloc] init];
    });
    return sharedLocalizationManager;
}

- (id)init
{
    if(self = [super init]) {
        ;
    }
    return self;
}

- (NSString *)localizedStringForPath:(NSString *)path
{
    id obj = [self localizationForPath:path];
    if(!obj)
        return @"";
    NSString *str = (NSString *)obj;
    return [self regexedLocalizationString:str];
}

- (NSArray *)localizedArrayForPath:(NSString *)path
{
    id obj = [self localizationForPath:path];
    if(!obj)
        return nil;
    NSArray *array = (NSArray *)obj;
    
    NSMutableArray *localizedStrings = [[NSMutableArray alloc] init];
    for(NSString *str in array) {
        [localizedStrings addObject:[self regexedLocalizationString:str]];
    }
    return [localizedStrings copy];
}

- (NSArray *)localizedDictionaryValuesForPath:(NSString *)path
{
    id obj = [self localizationForPath:path];
    if(!obj)
        return nil;
    NSDictionary *dict = (NSDictionary *)obj;
    
    NSMutableArray *localizedStrings = [[NSMutableArray alloc] init];
    for(NSString *str in [dict allValues]) {
        [localizedStrings addObject:[self regexedLocalizationString:str]];
    }
    return [localizedStrings copy];
}

- (NSString *)regexedLocalizationString:(NSString *)str
{
    //regex to replace "{{field}}" or {{field}} with %@
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"\\{\\{.*\\}\\}\"|\\{\\{.*\\}\\}" options:NSRegularExpressionCaseInsensitive error:nil];
    str = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@"%@"];
    
    return str;
}

- (id)localizationForPath:(NSString *)path
{
    NSString *locale = [self currentLocale];
    NSString *localePath = [NSString stringWithFormat:@"%@/%@", locale, path];
    
    int rangeStart = 0;
    NSDictionary *currentDictionary = [self localizationDictionaryForCurrentLocale];
    for(int i = 0; i < localePath.length; i++) {
        if([localePath characterAtIndex:i] == '/') {
            NSString *substring = [localePath substringWithRange:NSMakeRange(rangeStart, i-rangeStart)];
            i++;
            rangeStart = i;
            currentDictionary = [currentDictionary objectForKey:substring];
        }
    }
    id obj = [currentDictionary objectForKey:[localePath substringFromIndex:rangeStart]];
    
    if(!obj) {
        NSLog(@"Localization object: %@ not found", localePath);
        return nil;
    }
    return obj;
}

- (NSString *)currentLocale
{
    return [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
}

- (NSDictionary *)localizationDictionaryForCurrentLocale
{
    NSString *locale = [self currentLocale];
    NSString *prefsPath = [@"locale-" stringByAppendingString:locale];
    
    if(!_currentLocalizationDictionary) {
        //check prefs
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *json = [userDefaults objectForKey:prefsPath];
        
        //Use default if not stored
        if(!json) {
    
            NSString *filePath = [[NSBundle mainBundle] pathForResource:locale ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            
            NSError *error;
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if(error) {
                NSLog(@"Locale file not found for locale: %@", locale);
                return nil;
            }
            
            [userDefaults setObject:json forKey:[@"locale-" stringByAppendingString:locale]];
        }
        _currentLocalizationDictionary = json;
    }
    return _currentLocalizationDictionary;
}

- (void)setLocalizationDictionaryForCurrentLocale:(NSDictionary *)content
{
    NSString *locale = [self currentLocale];
    NSString *prefsPath = [@"locale-" stringByAppendingString:locale];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:content forKey:prefsPath];
    
    _currentLocalizationDictionary = content;
    
    NSLog(@"Successfully saved new locale data");
}

- (void)clearLocalizationDictionaryForCurrentLocale:(NSDictionary *)content
{
    NSString *locale = [self currentLocale];
    NSString *prefsPath = [@"locale-" stringByAppendingString:locale];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:prefsPath];
    
    _currentLocalizationDictionary = nil;
    
    NSLog(@"Successfully cleared old locale data");
}

@end

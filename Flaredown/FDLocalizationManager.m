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
    NSString *str = [currentDictionary objectForKey:[localePath substringFromIndex:rangeStart]];
    
    if(!str) {
        NSLog(@"Localization string: %@ not found", localePath);
        return @"";
    }
    
    //regex to replace "{{field}}" or {{field}} with %@
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"\\{\\{.*\\}\\}\"|\\{\\{.*\\}\\}" options:NSRegularExpressionCaseInsensitive error:nil];
    str = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@"%@"];
    
    return str;
}

- (NSString *)currentLocale
{
    return [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
}

- (NSDictionary *)localizationDictionaryForCurrentLocale
{
    if(!_currentLocalizationDictionary) {
        NSString *locale = [self currentLocale];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:locale ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error) {
            NSLog(@"Localization dictionary not found for locale: %@", locale);
            return nil;
        }
        _currentLocalizationDictionary = json;
    }
    return _currentLocalizationDictionary;
}

- (void)setLocalizationDictionaryForCurrentLocale:(NSDictionary *)content
{
    NSString *locale = [self currentLocale];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:locale ofType:@"json"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:content options:0 error:&error];
    
    if(error) {
        NSLog(@"Error serializing localization json data: %@", error);
        return;
    }
    
    [data writeToFile:filePath options:0 error:&error];
    
    if(error) {
        NSLog(@"Error writing localization json to file: %@", error);
        return;
    }
    
    NSLog(@"Successfully wrote localization data to file");
}

@end

//
//  FDLocalizationManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 4/18/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FDLocalizedString(_path) [[FDLocalizationManager sharedManager] localizedStringForPath:(_path)]

@interface FDLocalizationManager : NSObject

@property NSDictionary *currentLocalizationDictionary;

+ (id)sharedManager;

- (NSString *)localizedStringForPath:(NSString *)path;
- (void)setLocalizationDictionaryForCurrentLocale:(NSDictionary *)content;
- (void)clearLocalizationDictionaryForCurrentLocale:(NSDictionary *)content;

- (NSString *)currentLocale;

@end

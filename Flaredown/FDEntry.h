//
//  FDEntry.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDResponse.h"

@interface FDEntry : NSObject

@property NSString *entryId;
@property NSString *date;
@property NSArray *catalogs;
@property NSArray *questions;
@property NSMutableArray *responses;
@property NSArray *scores;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryCopy;
- (NSDictionary *)responseDictionaryCopy;
- (void)insertResponse:(FDResponse *)response;
- (void)removeResponse:(FDResponse *)response;
- (FDResponse *)responseForId:(NSString *)responseId;

@end

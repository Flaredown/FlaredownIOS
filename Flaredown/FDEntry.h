//
//  FDEntry.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDResponse;
@class FDTreatment;
@class FDQuestion;

@interface FDEntry : NSObject

@property NSString *entryId;
@property NSString *date;
@property NSArray *catalogs;
@property NSMutableArray *questions;
@property NSString *notes;
@property NSMutableArray *responses;
@property NSMutableArray *treatments;
@property NSArray *scores;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryCopy;
- (NSDictionary *)responseDictionaryCopy;
- (NSArray *)questionsForCatalog:(NSString *)catalog;
- (void)insertQuestion:(FDQuestion *)question atIndex:(NSInteger)index;
- (void)insertResponse:(FDResponse *)response;
- (void)removeResponse:(FDResponse *)response;
- (FDResponse *)responseForId:(NSString *)responseId;

@end

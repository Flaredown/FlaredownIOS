//
//  FDResponse.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDQuestion;
@class FDEntry;

@interface FDResponse : NSObject

@property NSString *responseId;
@property NSString *name;
@property int value;
@property NSString *catalog;
@property BOOL responded;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithEntry:(FDEntry *)entry question:(FDQuestion *)question;
- (NSDictionary *)dictionaryCopy;
- (void)setResponseIdWithCatalog:(NSString *)catalog entryId:(NSString *)entryId name:(NSString *)name;

@end

//
//  FDResponse.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDQuestion.h"

@interface FDResponse : NSObject

@property NSString *responseId;
@property NSString *name;
@property int value;
@property NSString *catalog;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryCopy;
- (void)setResponseIdWithEntryId:(NSString *)entryId name:(NSString *)name;

@end

//
//  FDCondition.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/26/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDEntry;

@interface FDCondition : NSObject

@property NSString *conditionId;
@property NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithTitle:(NSString *)title entry:(FDEntry *)entry;
- (NSDictionary *)dictionaryCopy;

@end

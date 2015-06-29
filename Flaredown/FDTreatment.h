//
//  FDTreatment.h
//  Flaredown
//
//  Created by Cole Cunningham on 12/17/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FDDose.h"
@class FDEntry;

@interface FDTreatment : NSObject

@property NSString *treatmentId;
@property NSString *name;
@property NSMutableArray *doses;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithTitle:(NSString *)title entry:(FDEntry *)entry;
- (NSArray *)arrayCopy;
- (NSDictionary *)dictionaryCopy;
- (NSDictionary *)dictionaryCopyWithDose:(FDDose *)dose;

@end

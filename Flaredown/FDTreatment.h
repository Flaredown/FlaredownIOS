//
//  FDTreatment.h
//  Flaredown
//
//  Created by Cole Cunningham on 12/17/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDEntry;

@interface FDTreatment : NSObject

@property NSString *treatmentId;
@property NSString *name;
@property float quantity;
@property NSString *unit;
@property BOOL taken;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithTitle:(NSString *)title quantity:(float)quantity unit:(NSString *)unit entry:(FDEntry *)entry;
- (NSDictionary *)dictionaryCopy;

@end

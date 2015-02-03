//
//  FDSymptom.h
//  Flaredown
//
//  Created by Cole Cunningham on 1/18/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDEntry;

@interface FDSymptom : NSObject

@property NSString *symptomId;
@property NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithTitle:(NSString *)title entry:(FDEntry *)entry;
- (NSDictionary *)dictionaryCopy;

@end

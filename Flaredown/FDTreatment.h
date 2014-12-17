//
//  FDTreatment.h
//  Flaredown
//
//  Created by Cole Cunningham on 12/17/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDTreatment : NSObject

@property NSString *treatmentId;
@property NSString *name;
@property float quantity;
@property NSString *unit;

- (NSDictionary *)dictionaryCopy;

@end

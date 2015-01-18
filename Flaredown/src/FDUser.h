//
//  FDUser.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDTreatment.h"
#import "FDSymptom.h"

@interface FDUser : NSObject

@property NSInteger userId;
@property NSString *email;
@property NSString *authenticationToken;

@property NSMutableArray *treatments;
@property NSMutableArray *symptoms;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryCopy;

@end

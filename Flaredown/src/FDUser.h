//
//  FDUser.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDTreatment;
@class FDSymptom;

@interface FDUser : NSObject

@property NSInteger userId;
@property NSString *email;
@property NSString *authenticationToken;

@property NSMutableArray *treatments;
@property NSMutableArray *symptoms;
@property NSMutableArray *conditions;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryCopy;

@end

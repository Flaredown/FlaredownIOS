//
//  FDTrackableResult.h
//  Flaredown
//
//  Created by Cole Cunningham on 2/18/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDTrackableResult : NSObject

@property NSString *name;
@property NSInteger actives;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

//
//  FDAnalyticsManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/4/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FDUser.h"

@interface FDAnalyticsManager : NSObject

+ (id)sharedManager;

- (void)registerUser:(FDUser *)user;
- (void)updateUser:(FDUser *)user;
- (void)clearUser;

@end

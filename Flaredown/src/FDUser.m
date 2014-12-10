//
//  FDUser.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDUser.h"

@implementation FDUser

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        _userId = [[dictionary objectForKey:@"id"] integerValue];
        _email = [dictionary objectForKey:@"email"];
        _authenticationToken = [dictionary objectForKey:@"authentication_token"];
    }
    return self;
}

- (NSDictionary *)dictionaryCopy
{
    return @{
             @"id":[NSNumber numberWithInteger:_userId],
             @"email":_email,
             @"authentication_token":_authenticationToken
             };
}

@end

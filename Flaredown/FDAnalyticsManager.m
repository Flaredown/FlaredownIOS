//
//  FDAnalyticsManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/4/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDAnalyticsManager.h"

#import "intercom.h"

@implementation FDAnalyticsManager

//static NSString * const IntercomApiKey = @"ios_sdk-36f0ede761e4dccbd07a6f360e808a82f84f7beb";
static NSString * const IntercomApiKey = @"ios_sdk-9e7c43d636d4adaf0978718981dd0e22bc2bf525";
//static NSString * const IntercomAppId = @"zi05kys7";
static NSString * const IntercomAppId = @"ik6olicy";

+ (id)sharedManager
{
    static FDAnalyticsManager *sharedAnalyticsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnalyticsManager = [[self alloc] init];
        [Intercom setApiKey:IntercomApiKey forAppId:IntercomAppId];
    });
    return sharedAnalyticsManager;
}

- (void)registerUser:(FDUser *)user
{
    [Intercom registerUserWithEmail:[user email]];
    [self updateUser:user];
}

- (void)updateUser:(FDUser *)user
{
    [Intercom updateUserWithAttributes:@{
                                         @"email":[user email],
                                         @"user_hash":@([user userId]),
                                         @"user_country":[user location],
                                         @"sex":[user sexString],
                                         @"born_at":@([[user birthdayDate] timeIntervalSince1970]),
                                         @"onboarded":@([user onboarded]),
                                         @"created_at":@([[user createdAt] timeIntervalSince1970]),
                                         @"app_id":IntercomAppId
                                         }];
}

- (void)clearUser
{
    [Intercom reset];
}

@end

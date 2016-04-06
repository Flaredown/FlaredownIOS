//
//  FDAnalyticsManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/4/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDAnalyticsManager.h"

#import <Intercom/Intercom.h>
#import "KeenClient.h"

@implementation FDAnalyticsManager

//Production
//static NSString * const IntercomApiKey = @"ios_sdk-36f0ede761e4dccbd07a6f360e808a82f84f7beb";
//static NSString * const IntercomAppId = @"zi05kys7";

//Staging
static NSString * const IntercomApiKey = @"ios_sdk-9e7c43d636d4adaf0978718981dd0e22bc2bf525";
static NSString * const IntercomAppId = @"ik6olicy";

//Production
//static NSString * const KeenProjectId = @"55328229672e6c290c2be9cd";
//static NSString * const KeenWriteKey = @"2cebdf5d1c5aa2d18fd11763ca8639ee0e158d28b5644ec75a91e414a740b668d314f6ea163940c3631c4900ee3a759608cfaeeda9c7f3bb14cb2d58c3950bb60ff54473443d16488b3436b7b1dc5e5d39a712e1a8c9fbbdbf7c119eea79df16aebbd5e76a4c63348f56c7eac064b5aa";

//Stagings
static NSString * const KeenProjectId = @"55327e0646f9a75ef4402fc1";
static NSString * const KeenWriteKey = @"c6222280f213adef6860fff3e431e3d933ed3314e9c9a283133230418d2cd368f11f519bdceaa913ba75e097eb5f1d92435bba3c885ea2417a9179550053f590fac16c0fabc1f44bd1c19206dbce6ddc7ae890312c8e6248a25618286cd9d5966194f07d52e9880b11ee9f5b6ce91ad2";

+ (id)sharedManager
{
    static FDAnalyticsManager *sharedAnalyticsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnalyticsManager = [[self alloc] init];
    });
    return sharedAnalyticsManager;
}

- (void)initAnalytics
{
    [Intercom setApiKey:IntercomApiKey forAppId:IntercomAppId];
    [KeenClient sharedClientWithProjectID:KeenProjectId andWriteKey:KeenWriteKey andReadKey:nil];
}

- (void)registerUser:(FDUser *)user
{
    [Intercom registerUserWithEmail:[user email]];
    [self updateUser:user];
}

- (void)updateUser:(FDUser *)user
{
    //TODO: fix intercom
//    [Intercom updateUserWithAttributes:@{
//                                         @"email":[user email],
//                                         @"user_hash":@([user userId]),
//                                         @"user_country":[user location],
//                                         @"sex":[user sexString],
//                                         @"born_at":@([[user birthdayDate] timeIntervalSince1970]),
//                                         @"onboarded":@([user onboarded]),
//                                         @"created_at":@([[user createdAt] timeIntervalSince1970]),
//                                         @"app_id":IntercomAppId
//                                         }];
    
}

- (void)clearUser
{
    [Intercom reset];
}

- (void)trackPageView:(NSString *)page
{
    NSDictionary *event = @{
                            @"view_name":page,
                            @"action":@"view"
                            };
    [[KeenClient sharedClient] addEvent:event toEventCollection:@"tab_views" error:nil];
}

@end

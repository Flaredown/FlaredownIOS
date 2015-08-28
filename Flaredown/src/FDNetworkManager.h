//
//  FDNetworkManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 10/7/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface FDNetworkManager : NSObject

@property (strong, nonatomic) NSURL *baseUrl;

+ (id)sharedManager;
- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(bool success, id response))completionBlock;
//- (void)updateUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(bool success, id response))completionBlock;
- (void)updateUserWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken settings:(NSDictionary *)userSettings completion:(void (^)(bool success, id response))completionBlock;
//- (void)getEntryFromDate:(NSString *)date email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;
- (void)getEntryWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken date:(NSString *)date completion:(void (^)(bool success, id response))completionBlock;
- (void)createEntryWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken date:(NSString *)date completion:(void (^)(bool success, id response))completionBlock;
- (void)putEntry:(NSDictionary *)entry date:(NSString *)date email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;

- (void)createSymptomWithName:(NSString *)symptomName email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;
- (void)createTreatmentWithName:(NSString *)treatmentName email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;
- (void)createConditionWithName:(NSString *)conditionName email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;

- (void)searchTrackables:(NSString *)searchText type:(NSString *)type email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;

- (void)getPopularTagsWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock;

- (void)getLocale:(NSString *)locale email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool, id))completionBlock;

+ (BOOL)networkReachable;

@end

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

static NSString * const APIHost = @"http://192.168.0.3:4300/api";
//static NSString * const APIHost = @"https://app.flaredown.com/api";

@interface FDNetworkManager : NSObject

+ (id)sharedManager;

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(bool success, id response))completionBlock;

- (void)getUserForId:(NSInteger)userId completion:(void (^)(bool success, id response))completionBlock;
- (void)updateUser:(NSDictionary *)user forId:(NSInteger)userId completion:(void (^)(bool, id))completionBlock;
- (void)getProfileForId:(NSInteger)profileId completion:(void (^)(bool success, id response))completionBlock;
- (void)updateProfile:(NSDictionary *)profile forId:(NSInteger)profileId completion:(void (^)(bool success, id response))completionBlock;

- (void)getEntryForId:(NSString *)entryId completion:(void (^)(bool success, id response))completionBlock;
- (void)getEntryForDate:(NSString *)date completion:(void (^)(bool success, id response))completionBlock;
- (void)updateEntry:(NSDictionary *)entry forId:(NSString *)entryId completion:(void (^)(bool success, id response))completionBlock;

- (void)createSymptom:(NSDictionary *)symptom completion:(void (^)(bool, id))completionBlock;
- (void)createTreatment:(NSDictionary *)treatment completion:(void (^)(bool, id))completionBlock;
- (void)createCondition:(NSDictionary *)condition completion:(void (^)(bool, id))completionBlock;
- (void)createTag:(NSString *)tag completion:(void (^)(bool, id))completionBlock;

- (void)searchSymptoms:(NSString *)searchText completion:(void (^)(bool, id))completionBlock;
- (void)searchTreatments:(NSString *)searchText completion:(void (^)(bool, id))completionBlock;
- (void)searchConditions:(NSString *)searchText completion:(void (^)(bool, id))completionBlock;
- (void)searchTags:(NSString *)searchText completion:(void (^)(bool, id))completionBlock;
- (void)getPopularTags:(void (^)(bool success, id response))completionBlock;

+ (BOOL)networkReachable;

@end

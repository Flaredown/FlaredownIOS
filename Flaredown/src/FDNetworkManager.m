//
//  FDNetworkManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/7/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDNetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "FDHTTPClient.h"

#import "FDUser.h"

@implementation FDNetworkManager

+ (id)sharedManager
{
    static FDNetworkManager *sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworkManager = [[self alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedNetworkManager;
}

- (id)init
{
    self = [super init];
    if(self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        //TODO: load token from prefs
    }
    
    return self;
}

/*
 *  Logs in the user with email and password, returns auth token
 */
- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(bool success, id response))completionBlock
{
    [self postAPIRequestWithUrl:@"sessions" parameters:@{@"user[email]":email, @"user[password]":password} completionBlock:^(bool success, id responseObject) {
        if(success) {
            @try {
                FDUser *user = [[FDUser alloc] initWithDictionary:responseObject];
                [FDHTTPClient setupAuthorizationHeadersWithEmail:[user email] token:[user authenticationToken]];
                completionBlock(true, responseObject);
            }
            @catch(NSException *exception) {
                completionBlock(false, nil);
            }
            
        } else
            completionBlock(false, nil);
    }];
}

- (void)getUserForId:(NSInteger)userId completion:(void (^)(bool success, id response))completionBlock
{
    [self getAPIRequestWithUrl:[NSString stringWithFormat:@"users/%li", userId] parameters:@{} completionBlock:completionBlock];
}

- (void)updateUser:(NSDictionary *)user forId:(NSInteger)userId completion:(void (^)(bool, id))completionBlock
{
    [self postAPIRequestWithUrl:[NSString stringWithFormat:@"users/%li", userId] parameters:@{@"user":user} completionBlock:completionBlock];
}

- (void)getProfileForId:(NSInteger)profileId completion:(void (^)(bool success, id response))completionBlock
{
    [self getAPIRequestWithUrl:[NSString stringWithFormat:@"profiles/%li", profileId] parameters:@{} completionBlock:completionBlock];
}

- (void)updateProfile:(NSDictionary *)profile forId:(NSInteger)profileId completion:(void (^)(bool success, id response))completionBlock
{
    [self postAPIRequestWithUrl:[NSString stringWithFormat:@"profiles/%li", profileId] parameters:@{@"profile":profile} completionBlock:completionBlock];
}

- (void)getEntryForId:(NSString *)entryId completion:(void (^)(bool success, id response))completionBlock
{
    [self getAPIRequestWithUrl:[NSString stringWithFormat:@"checkins/%@", entryId] parameters:@{} completionBlock:completionBlock];
}

- (void)getEntryForDate:(NSString *)date completion:(void (^)(bool success, id response))completionBlock
{
    [self getAPIRequestWithUrl:@"checkins" parameters:@{@"date":date} completionBlock:completionBlock];
}

- (void)updateEntry:(NSDictionary *)entry forId:(NSString *)entryId completion:(void (^)(bool success, id response))completionBlock
{
    [self putAPIRequestWithUrl:[NSString stringWithFormat:@"checkins/%@", entryId] parameters:@{@"checkin":entry} completionBlock:completionBlock];
}

- (void)createSymptom:(NSDictionary *)symptom completion:(void (^)(bool, id))completionBlock
{
    [self postAPIRequestWithUrl:@"symptoms" parameters:@{@"symptom":symptom} completionBlock:completionBlock];
}

- (void)createTreatment:(NSDictionary *)treatment completion:(void (^)(bool, id))completionBlock
{
    [self postAPIRequestWithUrl:@"treatments" parameters:@{@"treatment":treatment} completionBlock:completionBlock];
}

- (void)createCondition:(NSDictionary *)condition completion:(void (^)(bool, id))completionBlock
{
    [self postAPIRequestWithUrl:@"conditions" parameters:@{@"condition":condition} completionBlock:completionBlock];
}

- (void)createTag:(NSString *)tag completion:(void (^)(bool, id))completionBlock
{
    [self postAPIRequestWithUrl:@"tag" parameters:@{@"tag":tag} completionBlock:completionBlock];
}

- (void)searchSymptoms:(NSString *)searchText completion:(void (^)(bool, id))completionBlock
{
    [self getAPIRequestWithUrl:@"symptoms" parameters:@{@"scope":searchText} completionBlock:completionBlock];
}

- (void)searchTreatments:(NSString *)searchText completion:(void (^)(bool, id))completionBlock
{
    [self getAPIRequestWithUrl:@"treatments" parameters:@{@"scope":searchText} completionBlock:completionBlock];
}

- (void)searchConditions:(NSString *)searchText completion:(void (^)(bool, id))completionBlock
{
    [self getAPIRequestWithUrl:@"conditions" parameters:@{@"scope":searchText} completionBlock:completionBlock];
}

- (void)searchTags:(NSString *)searchText completion:(void (^)(bool, id))completionBlock
{
    [self getAPIRequestWithUrl:@"tags" parameters:@{@"scope":searchText} completionBlock:completionBlock];
}


- (void)getPopularTags:(void (^)(bool success, id response))completionBlock
{
    [self getAPIRequestWithUrl:@"tags/most_popular" parameters:@{} completionBlock:completionBlock];
}

//TODO: Figure out localization
//- (void)getLocale:(NSString *)locale email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool, id))completionBlock
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSString *url = [NSString stringWithFormat:@"%@/locales/%@", self.baseUrl, locale];
//    
//    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken};
//    
//    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        completionBlock(true, responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        completionBlock(false, nil);
//    }];
//}

- (void)getAPIRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id responseObject))completionBlock
{
    [FDHTTPClient getRequestWithUrl:[NSString stringWithFormat:@"%@/%@", APIHost, url] parameters:parameters completionBlock:completionBlock];
}

- (void)postAPIRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id responseObject))completionBlock
{
    [FDHTTPClient postRequestWithUrl:[NSString stringWithFormat:@"%@/%@", APIHost, url] parameters:parameters completionBlock:completionBlock];
}

- (void)putAPIRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id responseObject))completionBlock
{
    [FDHTTPClient putRequestWithUrl:[NSString stringWithFormat:@"%@/%@", APIHost, url] parameters:parameters completionBlock:completionBlock];
}

+ (BOOL)networkReachable
{
    //TODO: FDLocalizedString
    if([AFNetworkReachabilityManager sharedManager].reachable)
        return YES;
    NSLog(@"No network connection");
    [[[UIAlertView alloc] initWithTitle:@"Network Connection Unavailable"
                                message:@"This app requires an active network connection. Please connect to a network and try again."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    return NO;
}

@end
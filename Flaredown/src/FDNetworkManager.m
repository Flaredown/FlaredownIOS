//
//  FDNetworkManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/7/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDNetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *host = @"https://api-staging.flaredown.com";
static NSString *api = @"/v1";

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
    if(self = [super init]) {
        self.baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", host, api]];
    }
    return self;
}

/*
 *  Logs in the user with email and password, returns auth token
 */
- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/users/sign_in", self.baseUrl];
    NSDictionary *parameters = @{@"v1_user[email]":email, @"v1_user[password]":password};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
}

- (void)updateUserWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/users/update", self.baseUrl];
//    NSDictionary *parameters = @{@"v1_user[email]":email, @"v1_user[password]":password};
    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
}

- (void)getEntryWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken date:(NSString *)date completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/entries/%@", self.baseUrl, date];
    
    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
}

- (void)createEntryWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken date:(NSString *)date completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/entries", self.baseUrl];
    
    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken, @"date":date};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
}

//- (void)getEntryFromDate:(NSString *)date email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSString *url = [NSString stringWithFormat:@"%@/entries/%@", self.baseUrl, date];
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

- (void)putEntry:(NSDictionary *)entry date:(NSString *)date email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/entries/%@", self.baseUrl, date];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:entry options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"entry":jsonString, @"user_email":email, @"user_token":authenticationToken};
    
    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];

}

- (void)createSymptomWithName:(NSString *)symptomName email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool, id))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/symptoms", self.baseUrl];
    
    NSDictionary *parameters = @{@"name":symptomName, @"user_email":email, @"user_token":authenticationToken};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];

}

- (void)createTreatmentWithName:(NSString *)treatmentName email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool, id))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/treatments", self.baseUrl];
    
    NSDictionary *parameters = @{@"name":treatmentName, @"user_email":email, @"user_token":authenticationToken};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
    
}

- (void)createConditionWithName:(NSString *)conditionName email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool, id))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/conditions", self.baseUrl];
    
    NSDictionary *parameters = @{@"name":conditionName, @"user_email":email, @"user_token":authenticationToken};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
    
}

- (void)searchTrackables:(NSString *)searchText type:(NSString *)type email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url;
    if([type isEqualToString:@"symptoms"]) {
        url = [NSString stringWithFormat:@"%@/symptoms/search/%@", self.baseUrl, [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else if([type isEqualToString:@"treatments"]) {
        url = [NSString stringWithFormat:@"%@/treatments/search/%@", self.baseUrl, [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else if([type isEqualToString:@"conditions"]) {
        url = [NSString stringWithFormat:@"%@/conditions/search/%@", self.baseUrl, [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else if([type isEqualToString:@"tags"]) {
        url = [NSString stringWithFormat:@"%@/tags/search/%@", self.baseUrl, [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        NSLog(@"Invalid search type in searchTrackables method of FDNetworkManager");
        completionBlock(false, nil);
    }
    
    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
    
}

- (void)getPopularTagsWithEmail:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool success, id response))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url;
    url = [NSString stringWithFormat:@"%@/tags/popular", self.baseUrl];
    
    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];

}

- (void)getLocale:(NSString *)locale email:(NSString *)email authenticationToken:(NSString *)authenticationToken completion:(void (^)(bool, id))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/locales/%@", self.baseUrl, locale];
    
    NSDictionary *parameters = @{@"user_email":email, @"user_token":authenticationToken};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(false, nil);
    }];
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
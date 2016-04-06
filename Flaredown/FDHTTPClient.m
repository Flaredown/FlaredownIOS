//
//  FDHTTPClient.m
//  Flaredown
//
//  Created by Cole Cunningham on 4/6/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import "FDHTTPClient.h"

#import <AFNetworking/AFNetworking.h>

#import "FDHTTPSessionManager.h"

@implementation FDHTTPClient

+ (void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id response))completionBlock
{
    FDHTTPSessionManager *manager = [FDHTTPSessionManager manager];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"HTTP GET success: %@", url);
        NSLog(@"parameters: %@", parameters);
        NSLog(@"response: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"HTTP GET failure: %@", url);
        NSLog(@"parameters: %@", parameters);
        NSLog(@"failure: %@", error);
        completionBlock(false, nil);
    }];
}

+ (void)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id response))completionBlock
{
    FDHTTPSessionManager *manager = [FDHTTPSessionManager manager];
    
    UIBackgroundTaskIdentifier taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {
        NSLog(@"Background post (%@) request timed out.", url);
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
    }];
    [manager POST:url parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"");
        NSLog(@"HTTP POST success: %@", url);
        NSLog(@"parameters: %@", parameters);
        NSLog(@"response: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"");
        NSLog(@"HTTP POST failure: %@", url);
        NSLog(@"parameters: %@", parameters);
        NSLog(@"failure: %@", error);
        completionBlock(false, nil);
    }];
    if (taskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
    }
}

+ (void)putRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id response))completionBlock
{
    FDHTTPSessionManager *manager = [FDHTTPSessionManager manager];
    
    [manager PUT:url parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"");
        NSLog(@"HTTP PUT success: %@", url);
        NSLog(@"parameters: %@", parameters);
        NSLog(@"response: %@", responseObject);
        completionBlock(true, responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"");
        NSLog(@"HTTP PUT failure: %@", url);
        NSLog(@"parameters: %@", parameters);
        NSLog(@"failure: %@", error);
        completionBlock(false, nil);
    }];
}

+ (void)setupAuthorizationHeadersWithEmail:(NSString *)email token:(NSString *)token
{
    FDHTTPSessionManager *manager = [FDHTTPSessionManager manager];
    [manager setEmail:email];
    [manager setToken:token];
}

+ (void)removeAuthorizationHeaders
{
    FDHTTPSessionManager *manager = [FDHTTPSessionManager manager];
    [manager setEmail:nil];
    [manager setToken:nil];
}

@end

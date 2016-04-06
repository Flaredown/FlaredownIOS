//
//  FDHTTPSessionManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 4/6/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import "FDHTTPSessionManager.h"

@implementation FDHTTPSessionManager

+ (id)manager
{
    static FDHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
    static NSString *deviceId;
    if(!deviceId)
    {
        deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    NSMutableURLRequest *req = (NSMutableURLRequest *)request;
    // Give each request a unique ID for tracing
    
    [req setValue:[NSString stringWithFormat:@"Token token=\"%@\", email=\"%@\"", _token?:@"", _email?:@""] forHTTPHeaderField:@"Authorization"];
    return [super dataTaskWithRequest:req completionHandler:completionHandler];
}

@end

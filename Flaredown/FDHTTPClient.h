//
//  FDHTTPClient.h
//  Flaredown
//
//  Created by Cole Cunningham on 4/6/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDHTTPClient : NSObject

+ (void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id response))completionBlock;
+ (void)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id response))completionBlock;
+ (void)putRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(bool success, id response))completionBlock;

+ (void)setupAuthorizationHeadersWithEmail:(NSString *)email token:(NSString *)token;
+ (void)removeAuthorizationHeaders;

@end

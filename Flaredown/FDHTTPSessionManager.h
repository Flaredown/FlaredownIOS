//
//  FDHTTPSessionManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 4/6/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface FDHTTPSessionManager : AFHTTPSessionManager

@property FDHTTPSessionManager *manager;

@property NSString *email;
@property NSString *token;

@end

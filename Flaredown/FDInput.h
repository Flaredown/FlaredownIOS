//
//  FDInput.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDInput : NSObject

@property NSString *helper;
@property int inputId;
@property NSString *label;
@property NSString *metaLabel;
@property int value;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryCopy;

@end

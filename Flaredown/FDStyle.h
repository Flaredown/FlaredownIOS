//
//  FDStyle.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/20/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static float const FDCornerRadius = 11;

@interface FDStyle : NSObject

+ (void)addRoundedCornersToView:(UIView *)view;
+ (void)addShadowToView:(UIView *)view;

@end

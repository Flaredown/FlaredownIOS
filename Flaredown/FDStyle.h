//
//  FDStyle.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/20/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static float const FDSmallCornerRadius = 7;
static float const FDCornerRadius = 11;
static float const FDLargeCornerRadius = 22;
static float const FDBorderWidth = 1;

@interface FDStyle : NSObject

+ (void)addRoundedCornersToView:(UIView *)view;
+ (void)addSmallRoundedCornersToView:(UIView *)view;
+ (void)addLargeRoundedCornersToView:(UIView *)view;
+ (void)addShadowToView:(UIView *)view;
+ (void)addBorderToView:(UIView *)view withColor:(UIColor *)color;

+ (UIColor *)indianKhakiColor;
+ (UIColor *)greyColor;
+ (UIColor *)blueColor;
+ (UIColor *)lightGreyColor;
+ (UIColor *)whiteColor;
+ (UIColor *)purpleColor;
+ (UIColor *)mediumGreyColor;
+ (UIColor *)blackColor;

+ (NSString *)trimmedDecimal:(float)number;
+ (NSString *)dateStringForDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)date;

@end

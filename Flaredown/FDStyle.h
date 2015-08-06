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

#define ROUNDED_CORNER_OFFSET 20
#define TAG_HEIGHT 32
#define TAG_FONT [UIFont fontWithName:@"ProximaNova-Regular" size:19.0f]

#define DOSE_FONT_SIZE 15
#define DOSE_BUTTON_PADDING 25

@interface FDStyle : NSObject

+ (void)addRoundedCornersToView:(UIView *)view;
+ (void)addSmallRoundedCornersToView:(UIView *)view;
+ (void)addLargeRoundedCornersToView:(UIView *)view;
+ (void)addShadowToView:(UIView *)view;
+ (void)addBorderToView:(UIView *)view withColor:(UIColor *)color;

+ (void)addRoundedCornersToTopOfView:(UIView *)view;
+ (void)addRoundedCornersToBottomOfView:(UIView *)view;

+ (UIColor *)indianKhakiColor;
+ (UIColor *)greyColor;
+ (UIColor *)blueColor;
+ (UIColor *)lightGreyColor;
+ (UIColor *)whiteColor;
+ (UIColor *)purpleColor;
+ (UIColor *)mediumGreyColor;
+ (UIColor *)blackColor;
+ (UIColor *)redColor;

+ (NSString *)trimmedDecimal:(float)number;
+ (NSString *)dateStringForDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)date;

@end

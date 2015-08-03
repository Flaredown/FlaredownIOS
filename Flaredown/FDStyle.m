//
//  FDStyle.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/20/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDStyle.h"

@implementation FDStyle

+ (void)addRoundedCornersToView:(UIView *)view
{
//    view.layer.cornerRadius = FDCornerRadius;
    [self roundCornersWithRadius:FDCornerRadius topLeft:YES topRight:YES bottomLeft:YES bottomRight:YES forView:view];
}

+ (void)addSmallRoundedCornersToView:(UIView *)view
{
    view.layer.cornerRadius = FDSmallCornerRadius;
}

+ (void)addLargeRoundedCornersToView:(UIView *)view
{
    view.layer.cornerRadius = FDLargeCornerRadius;
}

+ (void)addShadowToView:(UIView *)view
{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.1;
    view.layer.shadowRadius = 0;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

+ (void)addBorderToView:(UIView *)view withColor:(UIColor *)color
{
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = FDBorderWidth;
}

+ (void)addRoundedCornersToTopOfView:(UIView *)view
{
    [self roundCornersWithRadius:FDCornerRadius topLeft:YES topRight:YES bottomLeft:NO bottomRight:NO forView:view];
}

+ (void)addRoundedCornersToBottomOfView:(UIView *)view
{
    [self roundCornersWithRadius:FDCornerRadius topLeft:NO topRight:NO bottomLeft:YES bottomRight:YES forView:view];
}

+ (void)roundCornersWithRadius:(float)radius topLeft:(BOOL)topLeft topRight:(BOOL)topRight bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight forView:(UIView *)view
{
    UIRectCorner corner = 0;
    corner = topLeft ? corner | UIRectCornerTopLeft : corner;
    corner = topRight ? corner | UIRectCornerTopRight : corner;
    corner = bottomLeft ? corner | UIRectCornerBottomLeft : corner;
    corner = bottomRight ? corner | UIRectCornerBottomRight : corner;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (UIColor *)indianKhakiColor
{
    return [UIColor colorWithRed:195.0/255.0 green:179.0/255.0 blue:153.0/255.0 alpha:1.0];
}

+ (UIColor *)greyColor
{
    return [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
}

+ (UIColor *)blueColor
{
    return [UIColor colorWithRed:115.0/255.0 green:193.0/255.0 blue:186.0/255.0 alpha:1.0];
}

+ (UIColor *)lightGreyColor
{
    return [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
}

+ (UIColor *)whiteColor
{
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)purpleColor
{
    return [UIColor colorWithRed:176.0/255.0 green:129.0/255.0 blue:217.0/255.0 alpha:1.0];
}

+ (UIColor *)mediumGreyColor
{
    return [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
}

+ (UIColor *)blackColor
{
    return [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
}

+ (NSString *)trimmedDecimal:(float)number
{
    int maximumFractionDigits = 2;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:maximumFractionDigits];
    
    NSString *decimalString = [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
    return decimalString;
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM-dd-yyyy"];
    return formatter;
}

+ (NSString *)dateStringForDate:(NSDate *)date
{
    return [[self dateFormatter] stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)date
{
    return [[self dateFormatter] dateFromString:date];
}

@end

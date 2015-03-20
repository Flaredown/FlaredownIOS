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
    view.layer.cornerRadius = FDCornerRadius;
}

+ (void)addCellRoundedCornersToView:(UIView *)view
{
    view.layer.cornerRadius = FDCellCornerRadius;
}

+ (void)addShadowToView:(UIView *)view
{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.1;
    view.layer.shadowRadius = 0;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

@end

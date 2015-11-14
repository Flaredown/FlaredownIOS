//
//  FDSummaryCardView.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/22/15.
//  Copyright © 2015 Flaredown. All rights reserved.
//

#import "FDSummaryCardView.h"

#import "FDStyle.h"

@implementation FDSummaryCardView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.backgroundColor = [FDStyle whiteColor];
    [FDStyle addRoundedCornersToView:self];
    [FDStyle addShadowToView:self];
}

@end

//
//  FDSummaryCardView.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/22/15.
//  Copyright © 2015 Flaredown. All rights reserved.
//

#import "FDSummaryCardView.h"

#import "FDStyle.h"

#import "FDSummaryCardViewLayoutAttributes.h"

@implementation FDSummaryCardView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.backgroundColor = [FDStyle whiteColor];
    
    FDSummaryCardViewLayoutAttributes *attributes = (FDSummaryCardViewLayoutAttributes *)layoutAttributes;
    
    if(attributes.roundTop) {
        [FDStyle addRoundedCornersToTopOfView:self];
    }
    if(attributes.roundBottom) {
        [FDStyle addRoundedCornersToBottomOfView:self];
        [FDStyle addShadowToView:self];
    }
}

@end

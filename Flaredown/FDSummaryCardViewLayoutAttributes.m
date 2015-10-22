//
//  FDSummaryCardViewLayoutAttributes.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/22/15.
//  Copyright © 2015 Flaredown. All rights reserved.
//

#import "FDSummaryCardViewLayoutAttributes.h"

@implementation FDSummaryCardViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    FDSummaryCardViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.roundTop = self.roundTop;
    newAttributes.roundBottom = self.roundBottom;
    
    return newAttributes;
}

@end

//
//  FDSummaryCollectionViewLayout.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/21/15.
//  Copyright © 2015 Flaredown. All rights reserved.
//

#import "FDSummaryCollectionViewLayout.h"

#import "FDStyle.h"

#import "FDSummaryCollectionViewController.h"
#import "FDSummaryCardViewLayoutAttributes.h"

#define CARD_BACKGROUND @"CardBackground"

@implementation FDSummaryCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemAttributes = [NSMutableArray new];
    
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    for (int section = 0; section < numberOfSection; section++) {
        if([_summaryCollectionViewDelegate sectionIsCardEnd:section])
            continue;
        
        NSString *decorationViewOfKind = CARD_BACKGROUND;
        if ([decorationViewOfKind isKindOfClass:[NSNull class]])
            continue;
        
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        if (lastIndex < 0)
            continue;
        
        UICollectionViewLayoutAttributes *firstItem = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        
        NSInteger numberOfRow = [self.collectionView numberOfItemsInSection:section];
        for(int row = 0; row < numberOfRow; row++) {
            FDSummaryCardViewLayoutAttributes *attributes = [FDSummaryCardViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewOfKind withIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            
            if([_summaryCollectionViewDelegate sectionIsCardTop:section])
                attributes.roundTop = YES;
            if([_summaryCollectionViewDelegate sectionIsCardBottom:section])
                attributes.roundBottom = YES;
            
            attributes.zIndex = -1;
            [attributes setFrame:frame];
            [self.itemAttributes addObject:attributes];
            [self registerNib:[UINib nibWithNibName:decorationViewOfKind bundle:[NSBundle mainBundle]] forDecorationViewOfKind:decorationViewOfKind];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
    {
        if (!CGRectIntersectsRect(rect, attribute.frame))
            continue;
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}

@end

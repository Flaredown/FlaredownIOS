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
    for (int section = 0; section < numberOfSection; section++)
    {
        if([_summaryCollectionViewDelegate sectionIsCardEnd:section])
            continue;
        
        NSString *decorationViewOfKind = CARD_BACKGROUND;
        if ([decorationViewOfKind isKindOfClass:[NSNull class]])
            continue;
        
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        if (lastIndex < 0)
            continue;
        
        FDSummaryCardViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        [firstItem setRoundTop:YES];
        FDSummaryCardViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:lastIndex inSection:section]];
        [lastItem setRoundBottom:YES];
        
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
//        frame.origin.x -= self.sectionInset.left;
//        frame.origin.y -= self.sectionInset.top;
        
//        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
//        {
//            frame.size.width += self.sectionInset.left + self.sectionInset.right;
////            frame.size.height = self.collectionView.frame.size.height;
//        }
//        else
//        {
////            frame.size.width = self.collectionView.frame.size.width;
//            frame.size.height += self.sectionInset.top + self.sectionInset.bottom;
//        }

        UICollectionViewLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForDecorationViewOfKind:decorationViewOfKind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];

        attributes.zIndex = -1;
        attributes.frame = frame;
        [self.itemAttributes addObject:attributes];
        [self registerNib:[UINib nibWithNibName:decorationViewOfKind bundle:[NSBundle mainBundle]] forDecorationViewOfKind:decorationViewOfKind];
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

- (FDSummaryCardViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FDSummaryCardViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
}

+ (Class)layoutAttributesClass
{
    return [FDSummaryCardViewLayoutAttributes class];
}

@end

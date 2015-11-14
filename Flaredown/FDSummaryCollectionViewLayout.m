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

#define CARD_BACKGROUND @"CardBackground"

@implementation FDSummaryCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemAttributes = [NSMutableArray new];
    
    
    NSArray *cardStartSections = [_summaryCollectionViewDelegate cardStartSections];
    NSArray *cardEndSections = [_summaryCollectionViewDelegate cardEndSections];
    
    
    for(int card = 0; card < cardStartSections.count; card++)
    {
        NSInteger cardStartSection = [cardStartSections[card] integerValue];
        NSInteger cardEndSection = [cardEndSections[card] integerValue];
        
        NSInteger lastRow = [self.collectionView numberOfItemsInSection:cardEndSection] - 1;
        
        UICollectionViewLayoutAttributes *firstItem = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cardStartSection]];
        UICollectionViewLayoutAttributes *lastItem = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:cardEndSection]];
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        
        NSString *decorationViewOfKind = CARD_BACKGROUND;
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewOfKind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:cardStartSection]];
        
        attributes.zIndex = -1;
        [attributes setFrame:frame];
        [self.itemAttributes addObject:attributes];
        [self registerNib:[UINib nibWithNibName:decorationViewOfKind bundle:[NSBundle mainBundle]] forDecorationViewOfKind:decorationViewOfKind];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    for(UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
    {
        if(CGRectIntersectsRect(rect, attribute.frame))
            [attributes addObject:attribute];
    }
    
    return attributes;
}

@end

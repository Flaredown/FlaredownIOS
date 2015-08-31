//
//  FDTreatmentsCollectionViewLayout.m
//  Flaredown
//
//  Created by Cole Cunningham on 8/31/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTreatmentCollectionViewLayout.h"

@implementation FDTreatmentCollectionViewLayout

static NSString * const PreviousDoseDecorationID = @"previousDoseDecoration";

//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//{
////    UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
////    UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
////    
////    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
////    layoutAttributes.frame = CGRectMake(headerAttributes.frame.origin.x, headerAttributes.frame.origin.y, footerAttributes.frame.origin.x, footerAttributes.frame.origin.y);
////    layoutAttributes.zIndex = -1;
////    return layoutAttributes;
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *allAttributes = [[NSMutableArray alloc] initWithCapacity:4];
//    
//    [allAttributes addObject:[self layoutAttributesForDecorationViewOfKind:PreviousDoseDecorationID atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
//    
//    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
//    {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [allAttributes addObject:layoutAttributes];
//    }
//    return allAttributes;
//}

@end

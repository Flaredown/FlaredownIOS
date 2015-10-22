//
//  FDTreatmentsCollectionViewLayout.m
//  Flaredown
//
//  Created by Cole Cunningham on 8/31/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTreatmentCollectionViewLayout.h"

#import "FDModelManager.h"

@implementation FDTreatmentCollectionViewLayout

static NSString * const PreviousDoseDecorationID = @"PreviousDoseBackground";

- (void)refresh
{
    for(UIView *view in self.collectionView.subviews) {
        if([view isKindOfClass:[UICollectionReusableView class]]) {
            [view removeFromSuperview];
        }
    }
    [super prepareLayout];
}

//- (void)prepareLayout
//{
//    [super prepareLayout];
//    self.itemAttributes = [NSMutableArray new];
//    
//    NSInteger numberOfSection = self.collectionView.numberOfSections;
//    for (int section = 0; section < numberOfSection; section++)
//    {
//        FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
//        NSArray *previousDoses = [[[[FDModelManager sharedManager] userObject] previousDoses] objectForKey:[treatment name]];
//        if([previousDoses count] == 0 || [[treatment doses] count] > 0)
//            continue;
//        
//        NSString *decorationViewOfKind = PreviousDoseDecorationID;
//        if ([decorationViewOfKind isKindOfClass:[NSNull class]])
//            continue;
//        
//        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1 - 1;
//        if (lastIndex < 0)
//            continue;
//        
//        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
//        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
//        
//        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
//        frame.origin.x -= self.sectionInset.left + 10;
//        //        frame.origin.y -= self.sectionInset.top;
//        
//        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
//        {
//            //            frame.size.width += self.sectionInset.left + self.sectionInset.right;
//            frame.size.height = self.collectionView.frame.size.height;
//        }
//        else
//        {
//            frame.size.width = self.collectionView.frame.size.width + 20;
//            //            frame.size.height += self.sectionInset.top + self.sectionInset.bottom;
//        }
//        
//        
//        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewOfKind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
//        
//        attributes.zIndex = -1;
//        attributes.frame = frame;
//        [self.itemAttributes addObject:attributes];
//        [self registerNib:[UINib nibWithNibName:decorationViewOfKind bundle:[NSBundle mainBundle]] forDecorationViewOfKind:decorationViewOfKind];
//    }
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
//    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
//    {
//        if (!CGRectIntersectsRect(rect, attribute.frame))
//            continue;
//        
//        [attributes addObject:attribute];
//    }
//    
//    return attributes;
//}

@end

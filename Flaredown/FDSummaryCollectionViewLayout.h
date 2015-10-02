//
//  FDSummaryCollectionViewLayout.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/21/15.
//  Copyright © 2015 Flaredown. All rights reserved.
//

#import <UICollectionViewLeftAlignedLayout/UICollectionViewLeftAlignedLayout.h>

@interface FDSummaryCollectionViewLayout : UICollectionViewLeftAlignedLayout

@property NSArray *indexPaths;
@property (strong, nonatomic) NSMutableArray *itemAttributes;

@end

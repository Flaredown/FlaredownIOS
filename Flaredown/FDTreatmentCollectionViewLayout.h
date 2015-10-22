//
//  FDTreatmentsCollectionViewLayout.h
//  Flaredown
//
//  Created by Cole Cunningham on 8/31/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "UICollectionViewLeftAlignedLayout.h"

@interface FDTreatmentCollectionViewLayout : UICollectionViewLeftAlignedLayout

@property NSArray *indexPaths;
@property (strong, nonatomic) NSMutableArray *itemAttributes;

- (void)refresh;

@end

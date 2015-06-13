//
//  FDTagsCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 5/12/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDTagsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property NSMutableArray *tags;
@property NSMutableArray *popularTags;

@end

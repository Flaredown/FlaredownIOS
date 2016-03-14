//
//  FDTagsCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 5/12/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDViewController.h"
#import "FDPageContentViewController.h"

@interface FDTagsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;
@property (nonatomic, weak) id <FDPageContentViewControllerDelegate> contentViewDelegate;

@property NSMutableArray *tags;
@property NSMutableArray *popularTags;

@end

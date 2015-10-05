//
//  FDSummaryCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 5/12/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDModelManager.h"
#import "FDViewController.h"

@interface FDSummaryCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;

@property FDEntry *entry;

@property BOOL failedToSubmit;

- (void)refresh;
- (BOOL)cardBackgroundForSection:(NSInteger)section;

@end

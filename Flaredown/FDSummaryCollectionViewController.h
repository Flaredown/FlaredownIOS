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

@protocol FDSummaryCollectionViewControllerDelegate <NSObject>

- (BOOL)sectionIsCardEnd:(NSInteger)section;
- (BOOL)sectionIsCardTop:(NSInteger)section;
- (BOOL)sectionIsCardBottom:(NSInteger)section;

- (NSArray *)cardStartSections;
- (NSArray *)cardEndSections;

@end

@interface FDSummaryCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, FDSummaryCollectionViewControllerDelegate>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;
@property FDEntry *entry;
@property BOOL failedToSubmit;
@property BOOL preloaded;
@property NSTimer *submitTimer;

- (void)refresh;
- (BOOL)cardBackgroundForSection:(NSInteger)section;

@end

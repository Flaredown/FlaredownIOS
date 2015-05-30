//
//  FDViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDSummaryCollectionViewController;

@protocol FDViewControllerDelegate <NSObject>

- (void)refreshPages;
- (id)instance;
- (void)openSearch:(NSString *)type;
- (void)adjustPageIndexForRemovedItem:(int)firstIndex;
- (void)toggleCardBumped;
- (void)openPage:(int)pageIndex;

@end

@interface FDViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, FDViewControllerDelegate>

@property BOOL loadSummary;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) FDSummaryCollectionViewController *summaryViewController;
@property int numPages;
@property int pageIndex;

@property NSString *searchType;

@property BOOL cardBumped;

//- (void)showPages;
//- (void)showSummary;

@end


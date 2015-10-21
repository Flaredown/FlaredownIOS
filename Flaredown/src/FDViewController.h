//
//  FDViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDLaunchViewController;
@class FDSummaryCollectionViewController;

@protocol FDViewControllerDelegate <NSObject>

- (void)launch;
- (void)refreshPages;
- (void)refreshSummary;
- (id)instance;
- (void)openSearch:(NSString *)type;
- (void)adjustPageIndexForRemovedItem:(int)firstIndex;
- (void)toggleCardBumped;
- (void)openPage:(int)pageIndex;
- (void)nextQuestion;
- (void)loadEntry;

@end

@interface FDViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, FDViewControllerDelegate>

@property BOOL loadSummary;
@property BOOL loginNeeded;

@property BOOL entryLoaded;
@property BOOL segueReady;
@property BOOL entryPreloaded;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) FDSummaryCollectionViewController *summaryViewController;
@property (strong, nonatomic) FDLaunchViewController *launchViewController;
@property (strong, nonatomic) UIViewController *activeViewController;
@property int numPages;
@property int pageIndex;

@property NSString *searchType;

@property BOOL cardBumped;

//- (void)showPages;
//- (void)showSummary;

@end


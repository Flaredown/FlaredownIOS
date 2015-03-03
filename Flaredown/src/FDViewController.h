//
//  FDViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDViewControllerDelegate <NSObject>

- (void)refreshPages;
- (id)instance;
- (void)openSearch;

@end

@interface FDViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, FDViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property int numPages;
@property int pageIndex;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


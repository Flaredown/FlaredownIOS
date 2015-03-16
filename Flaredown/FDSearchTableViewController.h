//
//  FDSearchTableViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 2/16/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPageContentViewController.h"

#define SEARCH_DELAY 0.5

@interface FDSearchTableViewController : UITableViewController <UITextFieldDelegate, FDPageContentViewControllerDelegate>

@property (nonatomic, strong) id <FDPageContentViewControllerDelegate> contentViewDelegate;

@property enum SearchType
{
    SearchSymptoms,
    SearchTreatments,
};
@property enum SearchType searchType;

@property NSMutableArray *results;
@property NSString *searchText;
@property NSTimer *timer;

@end
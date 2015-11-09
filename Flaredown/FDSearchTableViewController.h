//
//  FDSearchTableViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 2/16/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPageContentViewController.h"
#import "FDSettingsCollectionViewController.h"

#define SEARCH_DELAY 0.5

@interface FDSearchTableViewController : UITableViewController <UITextFieldDelegate, FDPageContentViewControllerDelegate>

@property (nonatomic, strong) id <FDViewControllerDelegate> mainViewDelegate;
@property (nonatomic, strong) id <FDPageContentViewControllerDelegate> contentViewDelegate;
@property (nonatomic, strong) id <FDSettingsViewControllerDelegate> settingsViewDelegate;

@property enum SearchType
{
    SearchSymptoms,
    SearchTreatments,
    SearchConditions,
    SearchTags,
    SearchCountries
};
@property enum SearchType searchType;

@property BOOL editing;

@property NSMutableArray *results;
@property NSString *searchText;
@property NSTimer *timer;

@end

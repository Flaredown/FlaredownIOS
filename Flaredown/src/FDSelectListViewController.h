//
//  FDSelectListViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDViewControllerDelegate <NSObject>

- (void)refreshPages;

@end

@interface FDSelectListViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;

@property NSMutableArray *questions;
@property NSArray *masterSymptoms;
@property NSArray *masterTreatments;
@property NSMutableArray *responses;
@property NSMutableArray *selectedItems;
@property BOOL dynamic;
@property BOOL editSymptoms;
@property BOOL treatments;
@property int removeIndex;

- (void)initWithQuestions:(NSArray *)questions;
- (void)initWithTreatments;
- (void)initWithSymptoms;

@end

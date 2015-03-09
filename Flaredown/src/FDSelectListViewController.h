//
//  FDSelectListViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPageContentViewController.h"
@class FDTreatment;

@interface FDSelectListViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;
@property (nonatomic, weak) id <FDPageContentViewControllerDelegate> contentViewDelegate;

@property NSMutableArray *questions;
@property NSArray *masterSymptoms;
@property NSArray *masterTreatments;
@property NSMutableArray *responses;
@property NSMutableArray *selectedItems;
@property BOOL dynamic;
@property BOOL editSymptoms;
@property BOOL treatments;
@property int removeIndex;

@property UIView *backgroundView;
@property UIView *popupView;

@property (weak, nonatomic) IBOutlet UITextField *addTreatmentNameField;
@property (weak, nonatomic) IBOutlet UITextField *addTreatmentDoseField;
@property (weak, nonatomic) IBOutlet UITextField *addTreatmentUnitField;
@property (weak, nonatomic) IBOutlet UILabel *editTreatmentTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *editTreatmentDoseField;
@property (weak, nonatomic) IBOutlet UITextField *editTreatmentUnitField;

@property FDTreatment *editTreatment;

- (void)initWithQuestions:(NSMutableArray *)questions;
- (void)initWithTreatments;
- (void)initWithSymptoms;

- (void)addTreatmentPopupWithTreatment:(FDTreatment *)treatment;

@end

//
//  FDTreatmentReminderTableViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 6/29/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDTreatment;

@interface FDTreatmentReminderTableViewController : UITableViewController

@property FDTreatment *treatment;

@property (weak, nonatomic) IBOutlet UIDatePicker *reminderTimePicker;
@property (weak, nonatomic) IBOutlet UIButton *reminderTimeCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderTimeDoneButton;

@end

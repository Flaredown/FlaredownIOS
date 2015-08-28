//
//  FDSettingsCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 7/30/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <M13Checkbox/M13Checkbox.h>
#import <HTAutocompleteTextField.h>

@interface FDSettingsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *popupDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *popupDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *popupCancelButton;
@property (weak, nonatomic) IBOutlet UILabel *popupTitleLabel;

@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *accountCountryTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountBirthDayTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountBirthMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountBirthYearTextField;
@property (weak, nonatomic) IBOutlet M13Checkbox *accountMaleCheckbox;
@property (weak, nonatomic) IBOutlet M13Checkbox *accountFemaleCheckbox;
@property (weak, nonatomic) IBOutlet M13Checkbox *accountOtherCheckbox;
@property (weak, nonatomic) IBOutlet M13Checkbox *accountUndisclosedCheckbox;

@property UIView *alarmView;
@property NSDate *reminderTime;

@property NSArray *treatments;

@end

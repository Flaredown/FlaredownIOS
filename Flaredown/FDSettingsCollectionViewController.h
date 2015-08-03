//
//  FDSettingsCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 7/30/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSettingsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIDatePicker *popupDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *popupDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *popupCancelButton;
@property (weak, nonatomic) IBOutlet UILabel *popupTitleLabel;

@property UIView *alarmView;
@property NSDate *reminderTime;

@property NSArray *treatments;

@end

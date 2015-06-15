//
//  FDSettingsViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 6/15/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;

@property (weak, nonatomic) IBOutlet UIView *reminderView;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *reminderTimeLabel;


@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *editAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *logoutAccountLabel;

@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;

@end

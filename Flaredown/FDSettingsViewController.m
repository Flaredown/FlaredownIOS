//
//  FDSettingsViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 6/15/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSettingsViewController.h"

#import "FDStyle.h"

#import "FDModelManager.h"
#import "FDPopupManager.h"
#import "FDLocalizationManager.h"

//relative to screen
#define ALARM_WIDTH 0.9
#define ALARM_HEIGHT 0.55

@interface FDSettingsViewController ()

@end

@implementation FDSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [FDStyle addRoundedCornersToView:_reminderView];
    [FDStyle addShadowToView:_reminderView];
    
    [FDStyle addRoundedCornersToView:_accountView];
    [FDStyle addShadowToView:_accountView];
    
    [_reminderSwitch setOn:[[FDModelManager sharedManager] reminder]];
    [self setupReminderLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reminderSwitchToggle:(id)sender
{
    [[FDModelManager sharedManager] setReminder:![[FDModelManager sharedManager] reminder]];
    [self setupReminderLabel];
}

- (IBAction)doneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupReminderLabel
{
    NSString *title;
//    if(![[FDModelManager sharedManager] reminder]) {
//        title = FDLocalizedString(@"alarm_off_caps");
//    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"hh:mm a"];
        title = [dateFormatter stringFromDate:[[FDModelManager sharedManager] reminderTime]];
//    }
    
    [_reminderTimeLabel setText:title];
    if([[FDModelManager sharedManager] reminder])
        [_reminderTimeLabel setAlpha:1.0f];
    else
        [_reminderTimeLabel setAlpha:0.4f];
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
//    [_reminderTimeLabel setAttributedText:attributedString];
}

- (IBAction)closeAlarmView:(UIButton *)sender
{
    [[FDModelManager sharedManager] setReminderTime:_reminderTime];
    if([[FDModelManager sharedManager] reminder]) {
        [self setNewNotification];
    } else
        //TODO: adjust this to handle multiple notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self setupReminderLabel];
    [self hideAlarmView];
}

- (IBAction)cancelAlarmView:(UIButton *)sender
{
    [self hideAlarmView];
}

- (void)hideAlarmView
{
    [[FDPopupManager sharedManager] removeTopPopup];
}

- (IBAction)alarmButton:(id)sender
{
    UIView *alarmView = [[[NSBundle mainBundle] loadNibNamed:@"AlarmView" owner:self options:nil] objectAtIndex:0];
    [alarmView setFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width*ALARM_WIDTH/2, self.view.frame.size.height/2-self.view.frame.size.height*ALARM_HEIGHT/2, self.view.frame.size.width*ALARM_WIDTH, self.view.frame.size.height*ALARM_HEIGHT)];
    
    [[FDPopupManager sharedManager] addPopupView:alarmView];
    
    //Style
    alarmView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:alarmView];
    
    _alarmView = alarmView;
    
    [_popupTitleLabel setText:FDLocalizedString(@"alarm_reminder_title")];
    
    [_popupDoneButton setTitle:FDLocalizedString(@"nav/done") forState:UIControlStateNormal];
    [_popupCancelButton setTitle:FDLocalizedString(@"nav/cancel") forState:UIControlStateNormal];
    
    //Reminder Time - 2
    UIDatePicker *datePicker = (UIDatePicker *)[alarmView viewWithTag:2];
    [datePicker setDate:[[FDModelManager sharedManager] reminderTime]];
    _reminderTime = [[FDModelManager sharedManager] reminderTime];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (IBAction)alarmDateChanged:(UIDatePicker *)sender
{
    _reminderTime = sender.date;
}

- (void)setNewNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = [[FDModelManager sharedManager] reminderTime];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitDay;
    
    localNotification.alertBody = FDLocalizedString(@"alarm_reminder_text");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

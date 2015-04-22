//
//  FDLaunchViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDLaunchViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "FDStyle.h"
#import "FDPopupManager.h"
#import "FDLocalizationManager.h"

//relative to screen
#define ALARM_WIDTH 0.9
#define ALARM_HEIGHT 0.55

@interface FDLaunchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *checkedInLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmReminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *alarmDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *alarmCancelButton;
@property (weak, nonatomic) IBOutlet UILabel *checkinButtonLabel;

@end

@implementation FDLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Localized start button
    [_startButton setImage:[UIImage imageNamed:NSLocalizedString(@"fd_startBtn", nil)] forState:UIControlStateNormal];
    [_checkedInLabel setText:FDLocalizedString(@"you_havent_checked_in_yet")];
    [_checkinButtonLabel setText:FDLocalizedString(@"onboarding/checkin")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Localized date
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:now];
    [_dateLabel setText:dateString];
    
    [self setAlarmButtonTitle];
    
    if([[FDModelManager sharedManager] entry]) {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM-dd-yyyy"];
        NSDate *date = [dateFormat dateFromString:[[[FDModelManager sharedManager] entry] date]];
        NSDate *now = [NSDate date];
        if([now compare:date] == NSOrderedDescending) {
            [[FDModelManager sharedManager] entry];
        }
    }
    
    if(![[FDModelManager sharedManager] userObject]) {
        [self performSegueWithIdentifier:@"login" sender:self];
        return;
    }
    
    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    if([[FDModelManager sharedManager] entry]) {
        _entryLoaded = YES;
    } else {
        NSLog(@"New entry");
        _entryLoaded = NO;
        
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM-dd-yyyy"];
        NSString *dateString = [formatter stringFromDate:now];
        
        [[FDNetworkManager sharedManager] createEntryWithEmail:[user email] authenticationToken:[user authenticationToken] date:dateString completion:^(bool success, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(success) {
                NSLog(@"Success!");
                
                [[FDModelManager sharedManager] setEntry:[[FDEntry alloc] initWithDictionary:[responseObject objectForKey:@"entry"]]];
                
                NSMutableArray *mutableInputs = [[NSMutableArray alloc] init];
                for (NSDictionary *input in [responseObject objectForKey:@"inputs"]) {
                    [mutableInputs addObject:[[FDInput alloc] initWithDictionary:input]];
                }
                [[FDModelManager sharedManager] setInputs:[mutableInputs copy]];
                
                if(_segueReady)
                    [self performSegueWithIdentifier:@"start" sender:self];
            }
            else {
                NSLog(@"Failure!");
                
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retreiving entry", nil)
                                            message:NSLocalizedString(@"Looks like there was a problem retreiving your entry, please try again.", nil)
                                           delegate:nil
                                  cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                                  otherButtonTitles:nil] show];
            }
            _entryLoaded = YES;
        }];
        
        [[FDNetworkManager sharedManager] getLocale:[[FDLocalizationManager sharedManager] currentLocale] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id response) {
            if(success) {
                NSLog(@"Success!");
                
                [[FDLocalizationManager sharedManager] setLocalizationDictionaryForCurrentLocale:response];
            } else {
                NSLog(@"Failure!");
            }
        }];
    }
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
    
    [_alarmReminderLabel setText:FDLocalizedString(@"alarm_reminder_title")];
    
    [_alarmDoneButton setTitle:FDLocalizedString(@"nav/done") forState:UIControlStateNormal];
    [_alarmCancelButton setTitle:FDLocalizedString(@"nav/cancel") forState:UIControlStateNormal];
    
    //Reminder - 1
    UISwitch *switchItem = (UISwitch *)[alarmView viewWithTag:1];
    [switchItem setOn:[[FDModelManager sharedManager] reminder]];
    _reminderOn = [[FDModelManager sharedManager] reminder];
    
    //Reminder Time - 2
    UIDatePicker *datePicker = (UIDatePicker *)[alarmView viewWithTag:2];
    [datePicker setDate:[[FDModelManager sharedManager] reminderTime]];
    if(_reminderOn)
        [datePicker setAlpha:1.0f];
    else
        [datePicker setAlpha:0.4f];
    _reminderTime = [[FDModelManager sharedManager] reminderTime];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleReminder:(UISwitch *)sender
{
    _reminderOn = sender.on;
    
    //Reminder Time - 2
    UIDatePicker *datePicker = (UIDatePicker *)[_alarmView viewWithTag:2];
    if(_reminderOn)
        [datePicker setAlpha:1.0f];
    else
        [datePicker setAlpha:0.4f];
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
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)setAlarmButtonTitle
{
    NSString *title;
    if(![[FDModelManager sharedManager] reminder]) {
        title = FDLocalizedString(@"alarm_off_caps");
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"hh:mm a"];
        title = [dateFormatter stringFromDate:[[FDModelManager sharedManager] reminderTime]];
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    [_alarmButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (IBAction)closeAlarmView:(UIButton *)sender
{
    [[FDModelManager sharedManager] setReminder:_reminderOn];
    [[FDModelManager sharedManager] setReminderTime:_reminderTime];
    if(_reminderOn) {
        [self setNewNotification];
    } else
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self setAlarmButtonTitle];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(!_entryLoaded) {
        _segueReady = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        return NO;
    }
    return YES;
}

@end

//
//  FDSettingsCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 7/30/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSettingsCollectionViewController.h"

#import "FDTreatmentReminderTableViewController.h"
#import "FDViewController.h"

#import "FDPopupManager.h"
#import "FDModelManager.h"
#import "FDNotificationManager.h"
#import "FDLocalizationManager.h"
#import "FDStyle.h"

#define CARD_HEIGHT 180
#define CARD_WIDTH (self.collectionView.frame.size.width - 20)

#define TREATMENT_REMINDER_HEIGHT 30

#define NAVIGATION_SIZE CGSizeMake([UIScreen mainScreen].bounds.size.width, 50)

//relative to screen
#define ALARM_WIDTH 0.9
#define ALARM_HEIGHT 0.55

#define TREATMENT_POPUP_WIDTH 0.9
#define TREATMENT_POPUP_HEIGHT 0.9

@interface FDSettingsCollectionViewController ()

@end

@implementation FDSettingsCollectionViewController

static NSString * const ReminderCellIdentifier = @"reminder";
static NSString * const TreatmentReminderTitleCellIdentifier = @"treatmentReminderTitle";
static NSString * const TreatmentReminderCellIdentifier = @"treatmentReminder";
static NSString * const AccountCellIdentifier = @"account";
static NSString * const AgreementsCellIdentifier = @"agreements";

static NSString * const NavigationHeaderIdentifier = @"navigation";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _treatments = [[[FDModelManager sharedManager] entry] treatments];
}

- (IBAction)doneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)reminderSwitchToggle:(id)sender
{
    [[FDModelManager sharedManager] setReminder:![[FDModelManager sharedManager] reminder]];
    [self.collectionView reloadData];
    if([[FDModelManager sharedManager] reminder])
        [[FDNotificationManager sharedManager] setCheckinReminder:[[FDModelManager sharedManager] reminderTime]];
    else
        [[FDNotificationManager sharedManager] removeCheckinReminder];
}

- (IBAction)closeAlarmView:(UIButton *)sender
{
    [[FDModelManager sharedManager] setReminderTime:_reminderTime];
    [self.collectionView reloadData];
    if([[FDModelManager sharedManager] reminder])
        [[FDNotificationManager sharedManager] setCheckinReminder:[[FDModelManager sharedManager] reminderTime]];
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
}

- (IBAction)alarmDateChanged:(UIDatePicker *)sender
{
    _reminderTime = sender.date;
}

- (IBAction)treatmentReminderButton:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FDTreatment *treatment = _treatments[[indexPath row]-1];
    
    //open popup
    FDTreatmentReminderTableViewController *viewController = [[UIStoryboard storyboardWithName:@"TreatmentReminderPopup" bundle:nil] instantiateInitialViewController];
    [viewController setTreatment:treatment];
    
    UIView *popupView = [[UIView alloc] init];
    [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*TREATMENT_POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*TREATMENT_POPUP_HEIGHT/2, self.view.window.frame.size.width*TREATMENT_POPUP_WIDTH, self.view.window.frame.size.height*TREATMENT_POPUP_HEIGHT)];
    popupView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:popupView];
    [popupView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(0, 0, popupView.frame.size.width, popupView.frame.size.height);
    [[FDPopupManager sharedManager] addPopupView:popupView withViewController:viewController];
}

- (IBAction)logoutButton:(id)sender
{
    FDViewController *viewController = (FDViewController *)self.presentingViewController;
    UIViewController *launchViewController = viewController.presentingViewController;
    [[FDModelManager sharedManager] logout];
    [self dismissViewControllerAnimated:YES completion:^{
        [viewController dismissViewControllerAnimated:NO completion:^{
            //            [launchViewController performSegueWithIdentifier:@"login" sender:nil];
        }];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0 || section == 2 || section == 3)
        return 1;
    else if(section == 1)
        return 1 + _treatments.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UICollectionViewCell *cell;
    
    if(section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReminderCellIdentifier forIndexPath:indexPath];
        
        // Title Label
        UILabel *reminderTitleLabel = (UILabel *)[cell viewWithTag:1];
        
        
        //2 Switch
        UISwitch *reminderSwitch = (UISwitch *)[cell viewWithTag:2];
        [reminderSwitch setOn:[[FDModelManager sharedManager] reminder]];
        
        //3 Reminder time
        UILabel *reminderTimeLabel = (UILabel *)[cell viewWithTag:3];
        
        NSString *title;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"hh:mm a"];
        title = [dateFormatter stringFromDate:[[FDModelManager sharedManager] reminderTime]];
        [reminderTimeLabel setText:title];
        if([[FDModelManager sharedManager] reminder])
            [reminderTimeLabel setAlpha:1.0f];
        else
            [reminderTimeLabel setAlpha:0.4f];
        
        [FDStyle addRoundedCornersToView:cell];
        [FDStyle addShadowToView:cell];
        
    } else if(section == 1) {
        if(row == 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:TreatmentReminderTitleCellIdentifier forIndexPath:indexPath];
            [FDStyle addRoundedCornersToTopOfView:cell];
            [FDStyle addShadowToView:cell];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:TreatmentReminderCellIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            FDTreatment *treatment = _treatments[row-1];
            [button setTitle:[treatment name] forState:UIControlStateNormal];
            
            if(row == [self.collectionView numberOfItemsInSection:section] - 1) {
                [FDStyle addRoundedCornersToBottomOfView:cell];
                [FDStyle addShadowToView:cell];
            }
        }
    } else if(section == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:AccountCellIdentifier forIndexPath:indexPath];
        [FDStyle addRoundedCornersToView:cell];
        [FDStyle addShadowToView:cell];
    } else if(section == 3) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:AgreementsCellIdentifier forIndexPath:indexPath];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if(kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NavigationHeaderIdentifier forIndexPath:indexPath];
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section != 0)
        return CGSizeZero;
    return NAVIGATION_SIZE;
}

#pragma mark <UICollectionViewFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    
    if(section == 0 || section == 2) {
        return CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
    } else if(section == 1) {
        return CGSizeMake(CARD_WIDTH, TREATMENT_REMINDER_HEIGHT);
    }
    
    return CGSizeZero;
}

- (UICollectionViewCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UICollectionViewCell class]]) {
            return (UICollectionViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

@end

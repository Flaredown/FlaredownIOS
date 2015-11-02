//
//  FDTreatmentReminderTableViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 6/29/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTreatmentReminderTableViewController.h"

#import "FDTreatment.h"
#import "FDNotificationManager.h"
#import "FDLocalizationManager.h"
#import "FDModelManager.h"
#import "FDPopupManager.h"
#import "FDStyle.h"
#import "FDAnalyticsManager.h"

#define TITLE (0)
#define DAYS_START (TITLE + 1)
#define DAYS_END (DAYS_START + daysOfTheWeek.count)
#define TIME_TITLE (DAYS_END)
#define TIME_START (TIME_TITLE + 1)
#define TIME_END (TIME_START + [[[FDModelManager sharedManager] reminderTimesForTreatment:_treatment] count])

@interface FDTreatmentReminderTableViewController ()

@end

@implementation FDTreatmentReminderTableViewController

static NSString * const TitleCellIdentifier = @"titleCell";
static NSString * const DayCellIdentifier = @"dayCell";
static NSString * const TimeTitleCellIdentifier = @"timeTitleCell";
static NSString * const TimeCellIdentifier = @"timeCell";
static NSString * const AddTimeCellIdentifier = @"addTimeCell";

static NSArray *daysOfTheWeek;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    daysOfTheWeek =
        @[@"Sundays", @"Mondays", @"Tuesdays", @"Wednesdays", @"Thursdays", @"Fridays", @"Saturdays"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[FDAnalyticsManager sharedManager] trackPageView:@"Treatment Reminders"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshReminders
{
    [[FDNotificationManager sharedManager] setRemindersForTreatment:_treatment];
}

- (IBAction)toggleDay:(id)sender
{
    UITableViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = [indexPath row];
    NSInteger dayIndex = row - DAYS_START;
    
    //Toggle reminder
    [[FDModelManager sharedManager] setReminderDay:dayIndex forTreatment:_treatment on:![[[FDModelManager sharedManager] reminderDaysForTreatment:_treatment][dayIndex] boolValue]];
    [self refreshReminders];
}

- (IBAction)removeTimeButton:(id)sender
{
    UITableViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = [indexPath row];
    NSInteger timeIndex = row - TIME_START;
    
    [self removeTimeAtIndex:timeIndex];
}

- (void)removeTimeAtIndex:(NSInteger)index
{
    [[FDModelManager sharedManager] removeReminderTimeAtIndex:index forTreatment:_treatment];
    [self refreshReminders];
    [self.tableView reloadData];
}

- (IBAction)addTimeButton:(id)sender
{
    UIView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"ReminderTimePickerView" owner:self options:nil] objectAtIndex:0];
    [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*POPUP_HEIGHT/2, self.view.window.frame.size.width*POPUP_WIDTH, self.view.window.frame.size.height*POPUP_HEIGHT)];
    popupView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:popupView];
    [[FDPopupManager sharedManager] addPopupView:popupView];
    
    [_reminderTimeCancelButton addTarget:[FDPopupManager sharedManager] action:@selector(removeTopPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [popupView needsUpdateConstraints];
}

- (IBAction)addTimeDone:(id)sender
{
    NSDate *date = [_reminderTimePicker date];
    [self addTime:date];
    [[FDPopupManager sharedManager] removeTopPopup];
}

- (void)addTime:(NSDate *)time
{
    [[FDModelManager sharedManager] addReminderTime:time forTreatment:_treatment];
    [self refreshReminders];
    [self.tableView reloadData];
}

- (UITableViewCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [daysOfTheWeek count] + 1 + [[[FDModelManager sharedManager] reminderTimesForTreatment:_treatment] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO:Localization
    UITableViewCell *cell;
    NSInteger row = [indexPath row];
        
    if(row == TITLE) {
        cell = [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier forIndexPath:indexPath];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        
    } else if(row >= DAYS_START && row < DAYS_END) {
        cell = [tableView dequeueReusableCellWithIdentifier:DayCellIdentifier forIndexPath:indexPath];
        
        NSInteger dayIndex = row - DAYS_START;
        
        //1 Switch
        UISwitch *daySwitch = (UISwitch *)[cell viewWithTag:1];
        [daySwitch setOn:[[[FDModelManager sharedManager] reminderDaysForTreatment:_treatment][dayIndex] boolValue]];
        
        //2 Label
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        [label setText:daysOfTheWeek[dayIndex]];
        
    } else if(row == TIME_TITLE) {
        cell = [tableView dequeueReusableCellWithIdentifier:TimeTitleCellIdentifier forIndexPath:indexPath];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        
    } else if(row >= TIME_START && row < TIME_END) {
        cell = [tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier forIndexPath:indexPath];
        
        NSInteger timeIndex = row - TIME_START;
        NSDate *reminderTime = [[FDModelManager sharedManager] reminderTimesForTreatment:_treatment][timeIndex];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        NSString *title = [NSDateFormatter localizedStringFromDate:reminderTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        [label setText:title];
        
        //2 Remove button
        UIButton *button = (UIButton *)[cell viewWithTag:2];
        
    } else if(row == TIME_END) {
        cell = [tableView dequeueReusableCellWithIdentifier:AddTimeCellIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if(row == TITLE) {
        return 100;
    } else if(row >= DAYS_START && row < DAYS_END) {
        return 45;
    } else if(row == TIME_TITLE) {
        return 65;
    } else if(row >= TIME_START && row < TIME_END) {
        return 45;
    } else if(row == TIME_END) {
        return 65;
    }
    return 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

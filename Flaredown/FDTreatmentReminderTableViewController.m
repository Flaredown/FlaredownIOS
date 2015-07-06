//
//  FDTreatmentReminderTableViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 6/29/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTreatmentReminderTableViewController.h"

#import "FDTreatment.h"

#define TITLE (0)
#define DAYS_START (TITLE + 1)
#define DAYS_END (DAYS_START + daysOfTheWeek.count)
#define TIME_TITLE (DAYS_END)
#define TIME_START (TIME_TITLE + 1)
#define TIME_END (TIME_START + [[_treatment reminderTimes] count])

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + daysOfTheWeek.count + 1 + 0 + 1;
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
        [daySwitch setOn:(BOOL)[_treatment reminderDays][dayIndex]];
        
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
        NSDate *reminderTime = [_treatment reminderTimes][timeIndex];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        
        //2 Remove button
        UIButton *button = (UIButton *)[cell viewWithTag:2];
        
    } else if(row == TIME_END) {
        cell = [tableView dequeueReusableCellWithIdentifier:AddTimeCellIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
    }
    
    return cell;
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

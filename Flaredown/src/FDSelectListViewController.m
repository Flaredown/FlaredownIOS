//
//  FDSelectListViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDSelectListViewController.h"

@interface FDSelectListViewController ()

@end

@implementation FDSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedItems = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.responses = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initWithQuestions:(NSArray *)questions
{
    self.questions = questions;
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    
    int count = 0;
    for (FDQuestion *question in self.questions) {
        
        FDResponse *response = [[FDResponse alloc] init];
        [response setResponseIdWithEntryId:[entry entryId] name:[question name]];
        if([entry responseForId:[response responseId]]) {
            response = [entry responseForId:[response responseId]];
            if([response value] == 1)
                [self.selectedItems addObject:[NSIndexPath indexPathForRow:count inSection:0]];
            [self.responses addObject:response];
        } else {
            [response setName:[question name]];
            [response setValue:0];
            [response setCatalog:[question catalog]];
            [self addResponse:response];
        }
        count++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Toggle selected for target item
- (IBAction)listItemButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    FDResponse *response = [self.responses objectAtIndex:[indexPath row]];
//    if([self.selectedItems containsObject:indexPath]) { // deselect item
    if([response value] == 1) {
        [self.selectedItems removeObject:indexPath];
        
        [response setValue:0];
        
    } else { // select item
        [self.selectedItems addObject:indexPath];
        
        FDResponse *response = [self.responses objectAtIndex:[indexPath row]];
        [response setValue:1];
    }
    [self.tableView reloadData];
}

- (void)selectButton:(UIButton *)button
{
    UIColor *selectColor = [UIColor colorWithRed:111.0f/255.0f green:214.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    [button setBackgroundColor:selectColor];
    
    UIColor *selectTextColor = [UIColor whiteColor];
    [button setTitleColor:selectTextColor forState:UIControlStateNormal];
}

- (void)deselectButton:(UIButton *)button
{
    UIColor *deselectColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    [button setBackgroundColor:deselectColor];
    
    UIColor *deselectTextColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.f/255.0f alpha:1.0f];
    [button setTitleColor:deselectTextColor forState:UIControlStateNormal];
}

/*
 *  Opens dialogue to remove an item from the list
 */
- (IBAction)removeItemButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    
    self.removeIndex = (int)[[self.tableView indexPathForCell:cell] row];
    
    UIButton *titleButton = (UIButton *)[cell viewWithTag:1];
    NSString *itemName = titleButton.titleLabel.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No longer taking %@?", nil), itemName]
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Remove Treatment", nil), nil];
    [alert show];
}

/*
 *  Opens dialogue to add an item to the list
 */
- (IBAction)addItemButton:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add Treatment", nil)
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"Name of treatment", nil)];
    [alert show];
}

/*
 *  Handles alert view response - adding items, removing items
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([buttonTitle isEqualToString:NSLocalizedString(@"Cancel", nil)])
        return;
    
    if([alertView.title isEqualToString:NSLocalizedString(@"Add Treatment", nil)]) {
        [self addListItem:[alertView textFieldAtIndex:0].text];
        [self.tableView reloadData];
        
    } else if([alertView.title containsString:NSLocalizedString(@"No longer taking", nil)]) {
        [self removeListItem];
        
    }
}

/*
 *  Add new item to the list with the specified title
 */
- (void)addListItem:(NSString *)title
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    FDQuestion *question = self.questions[0];
    FDResponse *response = [[FDResponse alloc] init];
    [response setResponseIdWithEntryId:[entry entryId] name:title];
    if([entry responseForId:[response responseId]]) {
        [self.responses addObject:[entry responseForId:[response responseId]]];
    } else {
        [response setName:title];
        [response setValue:0];
        [response setCatalog:[question catalog]];
        [self addResponse:response];
    }
}

/*
 *  Remove the item at the removeIndex and reload table
 */
- (void)removeListItem
{
    [self removeResponse:[self.responses objectAtIndex:self.removeIndex]];
    self.removeIndex = -1;
    [self.tableView reloadData];
}

- (void)addResponse:(FDResponse *)response
{
    [self.responses addObject:response];
    [[[FDModelManager sharedManager] entry] insertResponse:response];
}

- (void)removeResponse:(FDResponse *)response
{
    [self.responses removeObject:response];
    [[[FDModelManager sharedManager] entry] removeResponse:response];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dynamic ? [self.responses count] + 1 : [self.responses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if(self.dynamic && [indexPath row] == self.responses.count) { //add item cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"addItem" forIndexPath:indexPath];
        
        return cell;
        
    } else if(self.dynamic && [indexPath row] > self.responses.count) {
        NSLog(@"Invalid number of rows in FDSelectListView");
        return nil;
    } else { //item cell
        if(self.dynamic) { //dynamic item cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicListItem" forIndexPath:indexPath];
            
        } else { //static item cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"staticListItem" forIndexPath:indexPath];
            
        }
        
        //List button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        [button setTitle:[self.questions[[indexPath row]] name] forState:UIControlStateNormal];
        
        FDResponse *response = self.responses[[indexPath row]];
        if([response value] == 1) {
            [self selectButton:button];
        } else {
            [self deselectButton:button];
        }
        
        return cell;
    }
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

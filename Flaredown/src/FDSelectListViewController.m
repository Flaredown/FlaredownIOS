//
//  FDSelectListViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDSelectListViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import "FDTreatment.h"
#import "DLAVAlertView.h"
#import "DLAVAlertViewTheme.h"

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
            response = [response initWithEntry:entry question:question];
            [self addResponse:response];
        }
        count++;
    }
}

- (void)initWithTreatments
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    self.questions = [entry treatments];
    self.treatments = YES;
}

- (void)initWithSymptoms
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    self.questions = [entry questionsForCatalog:@"symptoms"];
    self.masterSymptoms = [[[FDModelManager sharedManager] userObject] symptoms];
    self.editSymptoms = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *questions = [[[FDModelManager sharedManager] entry] questions];
    if(_dynamic)
        [_mainViewDelegate refreshPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Toggle selected for target item
- (IBAction)listItemButton:(id)sender
{
    if(self.dynamic)
        return;
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if(_treatments) {
        FDTreatment *treatment = [self.questions objectAtIndex:[indexPath row]];
        if([treatment taken]) {
            [self.selectedItems removeObject:indexPath];
            [treatment setTaken:NO];
        } else {
            [self.selectedItems addObject:indexPath];
            [treatment setTaken:YES];
        }
    } else {
        FDResponse *response = [self.responses objectAtIndex:[indexPath row]];
        if([response value] == 1) {
            [self.selectedItems removeObject:indexPath];
            [response setValue:0];
        } else {
            [self.selectedItems addObject:indexPath];
            [response setValue:1];
        }
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
    
    int itemRow = (int)[[self.tableView indexPathForCell:cell] row] - 1;
    self.removeIndex = itemRow;
    
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
    if(!_treatments) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add Treatment", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"Name of treatment", nil)];
        [alert show];
    } else {
        DLAVAlertViewTheme *theme = [[DLAVAlertViewTheme alloc] init];
//        theme.contentViewMargins = DLAVTextControlMarginsMake(5000, 5000, 0, 0);
//        theme.lineColor = [UIColor purpleColor];
//        theme.borderWidth = 100;
        DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:NSLocalizedString(@"Add Treatment", nil)
                                    message:nil
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                           otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert addTextFieldWithText:@"" placeholder:@"Name of Treatment"];
        [alert addTextFieldWithText:@"" placeholder:@"Dose (daily)"];
        [alert addTextFieldWithText:@"" placeholder:@"Units"];
        [alert applyTheme:theme];
        [alert show];
    }
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
    if(self.editSymptoms) {
        FDEntry *entry = [[FDModelManager sharedManager] entry];
        NSInteger sectionToAdd = [[self.questions objectAtIndex:[self.questions count]-1] section]+1;
        NSInteger indexToAdd = [[entry questions] indexOfObject:self.questions[[self.questions count]-1]]+1;
        
        __block FDQuestion *newQuestion; //__block to make it compatible with async task
        BOOL found = NO;
        for (FDSymptom *symptom in self.masterSymptoms) {
            if([[symptom name] isEqualToString:title]) {
                newQuestion = [[FDQuestion alloc] initWithSymptom:symptom section:sectionToAdd];
                [entry insertQuestion:newQuestion atIndex:indexToAdd];
                [self.questions addObject:newQuestion];
                found = YES;
                
                //New response
                FDResponse *response = [[FDResponse alloc] initWithEntry:entry question:newQuestion];
                if(![entry responseForId:[response responseId]]) {
                    [[[FDModelManager sharedManager] entry] insertResponse:response];
                }
                
                [self.tableView reloadData];
            }
        }
        if(!found) {
            
            //Check the new symptom against the API for validation
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            FDUser *user = [[FDModelManager sharedManager] userObject];
            [[FDNetworkManager sharedManager] createSymptomWithName:title email:[user email] authenticationToken:[user authenticationToken] completion:^ (bool success, id responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if(success) {
                    NSLog(@"Success!");
                    
                    FDSymptom *newSymptom = [[FDSymptom alloc] initWithTitle:title entry:entry];
                    newQuestion = [[FDQuestion alloc] initWithSymptom:newSymptom section:sectionToAdd];
                    [entry insertQuestion:newQuestion atIndex:indexToAdd];
                    [self.questions addObject:newQuestion];
                    
                    [self.tableView reloadData];
                }
                else {
                    NSLog(@"Failure!");
                    
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error creating symptom", nil)
                                                message:NSLocalizedString(@"Looks like there was an issue creating the new symptom; please check the symptom name and try again.", nil)
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                      otherButtonTitles:nil] show];
                }
            }];
        }
        
    } else if(_treatments) {
        FDEntry *entry = [[FDModelManager sharedManager] entry];
//        NSInteger section = [[self.questions objectAtIndex:[self.questions count]-1] section];
        NSInteger indexToAdd = [[entry questions] indexOfObject:self.questions[[self.questions count]-1]]+1;
        
        __block FDQuestion *newQuestion; //__block to make it compatible with async task
        BOOL found = NO;
        for (FDTreatment *treatment in self.masterTreatments) {
            if([[treatment name] isEqualToString:title]) {
                [[entry treatments] addObject:treatment];
                found = YES;
                
                [self.tableView reloadData];
            }
        }
        if(!found) {
            
            //Check the new symptom against the API for validation
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            FDUser *user = [[FDModelManager sharedManager] userObject];
            [[FDNetworkManager sharedManager] createTreatmentWithName:title email:[user email] authenticationToken:[user authenticationToken] completion:^ (bool success, id responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if(success) {
                    NSLog(@"Success!");
                    
                    FDTreatment *newTreatment = [[FDTreatment alloc] initWithTitle:title quantity:0.0f unit:@"" entry:entry];
                    [newTreatment setTaken:YES];
                    [[entry treatments] addObject:newTreatment];
                    
                    [self.tableView reloadData];
                }
                else {
                    NSLog(@"Failure!");
                    
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error creating treatment", nil)
                                                message:NSLocalizedString(@"Looks like there was an issue creating the new treatment; please check the treatment name and try again.", nil)
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                      otherButtonTitles:nil] show];
                }
            }];
        }
    }
}

/*
 *  Remove the item at the removeIndex and reload table
 */
- (void)removeListItem
{
    if(self.editSymptoms) {
        FDEntry *entry = [[FDModelManager sharedManager] entry];
        
        FDQuestion *question = self.questions[self.removeIndex];
        
        FDResponse *response = [[FDResponse alloc] init];
        [response setResponseIdWithEntryId:[entry entryId] name:[question name]];
        
        [entry removeQuestion:question];
        [self.questions removeObject:question];
        
        [self.tableView reloadData];
        
    } else if(_treatments) {
        FDEntry *entry = [[FDModelManager sharedManager] entry];
        
        FDTreatment *treatment = self.questions[self.removeIndex];
        
        [[entry treatments] removeObject:treatment];
        
        [self.tableView reloadData];
    }
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

- (IBAction)doneButton:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.dynamic)
        return [self.questions count] + 1 + 1;
    if(_treatments)
        return [self.questions count];
    return [self.responses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if(self.dynamic) {
        if([indexPath row] == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
            
            //1 title
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            if(_editSymptoms)
                [titleLabel setText:@"Edit Symptoms"];
            else
                [titleLabel setText:@"Edit Treatments"];
            
        } else if([indexPath row] < self.questions.count + 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicListItem" forIndexPath:indexPath];
            
            int itemRow = [indexPath row] - 1;
            
            if(_treatments) {
                //1 List button
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                FDTreatment *treatment = self.questions[itemRow];
                [button setTitle:[NSString stringWithFormat:@"%@ - %f %@", [treatment name], [treatment quantity], [treatment unit]] forState:UIControlStateNormal];
                [self selectButton:button];
            } else {
                //1 List button
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                FDQuestion *question = self.questions[itemRow];
                [button setTitle:[question name] forState:UIControlStateNormal];
                [self selectButton:button];
            }
            
        } else if([indexPath row] == self.questions.count + 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"addItem" forIndexPath:indexPath];
        } //else if([indexPath row] > self.questions.count)
//            cell = [tableView dequeueReusableCellWithIdentifier:@"done" forIndexPath:indexPath];
    } else { //item cell
        if(self.dynamic) { //dynamic item cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicListItem" forIndexPath:indexPath];
            
        } else { //static item cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"staticListItem" forIndexPath:indexPath];
        }
        
        if(_treatments) {
            //List button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            FDTreatment *treatment = self.questions[[indexPath row]];
            [button setTitle:[NSString stringWithFormat:@"%@ - %f %@", [treatment name], [treatment quantity], [treatment unit]] forState:UIControlStateNormal];
            
            if([treatment taken]) {
                [self selectButton:button];
            } else {
                [self deselectButton:button];
            }
        } else {
            //List button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            FDQuestion *question = self.questions[[indexPath row]];
            [button setTitle:[question name] forState:UIControlStateNormal];
            
            FDResponse *response = self.responses[[indexPath row]];
            if([response value] == 1) {
                [self selectButton:button];
            } else {
                [self deselectButton:button];
            }
        }
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

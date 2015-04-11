//
//  FDSelectListViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDSelectListViewController.h"

#import "FDStyle.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import "FDPopupManager.h"
#import "FDTreatment.h"
#import "FDRemoveTrackableView.h"

//relative to screen
#define POPUP_WIDTH 0.95
#define POPUP_HEIGHT 0.5

#define POPUP_KEYBOARD_OFFSET 60

@interface FDSelectListViewController ()

@end

@implementation FDSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedItems = [[NSMutableArray alloc] init];
    self.responses = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)initWithQuestions:(NSMutableArray *)questions
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
    _listType = ListTypeTreatments;
}

- (void)initWithSymptoms
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    self.questions = (NSMutableArray *)[entry questionsForCatalog:@"symptoms"];
    self.masterSymptoms = [[[FDModelManager sharedManager] userObject] symptoms];
    _listType = ListTypeSymptoms;
}

- (void)initWithConditions
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    self.questions = (NSMutableArray *)[entry questionsForCatalog:@"conditions"];
    self.masterConditions = [[[FDModelManager sharedManager] userObject] conditions];
    _listType = ListTypeConditions;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_dynamic)
        [_mainViewDelegate refreshPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow
{
    FDPopup *popup = [[FDPopupManager sharedManager] topPopup];
    if(popup) {
        UIView *popupView = [popup view];
        popupView.frame = CGRectMake(popupView.frame.origin.x, popupView.frame.origin.y - POPUP_KEYBOARD_OFFSET, popupView.frame.size.width, popupView.frame.size.height);
        _popupKeyboardOffset = YES;
    }
}

- (void)keyboardWillHide
{
    FDPopup *popup = [[FDPopupManager sharedManager] topPopup];
    if(popup && _popupKeyboardOffset) {
        UIView *popupView = [popup view];
        popupView.frame = CGRectMake(popupView.frame.origin.x, popupView.frame.origin.y + POPUP_KEYBOARD_OFFSET, popupView.frame.size.width, popupView.frame.size.height);
        _popupKeyboardOffset = NO;
    }
}

// Toggle selected for target item
- (IBAction)listItemButton:(id)sender
{
    if(self.dynamic)
        return;
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if(_listType == ListTypeTreatments) {
        FDTreatment *treatment = [self.questions objectAtIndex:[indexPath row]];
        if([treatment taken]) {
            [self.selectedItems removeObject:indexPath];
            [treatment setTaken:NO];
        } else {
            [self.selectedItems addObject:indexPath];
            [treatment setTaken:YES];
        }
    } else if(_listType == ListTypeSymptoms || _listType == ListTypeConditions) {
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
    UIColor *selectColor = [FDStyle blueColor];
    [button setBackgroundColor:selectColor];
    
    UIColor *selectTextColor = [FDStyle whiteColor];
    [button setTitleColor:selectTextColor forState:UIControlStateNormal];
}

- (void)deselectButton:(UIButton *)button
{
    UIColor *deselectColor = [FDStyle lightGreyColor];
    [button setBackgroundColor:deselectColor];
    
    UIColor *deselectTextColor = [FDStyle greyColor];
    [button setTitleColor:deselectTextColor forState:UIControlStateNormal];
}

/*
 *  Opens dialogue to remove an item from the list
 */
- (IBAction)removeItemButton:(id)sender
{
    FDRemoveTrackableView *popupView = (FDRemoveTrackableView *)[[[NSBundle mainBundle] loadNibNamed:@"RemoveTrackableView" owner:self options:nil] objectAtIndex:0];
    
    [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*POPUP_HEIGHT/2, self.view.window.frame.size.width*POPUP_WIDTH, self.view.window.frame.size.height*POPUP_HEIGHT)];
    popupView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:popupView];
    
    [FDStyle addLargeRoundedCornersToView:popupView.removeButton];
    
    [[FDPopupManager sharedManager] addPopupView:popupView];
    
    _removeIndex = [[self.tableView indexPathForCell:[self parentCellForView:sender]] row]-1;
    
    NSString *title = [NSString stringWithFormat:@"No longer tracking %@?", [_questions[_removeIndex] name]];
    [popupView.titleLabel setText:title];
}

/*
 *  Opens dialogue to add an item to the list
 */
- (IBAction)addItemButton:(id)sender
{
    if(_listType == ListTypeSymptoms) {
        [self openSymptomSearch:sender];
    } else if(_listType == ListTypeConditions) {
        [self openConditionSearch:sender];
    } else if(_listType == ListTypeTreatments) {
        
        if(!_dynamic)
           [_contentViewDelegate editList];
    
        UIView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"AddTreatmentView" owner:self options:nil] objectAtIndex:0];
        [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*POPUP_HEIGHT/2, self.view.window.frame.size.width*POPUP_WIDTH, self.view.window.frame.size.height*POPUP_HEIGHT)];
        popupView.layer.masksToBounds = YES;
        [FDStyle addRoundedCornersToView:popupView];
        
        [[FDPopupManager sharedManager] addPopupView:popupView];
    }
}

- (void)addTreatmentPopupWithTreatment:(FDTreatment *)treatment
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    if([[entry treatments] containsObject:treatment]) {
        [self editTreatmentPopupWithTreatment:treatment];
    } else {
        [self addItemButton:nil];
        _addTreatmentNameField.text = [treatment name] ?: @"";
        _addTreatmentDoseField.text = [treatment quantity] ? [FDStyle trimmedDecimal:[treatment quantity]] : @"";
        _addTreatmentUnitField.text = [treatment unit] ?: @"";
    }
}

- (IBAction)openSymptomSearch:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mainViewDelegate openSearch:@"symptoms"];
}

- (IBAction)openConditionSearch:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mainViewDelegate openSearch:@"conditions"];
}

- (IBAction)openTreatmentSearch:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mainViewDelegate openSearch:@"treatments"];
}

- (IBAction)addTreatment:(id)sender
{
    NSString *name;
    float dose;
    NSString *unit;
    if(_addTreatmentNameField.text.length == 0)
        return;
    if(_addTreatmentDoseField.text.length == 0 || [_addTreatmentDoseField.text floatValue] <= 0)
        return;
    if(_addTreatmentUnitField.text.length == 0)
        return;
    name = _addTreatmentNameField.text;
    dose = [_addTreatmentDoseField.text floatValue];
    unit = _addTreatmentUnitField.text;
    FDTreatment *treatment = [[FDTreatment alloc] initWithTitle:name quantity:dose unit:unit entry:[[FDModelManager sharedManager] entry]];
    [[[[FDModelManager sharedManager] entry] treatments] addObject:treatment];
    
    [self.tableView reloadData];
    [self hidePopupView];
}

- (IBAction)editItemButton:(UIButton *)sender
{
    NSInteger editRow = [[self.tableView indexPathForCell:[self parentCellForView:sender]] row] - 1;
    [self editTreatmentPopupWithTreatment:[[[FDModelManager sharedManager] entry] treatments][editRow]];
}

- (void)editTreatmentPopupWithTreatment:(FDTreatment *)treatment
{
    _editTreatment = treatment;
    
    UIView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"EditTreatmentView" owner:self options:nil] objectAtIndex:0];
    [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*POPUP_HEIGHT/2, self.view.window.frame.size.width*POPUP_WIDTH, self.view.window.frame.size.height*POPUP_HEIGHT)];
    popupView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:popupView];
    [[FDPopupManager sharedManager] addPopupView:popupView];

    [popupView needsUpdateConstraints];
    
    [_editTreatmentTitleLabel setText:[NSString stringWithFormat:@"Edit daily dosage of %@", [_editTreatment name]]];
//    [_editTreatmentDoseField setPlaceholder:[FDStyle trimmedDecimal:[_editTreatment quantity]]];
//    if([[_editTreatment unit] length] > 0)
//        [_editTreatmentUnitField setPlaceholder:[_editTreatment unit]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
//    return YES;
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder && [nextResponder isKindOfClass:[UITextField class]]) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)editTreatment:(id)sender
{
    if(_editTreatmentDoseField.text.length > 0 && [_editTreatmentDoseField.text floatValue] > 0)
        [_editTreatment setQuantity:[_editTreatmentDoseField.text floatValue]];
    if(_editTreatmentUnitField.text.length > 0)
        [_editTreatment setUnit:_editTreatmentUnitField.text];
    
    [self.tableView reloadData];
    [self hidePopupView];
}

- (IBAction)closePopupView:(UIButton *)sender
{
    [self hidePopupView];
}

- (void)hidePopupView
{
    [[FDPopupManager sharedManager] removeTopPopup];
}

/*
 *  Add new item to the list with the specified title
 */
- (void)addListItem:(NSString *)title
{
    if(_listType == ListTypeTreatments) {
        FDEntry *entry = [[FDModelManager sharedManager] entry];
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
- (IBAction)removeListItem:(id)sender
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    
    // Check to see if the page index needs to be decremented
    // (If on last page of symptoms and it is removed, go back to the next symptoms page)
    if(_listType == ListTypeConditions || _listType == ListTypeSymptoms) {
        NSInteger lastIndex = 0;
        if(_listType == ListTypeConditions)
            lastIndex = [entry questionsForCatalog:@"conditions"].count-1;
        else if(_listType == ListTypeSymptoms)
            lastIndex = [entry questionsForCatalog:@"symptoms"].count-1;
        
        if(_removeIndex == lastIndex && _removeIndex != 0) {
            int firstIndex;
            if(_listType == ListTypeConditions)
                firstIndex = [[entry questions] indexOfObject:[entry questionsForCatalog:@"conditions"].firstObject];
            else if(_listType == ListTypeSymptoms)
                firstIndex = [[entry questions] indexOfObject:[entry questionsForCatalog:@"symptoms"].firstObject];
            [_mainViewDelegate adjustPageIndexForRemovedItem:firstIndex];
        }
    }
    
    if(_listType == ListTypeSymptoms || _listType == ListTypeConditions) {
        
        FDQuestion *question = self.questions[self.removeIndex];
        FDResponse *response = [[FDResponse alloc] init];
        [response setResponseIdWithEntryId:[entry entryId] name:[question name]];
        
        [entry removeQuestion:question];
        [self.questions removeObject:question];
        
        [self.tableView reloadData];
        
    } else if(_listType == ListTypeTreatments) {
        
        FDTreatment *treatment = self.questions[self.removeIndex];
        [[entry treatments] removeObject:treatment];
        [self.questions removeObject:treatment];
        
        [self.tableView reloadData];
        
//        [[FDPopupManager sharedManager] removeTopPopup];
    }
    [[FDPopupManager sharedManager] removeTopPopup];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.dynamic)
        return [self.questions count] + 1 + 1; //questions + add + title
    else if(_questions.count == 0)
        return 1;
    if(_listType == ListTypeTreatments)
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
            if(_listType == ListTypeSymptoms)
                [titleLabel setText:NSLocalizedString(@"Edit Symptoms", nil)];
            else if(_listType == ListTypeTreatments)
                [titleLabel setText:NSLocalizedString(@"Edit Treatments", nil)];
            else if(_listType == ListTypeConditions)
                [titleLabel setText:NSLocalizedString(@"Edit Conditions", nil)];
            
        } else if([indexPath row] < self.questions.count + 1) {
            int itemRow = [indexPath row] - 1;
            
            if(_listType == ListTypeTreatments) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicTreatment" forIndexPath:indexPath];
                
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                //Style
                [FDStyle addLargeRoundedCornersToView:button];
                
                FDTreatment *treatment = self.questions[itemRow];
                
                //1 List button
                [button setTitle:[treatment name] forState:UIControlStateNormal];
                [self selectButton:button];
                
                //2 Dosage and Units label
                UILabel *label = (UILabel *)[cell viewWithTag:2];
                NSString *quantityString = [FDStyle trimmedDecimal:[treatment quantity]];
                [label setText:[NSString stringWithFormat:@"%@ %@", quantityString, [treatment unit]]];
                
                //4 Edit button
                UIButton *editButton = (UIButton *)[cell viewWithTag:4];
                [editButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"edit", nil) attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[FDStyle greyColor]}] forState:UIControlStateNormal];
                
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicListItem" forIndexPath:indexPath];
                
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                //Style
                [FDStyle addLargeRoundedCornersToView:button];
                
                //1 List button
                FDQuestion *question = self.questions[itemRow];
                [button setTitle:[question name] forState:UIControlStateNormal];
                [self selectButton:button];
            }
            
        } else if([indexPath row] == self.questions.count + 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"addItem" forIndexPath:indexPath];
            
            //1 Add button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            if(_listType == ListTypeTreatments)
                [button setTitle:NSLocalizedString(@"+ Add Treatment", nil) forState:UIControlStateNormal];
            else if(_listType == ListTypeSymptoms)
                [button setTitle:NSLocalizedString(@"+ Add Symptom", nil) forState:UIControlStateNormal];
            else if(_listType == ListTypeConditions)
                [button setTitle:NSLocalizedString(@"+ Add Condition", nil) forState:UIControlStateNormal];
        }
    } else if(_questions.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addItem" forIndexPath:indexPath];

        //1 Add button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
            
        if(_listType == ListTypeTreatments) {
            [button setTitle:NSLocalizedString(@"+ Add Treatment", nil) forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(openTreatmentSearch:) forControlEvents:UIControlEventTouchUpInside];
        } else if(_listType == ListTypeSymptoms) {
            [button setTitle:NSLocalizedString(@"+ Add Symptom", nil) forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(openSymptomSearch:) forControlEvents:UIControlEventTouchUpInside];
        } else if(_listType == ListTypeConditions) {
            [button setTitle:NSLocalizedString(@"+ Add Condition", nil) forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(openConditionSearch:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"staticListItem" forIndexPath:indexPath];
        
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        //Style
        [FDStyle addLargeRoundedCornersToView:button];
        
        if(_listType == ListTypeTreatments) {
            //List button
            FDTreatment *treatment = self.questions[[indexPath row]];
            NSString *quantityString = [FDStyle trimmedDecimal:[treatment quantity]];
            [button setTitle:[NSString stringWithFormat:@"%@ - %@ %@", [treatment name], quantityString, [treatment unit]] forState:UIControlStateNormal];
            
            if([treatment taken]) {
                [self selectButton:button];
            } else {
                [self deselectButton:button];
            }
        } else if(_listType == ListTypeSymptoms || _listType == ListTypeConditions) {
            
            //List button
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_listType == ListTypeTreatments && _dynamic)
        return 90;
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    return cell.frame.size.height;
//}

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

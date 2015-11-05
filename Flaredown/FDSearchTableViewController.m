//
//  FDSearchTableViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 2/16/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSearchTableViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import "FDPopupManager.h"
#import "FDTrackableResult.h"
#import "FDAnalyticsManager.h"

#import "FDLocalizationManager.h"

@interface FDSearchTableViewController ()

@end

@implementation FDSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_searchType == SearchSymptoms) {
        [self setTitle:FDLocalizedString(@"onboarding/add_a_symptom_title")];
    } else if(_searchType == SearchTreatments) {
        [self setTitle:FDLocalizedString(@"add_treatment")];
    } else if(_searchType == SearchConditions) {
        [self setTitle:FDLocalizedString(@"onboarding/add_condition")];
    } else if(_searchType == SearchTags) {
        [self setTitle:@"tags"]; //TODO:Localized
    }
    
    _results = [[NSMutableArray alloc] init];
    
    _editing = YES;
    
    [_contentViewDelegate closeEditList];
    
//    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[FDAnalyticsManager sharedManager] trackPageView:@"Search"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
}

- (void)performSearch
{
    if(_searchText.length == 0) {
        [_results removeAllObjects];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    NSString *searchType;
    if(_searchType == SearchSymptoms)
        searchType = @"symptoms";
    else if(_searchType == SearchTreatments)
        searchType = @"treatments";
    else if(_searchType == SearchConditions)
        searchType = @"conditions";
    else if(_searchType == SearchTags)
        searchType = @"tags";
    
    [[FDNetworkManager sharedManager] searchTrackables:_searchText type:searchType email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(success) {
            NSLog(@"Success!");
            
            NSArray *resultResponse = (NSArray *)responseObject;
            [_results removeAllObjects];
            
            
            BOOL found = NO;
            for (NSDictionary *result in resultResponse) {
                FDTrackableResult *resultObject = [[FDTrackableResult alloc] initWithDictionary:result];
                [_results addObject:resultObject];
                if([[resultObject name] caseInsensitiveCompare:_searchText] == NSOrderedSame)
                    found = YES;
            }
            if(!found) {
                FDTrackableResult *resultObject = [[FDTrackableResult alloc] init];
                [resultObject setName:_searchText];
                [resultObject setCount:-1];
                [_results insertObject:resultObject atIndex:0];
            }
        }
        else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:FDLocalizedString(@"nice_errors/search_error")
                                        message:FDLocalizedString(@"nice_errors/search_error_details")
                                       delegate:nil
                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                              otherButtonTitles:nil] show];
        }
        [self.tableView reloadData];
//        UITextField *searchField = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1];
//        [searchField becomeFirstResponder];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _editing = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(_timer != nil)
        [_timer invalidate];
    
    _searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:SEARCH_DELAY target:self selector:@selector(performSearch) userInfo:nil repeats:NO];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    _editing = NO;
    [self.tableView reloadData];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(section == 0)
//        return 1;
    if(_results.count == 0)
        return 1;
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
//    if([indexPath section] == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
//        
//        //1 - TextField
//        UITextField *textField = (UITextField *)[cell viewWithTag:1];
//        textField.delegate = self;
//        [textField becomeFirstResponder];
//        
//    } else {
    if(_results.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"placeholder" forIndexPath:indexPath];
        return cell;
    }
        cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
        
        FDTrackableResult *result = _results[[indexPath row]];
        
        //1 - Title
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        //2 - Subtext
        UILabel *subtext = (UILabel *)[cell viewWithTag:2];
        
        if([result count] != -1) {
            [title setText:[result name]];
            [subtext setText:[NSString stringWithFormat:@"%i %@", [result count], FDLocalizedString(@"add_trackable_users")]];
        } else {
            if(_searchType == SearchConditions)
                [subtext setText:FDLocalizedString(@"onboarding/add_new_condition")];
            else if(_searchType == SearchTreatments)
                [subtext setText:FDLocalizedString(@"add_new_treatment")];
            else if(_searchType == SearchSymptoms)
                [subtext setText:FDLocalizedString(@"onboarding/add_new_symptom")];
            else if(_searchType == SearchTags)
                [subtext setText:@"add tag"]; //TODO:Localized
                
            [title setText:[NSString stringWithFormat:@"\"%@\"", [result name]]];
        }
//    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
    
    //1 - TextField
    UITextField *textField = (UITextField *)[cell viewWithTag:1];
    textField.text = _searchText;
    textField.delegate = self;
    if(_editing)
        [textField becomeFirstResponder];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 63;
}

- (IBAction)selectItem:(UIButton *)sender
{
    UITableViewCell *cell = [self parentCellForView:sender];
    
    FDTrackableResult *result = _results[[[self.tableView indexPathForCell:cell] row]];
    NSString *title = [result name];
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    FDUser *user = [[FDModelManager sharedManager] userObject];
    NSMutableArray *questions = [entry questions];
    
    if(_searchType == SearchSymptoms) {
        NSInteger sectionToAdd = 0;
        NSInteger indexToAdd = 0;
        if(questions.count > 0) {
            sectionToAdd = [[questions lastObject] section]+1;
            indexToAdd = questions.count;
        }
        
        for(FDQuestion *question in [entry questions]) {
            if([[question catalog] isEqualToString:@"symptoms"]
               && [[question name] isEqualToString:title]) {
                [self closeSearch:sender];
                return;
            };
        }
        
        for (FDSymptom *userSymptom in [user symptoms]) {
            if([[userSymptom name] isEqualToString:title]) {
                FDQuestion *newQuestion = [[FDQuestion alloc] initWithSymptom:userSymptom section:sectionToAdd];
                [entry insertQuestion:newQuestion atIndex:indexToAdd];
                
                FDResponse *response = [[FDResponse alloc] initWithEntry:entry question:newQuestion];
                if(![entry responseForId:[response responseId]]) {
                    [[[FDModelManager sharedManager] entry] insertResponse:response];
                }
                
                [self closeSearch:sender];
                return;
            }
        }
            
        //Check the new symptom against the API for validation
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FDUser *user = [[FDModelManager sharedManager] userObject];
        [[FDNetworkManager sharedManager] createSymptomWithName:title email:[user email] authenticationToken:[user authenticationToken] completion:^ (bool success, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(success) {
                NSLog(@"Success!");
                
                FDSymptom *newSymptom = [[FDSymptom alloc] initWithTitle:title entry:entry];
                FDQuestion *newQuestion = [[FDQuestion alloc] initWithSymptom:newSymptom section:sectionToAdd];
                [entry insertQuestion:newQuestion atIndex:indexToAdd];
                
                [self closeSearch:sender];
            }
            else {
                NSLog(@"Failure!");
            
                [[[UIAlertView alloc] initWithTitle:FDLocalizedString(@"nice_errors/search_add_symptom_error")
                                            message:FDLocalizedString(@"nice_errors/search_add_symptom_error_description")
                                           delegate:nil
                                  cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                                  otherButtonTitles:nil] show];
            }
        }];
        
    } else if(_searchType == SearchTreatments) {
        FDEntry *entry = [[FDModelManager sharedManager] entry];
        
        for (FDTreatment *treatment in [entry treatments]) {
            if([[treatment name] isEqualToString:title]) {
                [self closeSearchWithTreatment:treatment];
                return;
            }
        }
        
        for (FDTreatment *userTreatment in [user treatments]) {
            if([[userTreatment name] isEqualToString:title]) {
                [self closeSearchWithTreatment:userTreatment];
                return;
            }
        }
            
        //Check the new symptom against the API for validation
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FDUser *user = [[FDModelManager sharedManager] userObject];
        [[FDNetworkManager sharedManager] createTreatmentWithName:title email:[user email] authenticationToken:[user authenticationToken] completion:^ (bool success, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(success) {
                NSLog(@"Success!");
                
                FDTreatment *selectedTreatment = [[FDTreatment alloc] init];
                [selectedTreatment setName:title];
                
                [self closeSearchWithTreatment:selectedTreatment];
            }
            else {
                NSLog(@"Failure!");
                
                [[[UIAlertView alloc] initWithTitle:FDLocalizedString(@"nice_errors/search_add_treatment_error")
                                            message:FDLocalizedString(@"nice_errors/search_add_treatment_error_description")
                                           delegate:nil
                                  cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                                  otherButtonTitles:nil] show];
            }
        }];
    } else if(_searchType == SearchConditions) {
        
        NSInteger indexToAdd = 0;
        NSInteger sectionToAdd = 0;
        if([entry questionsForCatalog:@"conditions"].count > 0) {
            indexToAdd = [questions indexOfObject:[entry questionsForCatalog:@"conditions"][[entry questionsForCatalog:@"conditions"].count-1]]+1;
            sectionToAdd = [[questions objectAtIndex:indexToAdd-1] section]+1;
        }
        
        for(FDQuestion *question in [entry questions]) {
            if([[question catalog] isEqualToString:@"conditions"]
               && [[question name] isEqualToString:title]) {
                [self closeSearch:sender];
                return;
            };
        }
        
        for (FDCondition *userCondition in [user conditions]) {
            if([[userCondition name] isEqualToString:title]) {
                FDQuestion *newQuestion = [[FDQuestion alloc] initWithCondition:userCondition section:sectionToAdd];
                [entry insertQuestion:newQuestion atIndex:indexToAdd];
                
                FDResponse *response = [[FDResponse alloc] initWithEntry:entry question:newQuestion];
                if(![entry responseForId:[response responseId]]) {
                    [[[FDModelManager sharedManager] entry] insertResponse:response];
                }
                
                [self closeSearch:sender];
                return;
            }
        }
        
        //Check the new condition against the API for validation
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FDUser *user = [[FDModelManager sharedManager] userObject];
        [[FDNetworkManager sharedManager] createConditionWithName:title email:[user email] authenticationToken:[user authenticationToken] completion:^ (bool success, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(success) {
                NSLog(@"Success!");
                
                FDCondition *newCondition = [[FDCondition alloc] initWithTitle:title entry:entry];
                FDQuestion *newQuestion = [[FDQuestion alloc] initWithCondition:newCondition section:sectionToAdd];
                [entry insertQuestion:newQuestion atIndex:indexToAdd];
                
                [self closeSearch:sender];
            }
            else {
                NSLog(@"Failure!");
                
                [[[UIAlertView alloc] initWithTitle:FDLocalizedString(@"nice_errors/search_add_condition_error")
                                            message:FDLocalizedString(@"nice_errors/search_add_condition_error_description")
                                           delegate:nil
                                  cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                                  otherButtonTitles:nil] show];
            }
        }];
    } else if(_searchType == SearchTags) {
        
        for(NSString *tag in [entry tags]) {
            if([tag isEqualToString:title]) {
                [self closeSearch:sender];
                return;
            }
        }
        
        //Check the new symptom against the API for validation
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FDUser *user = [[FDModelManager sharedManager] userObject];
        [[FDNetworkManager sharedManager] createConditionWithName:title email:[user email] authenticationToken:[user authenticationToken] completion:^ (bool success, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(success) {
                NSLog(@"Success!");
                
                NSString *newTag = title;
                [[entry tags] addObject:newTag];
                
                [self closeSearch:sender];
            }
            else {
                NSLog(@"Failure!");
                //TODO:Localized
                [[[UIAlertView alloc] initWithTitle:@"error with add tag"
                                            message:@"there was an error adding this tag"
                                           delegate:nil
                                  cancelButtonTitle:@"okayy"
                                  otherButtonTitles:nil] show];
            }
        }];
    }
}

- (IBAction)closeSearch:(id)sender
{
    [_mainViewDelegate refreshPages];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [_contentViewDelegate refreshEditList];
    }];
}

- (void)closeSearchWithTreatment:(FDTreatment *)treatment
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[FDPopupManager sharedManager] removeTopPopup];
        [_contentViewDelegate addTreatmentPopupWithTreatment:treatment];
    }];
}

-(UITableViewCell *)parentCellForView:(id)theView
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

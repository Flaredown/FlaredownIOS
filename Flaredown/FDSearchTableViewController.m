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
#import "FDTrackableResult.h"

@interface FDSearchTableViewController ()

@end

@implementation FDSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _results = [[NSMutableArray alloc] init];
    
//    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_contentViewDelegate editList];
}

- (void)performSearch
{
    if(_searchText.length == 0) {
        [_results removeAllObjects];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FDUser *user = [[FDModelManager sharedManager] userObject];
    [[FDNetworkManager sharedManager] searchTrackables:_searchText type:@"treatments" email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(success) {
            NSLog(@"Success!");
            
            NSArray *resultResponse = (NSArray *)responseObject;
            [_results removeAllObjects];
            for (NSDictionary *result in resultResponse) {
                FDTrackableResult *resultObject = [[FDTrackableResult alloc] initWithDictionary:result];
                [_results addObject:resultObject];
            }
        }
        else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retreiving results", nil)
                                        message:NSLocalizedString(@"We couldn't get your search results, please try again.", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil] show];
        }
        [self.tableView reloadData];
//        UITextField *searchField = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1];
//        [searchField becomeFirstResponder];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(_timer != nil)
        [_timer invalidate];
    
    _searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:SEARCH_DELAY target:self selector:@selector(performSearch) userInfo:nil repeats:NO];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0)
        return 1;
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if([indexPath section] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
        
        //1 - TextField
        UITextField *textField = (UITextField *)[cell viewWithTag:1];
        textField.delegate = self;
        [textField becomeFirstResponder];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
        
        FDTrackableResult *result = _results[[indexPath row]];
        
        //1 - Title
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        [title setText:[result name]];
        
        //2 - Subtext
        UILabel *subtext = (UILabel *)[cell viewWithTag:2];
        [subtext setText:[NSString stringWithFormat:@"%i", [result actives]]];
    }
    
    
    return cell;
}

- (IBAction)closeSearch:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

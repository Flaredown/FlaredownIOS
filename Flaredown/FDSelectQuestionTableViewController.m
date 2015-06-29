//
//  FDSelectQuestionTableViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 6/27/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSelectQuestionTableViewController.h"
#import "FDModelManager.h"

#import "FDLocalizationManager.h"
#import "FDStyle.h"

@interface FDSelectQuestionTableViewController ()

@end

@implementation FDSelectQuestionTableViewController

static NSString * const listeItemIdentifier = @"listItem";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
}

- (void)initWithQuestion:(FDQuestion *)question
{
    self.question = question;
    self.inputs = [question inputs];
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    
    self.response = [[FDResponse alloc] init];
    [self.response setResponseIdWithEntryId:[entry entryId] name:[self.question name]];
    if([entry responseForId:[self.response responseId]]) {
        self.response = [entry responseForId:[self.response responseId]];
        self.selectedIndex = self.response.value;
        if(self.response.value >= 0)
            self.itemSelected = YES;
    } else {
        self.response = [self.response initWithEntry:entry question:question];
        [[[FDModelManager sharedManager] entry] insertResponse:self.response];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.inputs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    FDInput *input = self.inputs[[indexPath row]];
    
    if(self.selectedIndex >= 0) {
        if([indexPath row] == self.selectedIndex)
            [self selectCell:cell];
        else
            [self deselectCell:cell];
    }
    
    NSString *labelText = [self.inputs[[indexPath row]] label];
    if(![labelText isEqual:[NSNull null]]) {
        UIButton *button = (UIButton *)[cell viewWithTag:1];
//        button.numberOfLines = 0;
        NSString *path = [NSString stringWithFormat:@"labels/%@", [self.inputs[[indexPath row]] label]];
        [button setTitle:FDLocalizedString(path) forState:UIControlStateNormal];
    }
    
    [self setCellAppearance:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.itemSelected = YES;
    
    NSInteger rows = [tableView numberOfRowsInSection:0];
    for(int i = 0; i < rows; i++) {
        [self deselectCell:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:cell];
}

- (void)selectCell:(UITableViewCell *)cell
{
    [cell setSelected:YES];
    
    [self setCellAppearance:cell];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = [indexPath row];
    FDInput *input = self.inputs[row];
    [self.response setValue:[input value]];
    self.selectedIndex = self.response.value;
}

- (void)deselectCell:(UITableViewCell *)cell
{
    [cell setSelected:NO];
    
    [self setCellAppearance:cell];
}

- (void)setCellAppearance:(UITableViewCell *)cell
{
    if(cell.selected) {
        [cell setBackgroundColor:[FDStyle blueColor]];
    } else {
        [cell setBackgroundColor:[FDStyle lightGreyColor]];
    }
}

@end

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

static NSString * const listItemIdentifier = @"listItem";

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
    [self.response setResponseIdWithCatalog:[self.question catalog] entryId:[entry entryId] name:[self.question name]];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listItemIdentifier forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    
    NSString *labelText = [self.inputs[[indexPath row]] label];
    if(![labelText isEqual:[NSNull null]]) {
        UIButton *button = (UIButton *)[cell viewWithTag:1];
//        button.numberOfLines = 0;
        NSString *path = [NSString stringWithFormat:@"labels/%@", [self.inputs[[indexPath row]] label]];
        [button setTitle:FDLocalizedString(path) forState:UIControlStateNormal];
    }
    
    [self setCellAppearance:cell selected:(row == self.selectedIndex)];
    
    return cell;
}

- (IBAction)listItemButton:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)[self parentCellForView:sender];
    [self selectCell:cell];
}

- (void)selectCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = [indexPath row];
    FDInput *input = self.inputs[row];
    [self.response setValue:[input value]];
    self.selectedIndex = (int)row;
    [self.tableView reloadData];
    [_mainViewDelegate nextQuestion];
}

- (void)setCellAppearance:(UITableViewCell *)cell selected:(BOOL)selected
{
    //1 Button
    UIButton *button = (UIButton *)[cell viewWithTag:1];
    if(selected) {
        [button setBackgroundColor:[FDStyle blueColor]];
        [button setTitleColor:[FDStyle whiteColor] forState:UIControlStateNormal];
    } else {
        [button setBackgroundColor:[FDStyle lightGreyColor]];
        [button setTitleColor:[FDStyle greyColor] forState:UIControlStateNormal];
    }
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

@end

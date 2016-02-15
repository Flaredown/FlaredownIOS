//
//  FDMeterTableViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 1/11/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import "FDMeterTableViewController.h"

#import "FDMeterTableViewCell.h"

#import "FDModelManager.h"
#import "FDQuestion.h"

@interface FDMeterTableViewController ()

@end

@implementation FDMeterTableViewController

static NSString * const MeterCell = @"meter";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _questions = [[NSArray alloc] init];
    _responses = [[NSMutableArray alloc] init];
}

- (void)initWithQuestions:(NSArray *)questions
{
    _questions = questions;
    _responses = [[NSMutableArray alloc] init];
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    for (int row = 0; row < questions.count; row++) {
        FDQuestion *question = questions[row];
        FDResponse *response = [[FDResponse alloc] init];
        [response setResponseIdWithCatalog:[question catalog] entryId:[entry entryId] name:[question name]];
        
        if([entry responseForId:[response responseId]]) {
            response = [entry responseForId:[response responseId]];
//            [self selectButton:[response value] forRow:row];
        } else {
            response = [response initWithEntry:entry question:question];
            [entry insertResponse:response];
        }
        [_responses addObject:response];
    }
    [self.tableView reloadData];
}

- (void)setResponseValue:(NSInteger)value sender:(id)sender
{
    UITableViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    FDResponse *response = _responses[[indexPath row]];
    [response setValue:(int)value];
    [self.tableView reloadData];
}

- (IBAction)firstButton:(id)sender
{
    [self setResponseValue:0 sender:sender];
}

- (IBAction)secondButton:(id)sender
{
    [self setResponseValue:1 sender:sender];
}

- (IBAction)thirdButton:(id)sender
{
    [self setResponseValue:2 sender:sender];
}

- (IBAction)fourthButton:(id)sender
{
    [self setResponseValue:3 sender:sender];
}

- (IBAction)fifthButton:(id)sender
{
    [self setResponseValue:4 sender:sender];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger row = [indexPath row];
    
    //meter cell
    cell = [self.tableView dequeueReusableCellWithIdentifier:MeterCell];
    
    FDMeterTableViewCell *meterCell = (FDMeterTableViewCell *)cell;
    
    FDQuestion *question = _questions[row];
    FDResponse *response = _responses[row];
    [meterCell initWithQuestion:question response:response];
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _questions.count;
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

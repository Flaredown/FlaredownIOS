//
//  FDEmbeddedSelectListViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/23/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDEmbeddedSelectListViewController.h"

#import "FDPopupManager.h"
#import "FDStyle.h"

@interface FDEmbeddedSelectListViewController ()

@end

@implementation FDEmbeddedSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FDStyle addCellRoundedCornersToView:_doneButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender
{
    [[FDPopupManager sharedManager] removeTopPopup];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _listController = (FDSelectListViewController *)segue.destinationViewController;
}

@end

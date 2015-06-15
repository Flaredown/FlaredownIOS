//
//  FDSettingsViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 6/15/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSettingsViewController.h"

#import "FDStyle.h"

@interface FDSettingsViewController ()

@end

@implementation FDSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [FDStyle addRoundedCornersToView:_reminderView];
    [FDStyle addShadowToView:_reminderView];
    
    [FDStyle addRoundedCornersToView:_accountView];
    [FDStyle addShadowToView:_accountView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

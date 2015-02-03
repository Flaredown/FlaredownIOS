//
//  FDFinishedViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDFinishedViewController.h"
#import "FDModelManager.h"
#import "FDUser.h"

@interface FDFinishedViewController ()

@end

@implementation FDFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)siteButton:(id)sender
{
    FDUser *user = [[FDModelManager sharedManager] userObject];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://staging.flaredown.com/login?user_email=%@&user_token=%@", [user email], [user authenticationToken]]];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
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

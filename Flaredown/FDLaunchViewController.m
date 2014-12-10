//
//  FDLaunchViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDLaunchViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import "MBProgressHUD.h"

@interface FDLaunchViewController ()

@end

@implementation FDLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(![[FDModelManager sharedManager] userObject]) {
       [self performSegueWithIdentifier:@"login" sender:self];
        return;
    }
    
    if([[FDModelManager sharedManager] entry]) {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM-dd-yyyy"];
        NSDate *date = [dateFormat dateFromString:[[[FDModelManager sharedManager] entry] date]];
        NSDate *now = [NSDate date];
        if([now compare:date] == NSOrderedDescending) {
            [[FDModelManager sharedManager] clearCurrentEntry];
        }
    }
    
    if([[FDModelManager sharedManager] entry]) {
        _entryLoaded = YES;
    } else {
        NSLog(@"New entry");
        _entryLoaded = NO;
        
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM-dd-yyyy"];
        NSString *dateString = [formatter stringFromDate:now];
        
        FDUser *user = [[FDModelManager sharedManager] userObject];
        [[FDNetworkManager sharedManager] createEntryWithEmail:[user email] authenticationToken:[user authenticationToken] date:dateString completion:^(bool success, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(success) {
                NSLog(@"Success!");
                
                [[FDModelManager sharedManager] setEntry:[[FDEntry alloc] initWithDictionary:[responseObject objectForKey:@"entry"]]];
                
                NSMutableArray *mutableInputs = [[NSMutableArray alloc] init];
                for (NSDictionary *input in [responseObject objectForKey:@"inputs"]) {
                    [mutableInputs addObject:[[FDInput alloc] initWithDictionary:input]];
                }
                [[FDModelManager sharedManager] setInputs:[mutableInputs copy]];
                
                if(_segueReady)
                    [self performSegueWithIdentifier:@"start" sender:self];
            }
            else {
                NSLog(@"Failure!");
                
                [[[UIAlertView alloc] initWithTitle:@"Error retreiving entry"
                                            message:@"Looks like there was a problem retreiving your entry, please try again."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
            _entryLoaded = YES;
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(!_entryLoaded) {
        _segueReady = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        return NO;
    }
    return YES;
}

@end

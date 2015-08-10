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
#import <MBProgressHUD/MBProgressHUD.h>
#import "FDStyle.h"
#import "FDPopupManager.h"
#import "FDLocalizationManager.h"
#import "FDSummaryCollectionViewController.h"
#import "FDViewController.h"

@interface FDLaunchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *checkedInLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinButtonLabel;

@end

@implementation FDLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Localized start button
    [_startButton setImage:[UIImage imageNamed:NSLocalizedString(@"fd_startBtn", nil)] forState:UIControlStateNormal];
    [_checkedInLabel setText:FDLocalizedString(@"you_havent_checked_in_yet")];
    [_checkinButtonLabel setText:FDLocalizedString(@"onboarding/checkin")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Localized date
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:now];
    [_dateLabel setText:dateString];
    
    if([[FDModelManager sharedManager] entry]) {
        // Convert string to date object
        NSDate *date = [FDStyle dateFromString:[[[FDModelManager sharedManager] entry] date]];
        NSDate *now = [NSDate date];
        if([now compare:date] == NSOrderedDescending) {
            [[FDModelManager sharedManager] entry];
        }
    }
    
    if(![[FDModelManager sharedManager] userObject]) {
        [self performSegueWithIdentifier:@"login" sender:self];
        return;
    }
    
    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    [[FDNetworkManager sharedManager] createEntryWithEmail:[user email] authenticationToken:[user authenticationToken] date:dateString completion:^(bool success, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            NSLog(@"Success!");
            
            FDEntry *entry = [[FDEntry alloc] initWithDictionary:[responseObject objectForKey:@"entry"]];
            if(![[FDModelManager sharedManager] entry] || [[entry updatedAt] compare:[[[FDModelManager sharedManager] entry] updatedAt]] == NSOrderedDescending) {
                
                NSLog(@"New entry");
                _entryLoaded = NO;
                _entryPreloaded = NO;
                
                [[FDModelManager sharedManager] setEntry:entry forDate:now];
                [[FDModelManager sharedManager] setSelectedDate:now];
                
                for (NSDictionary *input in [responseObject objectForKey:@"inputs"]) {
                    [[FDModelManager sharedManager] addInput:[[FDInput alloc] initWithDictionary:input]];
                }
                
                if(_segueReady)
                    [self performSegueWithIdentifier:@"start" sender:nil];
            } else {
                _entryLoaded = YES;
                _entryPreloaded = YES;
                [self performSegueWithIdentifier:@"start" sender:nil];
            }
        } else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retreiving entry", nil)
                                        message:NSLocalizedString(@"Looks like there was a problem retreiving your entry, please try again.", nil)
                                       delegate:nil
                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                              otherButtonTitles:nil] show];
        }
        _entryLoaded = YES;
    }];
        
    [[FDNetworkManager sharedManager] getLocale:[[FDLocalizationManager sharedManager] currentLocale] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id response) {
        if(success) {
            NSLog(@"Success!");
            
            [[FDLocalizationManager sharedManager] setLocalizationDictionaryForCurrentLocale:response];
        } else {
            NSLog(@"Failure!");
        }
    }];
}

- (IBAction)checkinButton:(id)sender
{
    if(!_entryLoaded) {
        _segueReady = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        return;
    }
    [self performSegueWithIdentifier:@"start" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"start"]) {
        FDViewController *dvc = (FDViewController *)segue.destinationViewController;
        if(_entryPreloaded) {
            dvc.loadSummary = YES;
        } else {
            dvc.loadSummary = NO;
        }
    }
}

@end

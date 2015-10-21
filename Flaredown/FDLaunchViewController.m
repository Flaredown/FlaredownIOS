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

@end

@implementation FDLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Localized start button
    [_checkedInLabel setText:FDLocalizedString(@"you_havent_checked_in_yet")];
    [_startButton setTitle:FDLocalizedString(@"onboarding/checkin") forState:UIControlStateNormal];
    
    [FDStyle addRoundedCornersToView:_startButton];
    [FDStyle addShadowToView:_startButton];
}

- (IBAction)checkinButton:(id)sender
{
    [_mainViewDelegate launch];
}

@end

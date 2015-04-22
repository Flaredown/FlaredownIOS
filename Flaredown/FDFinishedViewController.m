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

#import "FDLocalizationManager.h"

@interface FDFinishedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeYourGraphLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;

@end

@implementation FDFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_seeYourGraphLabel setText:FDLocalizedString(@"see_your_graph")];
    [_doneLabel setText:FDLocalizedString(@"all_done")];
    
    [_siteLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"flaredown.com" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}]];
    
    //Localized date
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:now];
    [_dateLabel setText:dateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)siteButton:(id)sender
{
    FDUser *user = [[FDModelManager sharedManager] userObject];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://staging.flaredown.com/login?user_email=%@&user_token=%@", [user email], [user authenticationToken]]];
    
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

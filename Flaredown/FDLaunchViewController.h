//
//  FDLaunchViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDLaunchViewController : UIViewController

@property BOOL entryLoaded;
@property BOOL segueReady;
@property BOOL reminderOn;
@property NSDate *reminderTime;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *alarmButton;

@property UIView *alarmView;
@property UIView *backgroundView;

@end

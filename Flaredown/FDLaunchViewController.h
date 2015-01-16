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

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

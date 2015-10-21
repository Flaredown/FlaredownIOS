//
//  FDLaunchViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDViewController.h"

@interface FDLaunchViewController : UIViewController

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property UIView *backgroundView;

@end

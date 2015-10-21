//
//  FDLoginViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDViewController.h"

@interface FDLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIView *loginCard;
@property BOOL cardBumped;

@end

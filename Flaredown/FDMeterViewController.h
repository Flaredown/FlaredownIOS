//
//  FDMeterViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/30/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDQuestion.h"
#import "FDResponse.h"

#import "FDViewController.h"

@interface FDMeterViewController : UIViewController

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property FDQuestion *question;
@property FDResponse *response;
@property NSArray *inputs;

- (void)initWithQuestion:(FDQuestion *)question;

@end

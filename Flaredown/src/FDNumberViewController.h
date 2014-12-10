//
//  FDNumberViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/29/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDModelManager.h"

@interface FDNumberViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) NSDictionary *pageInfo;
@property FDQuestion *question;
@property FDResponse *response;

@property int mainNumber;
@property int maxNumber;
@property int minNumber;

- (void)initWithQuestion:(FDQuestion *)question;

@end

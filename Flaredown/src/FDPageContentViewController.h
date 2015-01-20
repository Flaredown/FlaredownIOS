//
//  FDPageContentViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ContainerEmbedSegueIdentifier @"containerEmbedSegue"
#define EditListSegueIdentifier @"editList"

@interface FDPageContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//Subtite or edit button
@property (weak, nonatomic) IBOutlet UIButton *secondaryTitleButton;

@property int pageIndex;
@property BOOL editSegueTreatments;

@end

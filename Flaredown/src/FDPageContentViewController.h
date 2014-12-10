//
//  FDPageContentViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ContainerEmbedSegueIdentifier @"containerEmbedSegue"

@interface FDPageContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property int pageIndex;

@end

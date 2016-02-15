//
//  FDMeterTableViewController.h
//  ;
//
//  Created by Cole Cunningham on 1/11/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDMeterTableViewController : UITableViewController

@property NSArray *questions;
@property NSMutableArray *responses;

- (void)initWithQuestions:(NSArray *)questions;

@end

//
//  FDSelectListViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDModelManager.h"

@interface FDSelectListViewController : UITableViewController <UIAlertViewDelegate>

@property NSArray *questions;
@property NSMutableArray *responses;
@property NSMutableArray *selectedItems;
@property BOOL dynamic;
@property int removeIndex;

- (void)initWithQuestions:(NSArray *)questions;

@end

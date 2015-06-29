//
//  FDSelectQuestionTableViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 6/27/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDQuestion;
@class FDResponse;

@interface FDSelectQuestionTableViewController : UITableViewController

@property FDQuestion *question;
@property FDResponse *response;
@property NSArray *inputs;

@property BOOL itemSelected;
@property int selectedIndex;

- (void)initWithQuestion:(FDQuestion *)question;

@end

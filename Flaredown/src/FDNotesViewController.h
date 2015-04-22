//
//  FDNotesViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 10/2/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDViewController.h"

@interface FDNotesViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;
//@property (nonatomic, weak) id <FDPageContentViewControllerDelegate> contentViewDelegate;

- (void)keyboardWasShown:(NSNotification *)notification;
- (void)keyboardWasHidden:(NSNotification *)notification;

@end

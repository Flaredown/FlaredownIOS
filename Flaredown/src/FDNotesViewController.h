//
//  FDNotesViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 10/2/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDNotesViewController : UIViewController <UITextViewDelegate>

- (void)keyboardWasShown:(NSNotification *)notification;
- (void)keyboardWasHidden:(NSNotification *)notification;

@end

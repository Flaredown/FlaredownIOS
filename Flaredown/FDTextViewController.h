//
//  FDTextViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 8/14/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDTextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property NSString *text;

@end

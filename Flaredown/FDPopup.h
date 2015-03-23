//
//  FDPopup.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/23/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FDPopup : NSObject

@property UIView *view;
@property UIView *backgroundView;

@property UIViewController *viewController;

- (id)initWithView:(UIView *)view background:(UIView *)backgroundView;
- (id)initWithView:(UIView *)view background:(UIView *)backgroundView viewController:(UIViewController *)viewController;

@end

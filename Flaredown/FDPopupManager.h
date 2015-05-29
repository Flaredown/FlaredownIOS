//
//  FDPopupManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/23/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FDPopup.h"

//relative to screen
#define POPUP_WIDTH 0.95
#define POPUP_HEIGHT 0.5

#define POPUP_KEYBOARD_OFFSET 120

@interface FDPopupManager : NSObject

@property NSMutableArray *popups;

+ (id)sharedManager;

- (void)addPopupView:(UIView *)popupView;
- (void)addPopupView:(UIView *)popupView withViewController:(UIViewController *)viewController;
- (FDPopup *)topPopup;
- (void)removeTopPopup;
- (void)removeAllPopups;

@end

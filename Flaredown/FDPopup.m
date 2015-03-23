//
//  FDPopup.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/23/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDPopup.h"

@implementation FDPopup

- (id)initWithView:(UIView *)view background:(UIView *)backgroundView
{
    if(self = [super init]) {
        _view = view;
        _backgroundView = backgroundView;
    }
    return self;
}

- (id)initWithView:(UIView *)view background:(UIView *)backgroundView viewController:(UIViewController *)viewController
{
    FDPopup *popup = [self initWithView:view background:backgroundView];
    popup.viewController = viewController;
    return popup;
}

@end

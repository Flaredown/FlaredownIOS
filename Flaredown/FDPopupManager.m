//
//  FDPopupManager.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/23/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDPopupManager.h"

@implementation FDPopupManager

+ (id)sharedManager
{
    static FDPopupManager *sharedPopupManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPopupManager = [[self alloc] init];
    });
    return sharedPopupManager;
}

- (id)init
{
    if(self = [super init]) {
        _popups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addPopupView:(UIView *)popupView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIButton *backgroundView = [[UIButton alloc] initWithFrame:window.frame];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [backgroundView setAlpha:0.26];
    [backgroundView addTarget:self action:@selector(removeTopPopup) forControlEvents:UIControlEventTouchUpInside];
    [_popups insertObject:[[FDPopup alloc] initWithView:popupView background:backgroundView] atIndex:0];
    
    [UIView transitionWithView:window duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ {
                        [window addSubview:backgroundView];
                        [window addSubview:popupView];
                    }
                    completion:^(BOOL success){
                        if(!success)
                            return;
//                        popupView.translatesAutoresizingMaskIntoConstraints = NO;
//                        NSDictionary *viewsDictionary = @{@"popupView":popupView};
//                        NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[popupView(%f)]", popupView.frame.size.width]
//                                                                                        options:0
//                                                                                        metrics:nil
//                                                                                          views:viewsDictionary];
//                        NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[popupView(%f)]", popupView.frame.size.height]
//                                                                                        options:0
//                                                                                        metrics:nil
//                                                                                          views:viewsDictionary];
//                        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[popupView]", popupView.frame.origin.x]
//                                                                                            options:0                           metrics:nil                      views:viewsDictionary];
//                        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[popupView]", popupView.frame.origin.y]
//                                                                                            options:0                           metrics:nil                      views:viewsDictionary];
//                        [popupView addConstraints:constraint_H];
//                        [popupView addConstraints:constraint_V];
//                        [popupView addConstraints:constraint_POS_H];
//                        [popupView addConstraints:constraint_POS_V];
                    }];
}

- (void)addPopupView:(UIView *)popupView withViewController:(UIViewController *)viewController
{
    [self addPopupView:popupView];
    [_popups[0] setViewController:viewController];
}

- (FDPopup *)topPopup
{
    return [_popups firstObject];
}

- (void)removeTopPopup
{
    if(_popups.count > 0) {
        FDPopup *popup = _popups[0];
        [UIView transitionWithView:popup.view.superview duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ {
                            [popup.view removeFromSuperview];
                            [popup.backgroundView removeFromSuperview];
                        }
                        completion:nil];
        [_popups removeObjectAtIndex:0];
    } else {
        NSLog(@"No popups to remove");
    }
}

- (void)removeAllPopups
{
    while(_popups.count > 0) {
        [[_popups[0] view] removeFromSuperview];
        [[_popups[0] backgroundView] removeFromSuperview];
        [_popups removeObjectAtIndex:0];
    }
}

@end

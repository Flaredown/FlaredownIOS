//
//  FDNotesViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/2/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDNotesViewController.h"
#import "FDModelManager.h"

#import "FDHashtagTextView.h"

@interface FDNotesViewController ()

@property (weak, nonatomic) IBOutlet UIView *textViewContainer;

@property (strong, nonatomic) FDHashtagTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;

@property CGFloat keyboardOffset;

@end

@implementation FDNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // attach textView
    self.textView = [[FDHashtagTextView alloc] initWithFrame:self.textViewContainer.bounds];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.textViewContainer addSubview:self.textView];
    [self.textViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(_textView)]];
    [self.textViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(_textView)]];

    // TODO: use theming properties
    self.textView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.f];
    
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;

    //Set up keyboard listeners
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.textView.text = [[[FDModelManager sharedManager] entry] notes];

#if 0
    self.textView.text = @"#Lorem ipsum dolor #sit er elit #la!met, consec#tetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
#endif
}

- (IBAction)cancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[[FDModelManager sharedManager] entry] setNotes:self.textView.text];
    [_mainViewDelegate refreshSummary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    //Hashtag stuff here
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint textViewY2 = CGPointMake(self.textView.frame.origin.x, self.textView.frame.origin.y+self.textView.frame.size.height);
    CGFloat absY2 = [self.textView.superview convertPoint:textViewY2 toView:nil].y;
    CGFloat keyboardY = [UIApplication sharedApplication].keyWindow.frame.size.height - keyboardSize.height;
    self.keyboardOffset = absY2 - keyboardY;
    
//    self.textViewBottomConstraint.constant += self.keyboardOffset;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
//    [self.mainViewDelegate toggleCardBumped];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
//    self.textViewBottomConstraint.constant -= self.keyboardOffset;
    
     NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
//    [[[FDModelManager sharedManager] entry] setNotes:self.textView.text];
    
//    [self.mainViewDelegate toggleCardBumped];
}

@end

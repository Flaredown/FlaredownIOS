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

    
    //Set up keyboard listeners
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    self.textView.text = [[[FDModelManager sharedManager] entry] notes];

#if 0
    self.textView.text = @"#Lorem ipsum dolor #sit er elit #la!met, consec#tetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    //Hashtag stuff here
}

- (void)keyboardWasShown:(NSNotification *)notification
{
//    NSDictionary *info = [notification userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
//    NSDictionary *info = [notification userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height + keyboardSize.height);
    [[[FDModelManager sharedManager] entry] setNotes:self.textView.text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

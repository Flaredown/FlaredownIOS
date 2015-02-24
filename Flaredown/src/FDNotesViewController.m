//
//  FDNotesViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/2/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDNotesViewController.h"
#import "FDModelManager.h"

@interface FDNotesViewController ()

@end

@implementation FDNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
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

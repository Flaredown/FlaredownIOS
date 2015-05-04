//
//  FDLoginViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 11/10/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDLoginViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import "FDStyle.h"
#import "FDLocalizationManager.h"

#define CARD_BUMP_OFFSET 100

@interface FDLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *loginTitle;
@property (weak, nonatomic) IBOutlet UIView *logoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginCardYConstraint;

@end

@implementation FDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    
    [_emailTextField setDelegate:self];
    [_passwordTextField setDelegate:self];
    
    [FDStyle addRoundedCornersToView:_loginCard];
    [FDStyle addRoundedCornersToView:_loginBtn];
    
    [FDStyle addShadowToView:_loginCard];
    _loginCard.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_loginCard];
    
    [FDStyle addShadowToView:_loginBtn];
    _loginBtn.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_loginBtn];
    
    [_loginBtn setTitle:FDLocalizedString(@"unauthenticated/login") forState:UIControlStateNormal];
    
    [_loginTitle setText:FDLocalizedString(@"unauthenticated/login")];
    
    [_forgotPasswordButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Forgot password?", nil) attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:[FDStyle indianKhakiColor]}] forState:UIControlStateNormal];
    
    self.emailTextField.placeholder = FDLocalizedString(@"unauthenticated/email");
    self.passwordTextField.placeholder = FDLocalizedString(@"unauthenticated/password");

#if DEBUG
    self.emailTextField.text = @"test@flaredown.com";
    self.passwordTextField.text = @"testing123";
#endif
}

- (void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    float keyboardY = keyboardFrame.origin.y;
    
    float y2 = [_passwordTextField.superview convertPoint:_passwordTextField.frame.origin toView:nil].y + _passwordTextField.frame.size.height;
    if(y2 < keyboardY) {
        return;
    }
    
    [self toggleCardBumped];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender
{
    NSString *emailStr = FDLocalizedString(@"unauthenticated/email");
    NSString *passwordStr = FDLocalizedString(@"unauthenticated/password");
    NSString *doneStr = FDLocalizedString(@"nav/done");
    
    if([[_emailTextField text] length] == 0) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:FDLocalizedString(@"nice_errors/field_required"), emailStr]
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:doneStr
                          otherButtonTitles:nil] show];
    } else if(![self stringIsValidEmail:[_emailTextField text]]) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:FDLocalizedString(@"nice_errors/field_invalid"), emailStr]
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:doneStr
                          otherButtonTitles:nil] show];
    } else if([[_passwordTextField text] length] == 0) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:FDLocalizedString(@"nice_errors/field_invalid"), passwordStr]
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:doneStr
                          otherButtonTitles:nil] show];
    } else {
        
        //Log in user
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[FDNetworkManager sharedManager] loginUserWithEmail:[_emailTextField text] password:[_passwordTextField text] completion:^(bool success, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(success) {
                [[FDModelManager sharedManager] setUserObject:[[FDUser alloc] initWithDictionary:(NSDictionary *)responseObject]];
                NSLog(@"Success!");
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                NSLog(@"Failure!");
                
                [[[UIAlertView alloc] initWithTitle:FDLocalizedString(@"nice_errors/bad_credentials")
                                            message:FDLocalizedString(@"nice_errors/bad_credentials_description")
                                           delegate:nil
                                  cancelButtonTitle:doneStr
                                  otherButtonTitles:nil] show];
            }
        }];
    }
}

- (BOOL)stringIsValidEmail:(NSString *)checkString
{
    NSString *emailRegex = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_cardBumped)
        [self toggleCardBumped];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Closes keyboard when clicked off
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)forgotPasswordButton:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://staging.flaredown.com/reset-your-password"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }

}

- (void)toggleCardBumped
{
    CGRect frame = _loginCard.frame;
    
    CGRect newFrame;
    _loginCard.translatesAutoresizingMaskIntoConstraints = YES;
    _logoContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    if(_cardBumped) {
        newFrame = CGRectMake(frame.origin.x, frame.origin.y + CARD_BUMP_OFFSET, frame.size.width, frame.size.height);
    } else {
        newFrame = CGRectMake(frame.origin.x, frame.origin.y - CARD_BUMP_OFFSET, frame.size.width, frame.size.height);
    }
    [UIView animateWithDuration:0.3 animations:^ {
       [_loginCard setFrame:newFrame];
    }];
    _cardBumped = !_cardBumped;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

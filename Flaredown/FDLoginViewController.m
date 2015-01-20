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

@interface FDLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginCard;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation FDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_emailTextField setDelegate:self];
    [_passwordTextField setDelegate:self];
    
    _loginCard.layer.cornerRadius = 8;
    _loginBtn.layer.cornerRadius = 8;
    
    _loginCard.layer.shadowColor = [[UIColor blackColor] CGColor];
    _loginCard.layer.shadowOpacity = 0.1;
    _loginCard.layer.shadowRadius = 0;
    _loginCard.layer.shadowOffset = CGSizeMake(0, 4);
    _loginCard.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_loginCard];
    
    _loginBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
    _loginBtn.layer.shadowOpacity = 0.1;
    _loginBtn.layer.shadowRadius = 0;
    _loginBtn.layer.shadowOffset = CGSizeMake(0, 4);
    _loginBtn.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_loginBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender
{
    if([[_emailTextField text] length] == 0 || ![self stringIsValidEmail:[_emailTextField text]]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid email", nil)
                                    message:NSLocalizedString(@"Please enter a valid email", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    } else if([[_passwordTextField text] length] == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid password", nil)
                                    message:NSLocalizedString(@"Please enter a valid password", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
                
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error logging in", nil)
                                            message:NSLocalizedString(@"Invalid email and/or password, please try again.", nil)
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self dismissKeyboard];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

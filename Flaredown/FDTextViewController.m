//
//  FDTextViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 8/14/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTextViewController.h"

@interface FDTextViewController ()

@end

@implementation FDTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSAttributedString *attributedString =
        [[NSAttributedString alloc] initWithData:[_text dataUsingEncoding:NSUnicodeStringEncoding]
                                         options:@{
                                                   NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType
                                                   }
                              documentAttributes:nil error:nil];
    _textView.attributedText = attributedString;
    
//    [_textView setText:_text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

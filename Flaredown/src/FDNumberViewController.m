//
//  FDNumberViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/29/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDNumberViewController.h"

@interface FDNumberViewController ()

@end

@implementation FDNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxNumber = 1000;
    self.minNumber = 0;
}

- (void)initWithQuestion:(FDQuestion *)question
{
    self.question = question;
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];

    self.response = [[FDResponse alloc] init];
    [self.response setResponseIdWithEntryId:[entry entryId] name:[self.question name]];
    
    if([entry responseForId:[self.response responseId]]) {
        self.response = [entry responseForId:[self.response responseId]];
        self.mainNumber = [self.response value];
    } else {
        FDInput *input = [self.question inputs][0];
        self.mainNumber = [input value];
        
        [self.response setName:[question name]];
        [self.response setValue:self.mainNumber];
        [self.response setCatalog:[question catalog]];
        [[[FDModelManager sharedManager] entry] insertResponse:self.response];
    }
    
    [self setNumber:self.mainNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sets label text to target number
- (void)setNumber:(int)num
{
    self.numberLabel.text = [NSString stringWithFormat:@"%i", self.mainNumber];
    [self.response setValue:self.mainNumber];
}

// Up button
- (IBAction)numberUpButton:(id)sender
{
    if(self.mainNumber >= self.maxNumber)
        return;
    
    self.mainNumber++;
    [self setNumber:self.mainNumber];
}

// Down button
- (IBAction)numberDownButton:(id)sender
{
    if(self.mainNumber <= self.minNumber)
        return;
    
    self.mainNumber--;
    [self setNumber:self.mainNumber];
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

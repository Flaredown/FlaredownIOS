//
//  FDMeterViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/30/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDMeterViewController.h"

#import "FDModelManager.h"
#import "FDStyle.h"

#import "FDLocalizationManager.h"

@interface FDMeterViewController ()

@end

static UIColor *SelectedColor;
static UIColor *DeselectedColor;

@implementation FDMeterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SelectedColor = [FDStyle blueColor];
    DeselectedColor = [FDStyle mediumGreyColor];
    
    _firstButton.layer.cornerRadius = 20.0;
    [FDStyle addSmallRoundedCornersToView:_secondButton];
    [FDStyle addSmallRoundedCornersToView:_thirdButton];
    [FDStyle addSmallRoundedCornersToView:_fourthButton];
    [FDStyle addSmallRoundedCornersToView:_fifthButton];
}

- (void)initWithQuestion:(FDQuestion *)question
{
    self.question = question;
    self.inputs = [question inputs];
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    
    self.response = [[FDResponse alloc] init];
    [self.response setResponseIdWithEntryId:[entry entryId] name:[self.question name]];
    if([entry responseForId:[self.response responseId]]) {
        self.response = [entry responseForId:[self.response responseId]];
        
        switch(self.response.value) {
            case 0:
                [self firstButtonPress:nil];
                break;
            case 1:
                [self secondButtonPress:nil];
                break;
            case 2:
                [self thirdButtonPress:nil];
                break;
            case 3:
                [self fourthButtonPress:nil];
                break;
            case 4:
                [self fifthButtonPress:nil];
                break;
            default:
                break;
        }
    } else {
        self.response = [self.response initWithEntry:entry question:question];
        [[[FDModelManager sharedManager] entry] insertResponse:self.response];
    }
}

- (void)clearSelection
{
    [self setDeselectedColor:_firstButton];
    [self setDeselectedColor:_secondButton];
    [self setDeselectedColor:_thirdButton];
    [self setDeselectedColor:_fourthButton];
    [self setDeselectedColor:_fifthButton];
}

- (void)setSelectedValue:(int)buttonIndex
{
    FDInput *input = _inputs[buttonIndex];
//    NSString *title = [input metaLabel];
    
    NSString *title = @"";
    if(buttonIndex == 0) {
        title = FDLocalizedString(@"helpers/basic_0");
    } else if(buttonIndex == 1) {
        title = FDLocalizedString(@"helpers/basic_1");
    } else if(buttonIndex == 2) {
        title = FDLocalizedString(@"helpers/basic_2");
    } else if(buttonIndex == 3) {
        title = FDLocalizedString(@"helpers/basic_3");
    } else if(buttonIndex == 4) {
        title = FDLocalizedString(@"helpers/basic_4");
    }
    [_descriptionLabel setText:NSLocalizedString(title, nil)];
    
//    if(![title isEqual:[NSNull null]]) {
//        [_descriptionLabel setText:title];
//    } else {
//        [_descriptionLabel setText:@""];
//        NSLog(@"Invalid meta label for input %i", buttonIndex);
//    }
    [self.response setValue:[input value]];
}

- (IBAction)firstButtonPress:(id)sender
{
    [self clearSelection];
    [self selectFirst];
    [self setSelectedValue:0];
}

- (void)selectFirst
{
    [self setSelectedColor:_firstButton];
}

- (IBAction)secondButtonPress:(id)sender
{
    [self clearSelection];
    [self selectSecond];
    [self setSelectedValue:1];
}

- (void)selectSecond
{
    [self setSelectedColor:_secondButton];
}

- (IBAction)thirdButtonPress:(id)sender
{
    [self clearSelection];
    [self selectThird];
    [self setSelectedValue:2];
}

- (void)selectThird
{
    [self selectSecond];
    [self setSelectedColor:_thirdButton];
}

- (IBAction)fourthButtonPress:(id)sender
{
    [self clearSelection];
    [self selectFourth];
    [self setSelectedValue:3];
}

- (void)selectFourth
{
    [self selectThird];
    [self setSelectedColor:_fourthButton];
}

- (IBAction)fifthButtonPress:(id)sender
{
    [self clearSelection];
    [self selectFifth];
    [self setSelectedValue:4];
}

- (void)selectFifth
{
    [self selectFourth];
    [self setSelectedColor:_fifthButton];
}

- (void)setSelectedColor:(UIButton *)button
{
    [button setBackgroundColor:SelectedColor];
}

- (void)setDeselectedColor:(UIButton *)button
{
    [button setBackgroundColor:DeselectedColor];
}

@end

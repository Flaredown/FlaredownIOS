//
//  FDMeterTableViewCell.m
//  Flaredown
//
//  Created by Cole Cunningham on 1/11/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import "FDMeterTableViewCell.h"

#import "FDStyle.h"
#import "FDLocalizationManager.h"

@implementation FDMeterTableViewCell

static UIColor *SelectedColor;
static UIColor *DeselectedColor;

- (void)prepareForReuse
{
    [self clearSelection];
}

- (void)awakeFromNib
{
    SelectedColor = [FDStyle blueColor];
    DeselectedColor = [FDStyle mediumGreyColor];
    
    _firstButton.layer.cornerRadius = 20.0;
    [FDStyle addSmallRoundedCornersToView:_secondButton];
    [FDStyle addSmallRoundedCornersToView:_thirdButton];
    [FDStyle addSmallRoundedCornersToView:_fourthButton];
    [FDStyle addSmallRoundedCornersToView:_fifthButton];
}

- (void)initWithQuestion:(FDQuestion *)question response:(FDResponse *)response
{
    NSArray *buttons = @[_firstButton, _secondButton, _thirdButton, _fourthButton, _fifthButton];
    
    NSString *title = [question name];
    [_titleLabel setText:title];
    
    NSString *description = @"";
    NSInteger value = [response value];
    if(value > 0 && value < 5) {
        NSString *descriptionPath = [NSString stringWithFormat:@"helpers/basic_%li", value];
        description = FDLocalizedString(descriptionPath);
        [self setSelectedColor:buttons[value]];
    } else {
        [self clearSelection];
    }
    [_descriptionLabel setText:description];
}

- (void)clearSelection
{
    [self setDeselectedColor:_firstButton];
    [self setDeselectedColor:_secondButton];
    [self setDeselectedColor:_thirdButton];
    [self setDeselectedColor:_fourthButton];
    [self setDeselectedColor:_fifthButton];
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

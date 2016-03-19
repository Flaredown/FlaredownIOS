//
//  FDMeterCollectionViewCell.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/17/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

//TODO: Merge this and FDMeterTableViewCell

#import "FDMeterCollectionViewCell.h"

#import "FDStyle.h"

@implementation FDMeterCollectionViewCell

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
    
    _firstButton.layer.cornerRadius = _firstButton.frame.size.width / 2;
    [FDStyle addSmallRoundedCornersToView:_secondButton];
    [FDStyle addSmallRoundedCornersToView:_thirdButton];
    [FDStyle addSmallRoundedCornersToView:_fourthButton];
    [FDStyle addSmallRoundedCornersToView:_fifthButton];
}

- (void)initWithQuestion:(FDQuestion *)question response:(FDResponse *)response
{
    [self clearSelection];
    
    NSArray *buttons = @[_firstButton, _secondButton, _thirdButton, _fourthButton, _fifthButton];
    
    NSInteger value = [response value];
    if(value >= 0 && value < 5) {
        if(value == 0) {
            [self setSelectedColor:buttons[0]];
        } else {
            for(int i = 1; i <= value; i++) {
                [self setSelectedColor:buttons[i]];
            }
        }
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

- (void)setSelectedColor:(UIButton *)button
{
    [button setBackgroundColor:SelectedColor];
}

- (void)setDeselectedColor:(UIButton *)button
{
    [button setBackgroundColor:DeselectedColor];
}

@end

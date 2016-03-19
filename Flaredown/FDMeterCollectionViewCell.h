//
//  FDMeterCollectionViewCell.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/17/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDQuestion.h"
#import "FDResponse.h"

@interface FDMeterCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthButton;

- (void)initWithQuestion:(FDQuestion *)question response:(FDResponse *)response;

@end

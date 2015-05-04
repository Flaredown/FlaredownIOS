//
//  FDSelectCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/29/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDQuestion;
@class FDResponse;

@interface FDSelectCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property FDQuestion *question;
@property FDResponse *response;
@property NSArray *inputs;

@property BOOL itemSelected;
@property int selectedIndex;

- (void)initWithQuestion:(FDQuestion *)question;

@end

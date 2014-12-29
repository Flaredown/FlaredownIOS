//
//  FDSelectCollectionViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/29/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDModelManager.h"

@interface FDSelectCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property FDQuestion *question;
@property FDResponse *response;
@property NSArray *inputs;

@property BOOL itemSelected;

- (void)initWithQuestion:(FDQuestion *)question;

@end

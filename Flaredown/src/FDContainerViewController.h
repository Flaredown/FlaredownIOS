//
//  FDContainerViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 10/6/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SegueIdentifierSelectListView @"embedSelectListView"
#define SegueIdentifierSelectCollectionView @"embedSelectCollectionView"
#define SegueIdentifierNumberView @"embedNumberView"
#define SegueIdentifierNotesView @"embedNotesView"

@interface FDContainerViewController : UIViewController

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property int pageIndex;

@end

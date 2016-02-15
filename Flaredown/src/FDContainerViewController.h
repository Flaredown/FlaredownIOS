//
//  FDContainerViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 10/6/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSelectListViewController.h"

#define StoryboardIdentifierSelectListView @"FDSelectListViewController"
#define StoryboardIdentifierSelectCollectionView @"FDSelectCollectionViewController"
#define StoryboardIdentifierSelectQuestionTableView @"FDSelectQuestionTableViewController"
#define StoryboardIdentifierNumberView @"FDNumberViewController"
#define StoryboardIdentifierMeterView @"FDMeterTableViewController"
#define StoryboardIdentifierNotesView @"FDNotesViewController"
#define StoryboardIdentifierTagsView @"FDTagsCollectionViewController"
#define StoryboardIdentifierTreatmentsCollectionView @"TreatmentCollection"

@interface FDContainerViewController : UIViewController

@property (nonatomic, weak) id <FDViewControllerDelegate> mainViewDelegate;
@property (nonatomic, weak) id <FDPageContentViewControllerDelegate> contentViewDelegate;

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) NSString *currentStoryboardIdentifier;
@property int pageIndex;

@end

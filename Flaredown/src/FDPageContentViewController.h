//
//  FDPageContentViewController.h
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDViewController.h"
#import "FDTreatment.h"

#define ContainerEmbedSegueIdentifier @"containerEmbedSegue"
#define EditListSegueIdentifier @"editList"
#define SearchSegueIdentifier @"search"

#define StoryboardIdentifierSelectListView @"FDSelectListViewController"
#define StoryboardIdentifierSelectCollectionView @"FDSelectCollectionViewController"
#define StoryboardIdentifierSelectQuestionTableView @"FDSelectQuestionTableViewController"
#define StoryboardIdentifierNumberView @"FDNumberViewController"
#define StoryboardIdentifierMeterView @"FDMeterViewController"
#define StoryboardIdentifierNotesView @"FDNotesViewController"
#define StoryboardIdentifierTagsView @"FDTagsCollectionViewController"
#define StoryboardIdentifierTreatmentsCollectionView @"TreatmentCollection"
#define StoryboardIdentifierMeterTableView @"FDMeterTableViewController"

typedef enum : NSUInteger {
    EditSegueTreatments,
    EditSegueSymptoms,
    EditSegueConditions
} EditSegueType;

@protocol FDPageContentViewControllerDelegate <NSObject>

- (void)openSearch:(NSString *)type;
- (void)editList;
- (void)closeEditList;
- (void)addTreatmentPopupWithTreatment:(FDTreatment *)treatment;
- (void)sizeToFitContent;

@end

@interface FDPageContentViewController : UIViewController <FDPageContentViewControllerDelegate>

@property (weak, nonatomic) id <FDViewControllerDelegate> mainViewDelegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *embedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *embedViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//Subtite or edit button
@property (weak, nonatomic) IBOutlet UIButton *secondaryTitleButton;

@property (retain, nonatomic) UIViewController *currentViewController;
@property (retain, nonatomic) UIViewController *popupController;

@property int pageIndex;
@property EditSegueType editSegueType;

@end

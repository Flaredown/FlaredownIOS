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

typedef enum : NSUInteger {
    EditSegueTreatments,
    EditSegueSymptoms,
    EditSegueConditions
} EditSegueType;

@protocol FDPageContentViewControllerDelegate <NSObject>

- (void)openSearch:(NSString *)type;
- (void)editList;
- (void)refreshEditList;
- (void)closeEditList;
- (void)addTreatmentPopupWithTreatment:(FDTreatment *)treatment;

@end

@interface FDPageContentViewController : UIViewController <FDPageContentViewControllerDelegate>

@property (weak, nonatomic) id <FDViewControllerDelegate> mainViewDelegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//Subtite or edit button
@property (weak, nonatomic) IBOutlet UIButton *secondaryTitleButton;

@property (retain, nonatomic) UIViewController *popupController;
@property BOOL openEditList;

@property int pageIndex;
@property EditSegueType editSegueType;

@end

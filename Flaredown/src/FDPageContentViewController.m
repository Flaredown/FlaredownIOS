//
//  FDPageContentViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDPageContentViewController.h"
#import "FDContainerViewController.h"
#import "FDSelectListViewController.h"
#import "FDSearchTableViewController.h"
#import "FDModelManager.h"
#import <MJPopupViewController/UIViewController+MJPopupViewController.h>
#import <QuartzCore/QuartzCore.h>
#import "FDStyle.h"
#import "FDEmbeddedSelectListViewController.h"
#import "FDPopupManager.h"
#import "FDLocalizationManager.h"

//Ratio of popup : window
#define POPUP_SIZE_WIDTH .9
#define POPUP_SIZE_HEIGHT .7

@interface FDPageContentViewController ()

@end

@implementation FDPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Style
    [FDStyle addRoundedCornersToView:self.contentView];
    [FDStyle addShadowToView:self.contentView];
    self.contentView.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2);

    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];

    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    
    
    if(_pageIndex == 0) {
        if([[FDModelManager sharedManager] conditions].count == 0) {
            //Add conditions
            self.titleLabel.text = FDLocalizedString(@"oops_no_conditions_being_tracked");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_conditions_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            
            _editSegueType = EditSegueConditions;
        } else {
            self.titleLabel.text = FDLocalizedString(@"how_active_were_your_conditions");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_conditions_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            _editSegueType = EditSegueConditions;
        }
    } else if(_pageIndex == 1) {
        if([[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            self.titleLabel.text = FDLocalizedString(@"oops_no_symptoms_being_tracked");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_symptoms_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            
            _editSegueType = EditSegueSymptoms;
        } else {
                self.titleLabel.text = FDLocalizedString(@"how_active_were_your_symptoms");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_symptoms_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            _editSegueType = EditSegueSymptoms;
        }
    } else if(_pageIndex == 2) {
        //Treatments
        if([[[FDModelManager sharedManager] entry] treatments].count == 0)
            self.titleLabel.text = FDLocalizedString(@"oops_no_treatments_being_tracked");
        else
            self.titleLabel.text = FDLocalizedString(@"which_treatments_taken_today");
        [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"edit_treatments_caps") color:[FDStyle blueColor]];
        [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
        
        _editSegueType = EditSegueTreatments;
    } else if(offsetIndex >= numSections) {
        if(offsetIndex == numSections && [[FDModelManager sharedManager] symptoms].count == 0) {
        } else if(offsetIndex == numSections || (offsetIndex == numSections + 1 && [[FDModelManager sharedManager] symptoms].count == 0 && [[FDModelManager sharedManager] conditions].count == 0)) {
        } else if(offsetIndex == numSections + 1 || offsetIndex == numSections + 2) {
            //Notes
            [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
            self.titleLabel.text = FDLocalizedString(@"tag_your_day");
//            self.titleLabel.text = FDLocalizedString(@"leave_a_note");
        }
    } else {
        FDQuestion *question = [[FDModelManager sharedManager] questionsForSection:offsetIndex][0];
        
        if([[question catalog] isEqualToString:@"symptoms"]) {
        } else if([[question catalog] isEqualToString:@"conditions"]) {
        } else if([[question kind] isEqualToString:@"checkbox"]) {
            if(![[NSNull null] isEqual:[question name]]) {
                NSInteger catalogSection = [[[[FDModelManager sharedManager] entry] questionsForCatalog:[question catalog]] indexOfObject:question]+1;
                NSString *path = [NSString stringWithFormat:@"catalogs/%@/section_%li_prompt", [question catalog], catalogSection];
                self.titleLabel.text = FDLocalizedString(path);
                if(self.titleLabel.text.length == 0)
                    self.titleLabel.text = FDLocalizedString(@"complications_question_prompt");
            }
            [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
        } else if([[question kind] isEqualToString:@"number"]) {
            if(![[NSNull null] isEqual:[question name]]) {
                NSInteger catalogSection = [[[[FDModelManager sharedManager] entry] questionsForCatalog:[question catalog]] indexOfObject:question]+1;
                NSString *path = [NSString stringWithFormat:@"catalogs/%@/section_%li_prompt", [question catalog], catalogSection];
                self.titleLabel.text = FDLocalizedString(path);
                if(self.titleLabel.text.length == 0)
                    self.titleLabel.text = [NSString stringWithFormat:FDLocalizedString(@"number_question_prompt"), [question name]];
            }
            [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
        } else {
            if(![[NSNull null] isEqual:[question name]]) {
                NSInteger catalogSection = [[[[FDModelManager sharedManager] entry] questionsForCatalog:[question catalog]] indexOfObject:question]+1;
                NSString *path = [NSString stringWithFormat:@"catalogs/%@/section_%li_prompt", [question catalog], catalogSection];
                self.titleLabel.text = FDLocalizedString(path);
                if(self.titleLabel.text.length == 0)
                    self.titleLabel.text = [NSString stringWithFormat:FDLocalizedString(@"catalog_question_prompt"), [question name]];
            }
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"research_questions_caps") color:[FDStyle greyColor]];
        }
    }
    
    if([[self.secondaryTitleButton titleForState:UIControlStateNormal] isEqualToString:@""]) {
        [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, (self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + self.secondaryTitleButton.frame.origin.y) / 2,
                                           self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
    }
    
//    if(![[NSNull null] isEqual:[question group]]) {
//        
//        NSString *title = [question group];
//        /* create a locale where diacritic marks are not considered important, e.g. US English */
//        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
//        
//        /* get first char */
//        NSString *firstChar = [title substringToIndex:1];
//        
//        /* remove any diacritic mark */
//        NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
//        
//        /* create the new string */x
//        self.titleLabel.text = [[folded uppercaseString] stringByAppendingString:[title substringFromIndex:1]];
//
}

- (void)underlineButton:(UIButton *)button withText:(NSString *)text color:(UIColor *)color
{
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName:color};
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:text attributes:underlineAttribute] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editList
{
    //The popup is dependent on _parentViewController being set properly (check MJPopupViewController library). When coming back from search, this value hasn't been set yet since this method is called via delegate from search's viewDidDisappear, so manually setting it fixes the issue.
//    if([self valueForKey:@"_parentViewController"] == nil)
//        [self setValue:(FDViewController *)[_mainViewDelegate instance] forKey:@"_parentViewController"];
    
//    if(_popupController)
//        return;
    
    FDEmbeddedSelectListViewController *containerController = (FDEmbeddedSelectListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FDEmbeddedSelectListViewController"];
    
    //Style
    float popupWidth = self.view.window.frame.size.width*POPUP_SIZE_WIDTH;
    float popupX = self.view.window.frame.size.width/2-popupWidth/2;
    float popupHeight = self.view.window.frame.size.height*POPUP_SIZE_HEIGHT;
    float popupY = self.view.window.frame.size.height/2-popupHeight/2;
    
    [containerController.view setFrame:CGRectMake(popupX, popupY, popupWidth, popupHeight)];
    containerController.view.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:containerController.view];
    
    [containerController updateViewConstraints];
    
    FDSelectListViewController *listController = containerController.listController;
    listController.mainViewDelegate = _mainViewDelegate;
    listController.contentViewDelegate = self;
    _popupController = listController;
    
    listController.dynamic = YES;
    if(_editSegueType == EditSegueTreatments) {
        [listController initWithTreatments];
    } else if(_editSegueType == EditSegueSymptoms) {
        [listController initWithSymptoms];
    } else if(_editSegueType == EditSegueConditions) {
        [listController initWithConditions];
    }
    
    [[FDPopupManager sharedManager] addPopupView:containerController.view withViewController:containerController];
}

- (void)closeEditList
{
    [[_mainViewDelegate instance] dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)addTreatmentPopupWithTreatment:(FDTreatment *)treatment
{
    [(FDSelectListViewController *)_popupController addTreatmentPopupWithTreatment:treatment];
}

- (void)openSearch:(NSString *)type
{
    [_mainViewDelegate openSearch:type];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ContainerEmbedSegueIdentifier]) {
        FDContainerViewController *containerViewController = (FDContainerViewController *)segue.destinationViewController;
        containerViewController.pageIndex = self.pageIndex;
        containerViewController.mainViewDelegate = _mainViewDelegate;
        containerViewController.contentViewDelegate = self;
    } else if([segue.identifier isEqualToString:EditListSegueIdentifier]) {
        FDSelectListViewController *dvc = (FDSelectListViewController *)segue.destinationViewController;
        dvc.mainViewDelegate = _mainViewDelegate;
        dvc.contentViewDelegate = self;
        [dvc setModalPresentationStyle:UIModalPresentationPopover];
        dvc.dynamic = YES;
        if(_editSegueType == EditSegueTreatments) {
            [dvc initWithTreatments];
        } else if(_editSegueType == EditSegueSymptoms) {
            [dvc initWithSymptoms];
        } else if(_editSegueType == EditSegueConditions) {
            [dvc initWithConditions];
        }
    } else if([segue.identifier isEqualToString:SearchSegueIdentifier]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        FDSearchTableViewController *dvc = (FDSearchTableViewController *)navController.topViewController;
        dvc.contentViewDelegate = self;
    }
}


@end

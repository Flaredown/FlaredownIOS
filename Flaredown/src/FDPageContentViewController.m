//
//  FDPageContentViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDPageContentViewController.h"

#import <MJPopupViewController/UIViewController+MJPopupViewController.h>
#import <QuartzCore/QuartzCore.h>

#import "FDContainerViewController.h"
#import "FDSelectListViewController.h"
#import "FDSearchTableViewController.h"
#import "FDModelManager.h"
#import "FDStyle.h"
#import "FDEmbeddedSelectListViewController.h"
#import "FDPopupManager.h"
#import "FDLocalizationManager.h"
#import "FDSelectListViewController.h"
#import "FDNumberViewController.h"
#import "FDSelectCollectionViewController.h"
#import "FDSelectQuestionTableViewController.h"
#import "FDMeterViewController.h"
#import "FDNotesViewController.h"
#import "FDTagsCollectionViewController.h"
#import "FDTreatmentCollectionViewController.h"

#import "FDMeterTableViewController.h"

//Ratio of popup : window
#define POPUP_SIZE_WIDTH .9
#define POPUP_SIZE_HEIGHT .7

@interface FDPageContentViewController ()

@end

@implementation FDPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
    
    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    
    self.titleLabel.text = @"";
    [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
    
    if(_pageIndex == 0) {
        if([[FDModelManager sharedManager] conditions].count == 0) {
            //Add conditions
            [self setTitle:FDLocalizedString(@"oops_no_conditions_being_tracked") secondaryTitle:FDLocalizedString(@"onboarding/edit_conditions_caps") editAction:@selector(editList)];
            self.titleLabel.text = FDLocalizedString(@"oops_no_conditions_being_tracked");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_conditions_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            
            _editSegueType = EditSegueConditions;
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierSelectListView];
            
            FDSelectListViewController *listVC = (FDSelectListViewController *)_currentViewController;
            //send empty array so you only get the add button
            [listVC initWithConditions];
            listVC.mainViewDelegate = _mainViewDelegate;
            listVC.contentViewDelegate = self;
            listVC.listType = ListTypeConditions;
        } else {
            self.titleLabel.text = FDLocalizedString(@"how_active_were_your_conditions");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_conditions_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            _editSegueType = EditSegueConditions;
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierMeterTableView];
            
            FDMeterTableViewController *meterVC = (FDMeterTableViewController *)_currentViewController;
            
            [meterVC initWithQuestions:[[[FDModelManager sharedManager] entry] questionsForCatalog:@"conditions"]];
            
            [meterVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, meterVC.tableView.contentSize.height)];
        }
    } else if(_pageIndex == 1) {
        if([[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            [self setTitle:FDLocalizedString(@"oops_no_symptoms_being_tracked") secondaryTitle:FDLocalizedString(@"onboarding/edit_symptoms_caps") editAction:@selector(editList)];
            
            _editSegueType = EditSegueSymptoms;
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierSelectListView];
            
            FDSelectListViewController *listVC = (FDSelectListViewController *)_currentViewController;
            //send empty array so you only get the add button
            [listVC initWithQuestions:[@[] mutableCopy]];
            listVC.mainViewDelegate = _mainViewDelegate;
            listVC.contentViewDelegate = self;
            listVC.listType = ListTypeSymptoms;
        } else {
            self.titleLabel.text = FDLocalizedString(@"how_active_were_your_symptoms");
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"onboarding/edit_symptoms_caps") color:[FDStyle blueColor]];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            _editSegueType = EditSegueSymptoms;
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierMeterTableView];
            
            FDMeterTableViewController *meterVC = (FDMeterTableViewController *)_currentViewController;
            
            [meterVC initWithQuestions:[[[FDModelManager sharedManager] entry] questionsForCatalog:@"symptoms"]];
            
            [meterVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, meterVC.tableView.contentSize.height)];
        }
    } else if(_pageIndex == 2) {
        //Treatments
        NSString *title;
        if([[[FDModelManager sharedManager] entry] treatments].count == 0)
            title = FDLocalizedString(@"oops_no_treatments_being_tracked");
        else
            title = FDLocalizedString(@"which_treatments_taken_today");
        [self setTitle:title secondaryTitle:FDLocalizedString(@"edit_treatments_caps") editAction:@selector(editList)];
        
        _editSegueType = EditSegueTreatments;
        [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierTreatmentsCollectionView];
        
        FDTreatmentCollectionViewController *treatmentVC = (FDTreatmentCollectionViewController *)_currentViewController;

        [treatmentVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, treatmentVC.collectionView.contentSize.height)];
        
        
    } else if(_pageIndex == 3) {
        //Tags
        [self setTitle:FDLocalizedString(@"tag_your_day") secondaryTitle:@"" editAction:nil];
        
        [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierTagsView];
        
        FDTagsCollectionViewController *tagsVC = (FDTagsCollectionViewController *)_currentViewController;
        tagsVC.mainViewDelegate = _mainViewDelegate;
        
        [tagsVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, tagsVC.collectionView.contentSize.height)];
        
    } else if(offsetIndex >= numSections) {
        if(offsetIndex == numSections && [[FDModelManager sharedManager] symptoms].count == 0) {
        } else if(offsetIndex == numSections || (offsetIndex == numSections + 1 && [[FDModelManager sharedManager] symptoms].count == 0 && [[FDModelManager sharedManager] conditions].count == 0)) {
        } else if(offsetIndex == numSections + 1 || offsetIndex == numSections + 2) {
        }
    } else {
        FDQuestion *question = [[FDModelManager sharedManager] questionsForSection:offsetIndex][0];
        
        if([[question catalog] isEqualToString:@"symptoms"]) {
            NSString *title = @"";
            if(![[NSNull null] isEqual:[question name]])
                title = FDLocalizedString(@"symptom_question_prompt");
            [self setTitle:title secondaryTitle:FDLocalizedString(@"onboarding/edit_symptoms_caps") editAction:@selector(editList)];
            
            _editSegueType = EditSegueSymptoms;
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierMeterView];
            
            FDMeterViewController *meterVC = (FDMeterViewController *)_currentViewController;
            [meterVC initWithQuestion:question];
            meterVC.mainViewDelegate = _mainViewDelegate;
        } else if([[question catalog] isEqualToString:@"conditions"]) {
            NSString *title = @"";
            if(![[NSNull null] isEqual:[question name]])
                title = [NSString stringWithFormat:FDLocalizedString(@"condition_question_prompt"), [question name]];
            [self setTitle:title secondaryTitle:FDLocalizedString(@"onboarding/edit_conditions_caps") editAction:@selector(editList)];
            
            _editSegueType = EditSegueConditions;
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierMeterView];
            
            FDMeterViewController *meterVC = (FDMeterViewController *)_currentViewController;
            [meterVC initWithQuestion:question];
            meterVC.mainViewDelegate = _mainViewDelegate;
        } else if([[question kind] isEqualToString:@"checkbox"]) {
            NSString *title;
            if(![[NSNull null] isEqual:[question name]]) {
                NSInteger catalogSection = [[[[FDModelManager sharedManager] entry] questionsForCatalog:[question catalog]] indexOfObject:question]+1;
                NSString *path = [NSString stringWithFormat:@"catalogs/%@/section_%li_prompt", [question catalog], (long)catalogSection];
                title = FDLocalizedString(path);
                if(title.length == 0)
                    title = FDLocalizedString(@"complications_question_prompt");
            }
            [self setTitle:title secondaryTitle:@"" editAction:nil];
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierMeterView];
            
            FDMeterViewController *meterVC = (FDMeterViewController *)_currentViewController;
            [meterVC initWithQuestion:question];
            meterVC.mainViewDelegate = _mainViewDelegate;
        } else if([[question kind] isEqualToString:@"number"]) {
            NSString *title;
            if(![[NSNull null] isEqual:[question name]]) {
                NSInteger catalogSection = [[[[FDModelManager sharedManager] entry] questionsForCatalog:[question catalog]] indexOfObject:question]+1;
                NSString *path = [NSString stringWithFormat:@"catalogs/%@/section_%li_prompt", [question catalog], (long)catalogSection];
                title = FDLocalizedString(path);
                if(title.length == 0)
                    title = [NSString stringWithFormat:FDLocalizedString(@"number_question_prompt"), [question name]];
            }
            [self setTitle:title secondaryTitle:@"" editAction:nil];
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierNumberView];
            
            FDNumberViewController *numberVC = (FDNumberViewController *)_currentViewController;
            [numberVC initWithQuestion:question];
        } else {
            if(![[NSNull null] isEqual:[question name]]) {
                NSInteger catalogSection = [[[[FDModelManager sharedManager] entry] questionsForCatalog:[question catalog]] indexOfObject:question]+1;
                NSString *path = [NSString stringWithFormat:@"catalogs/%@/section_%li_prompt", [question catalog], (long)catalogSection];
                self.titleLabel.text = FDLocalizedString(path);
                if(self.titleLabel.text.length == 0)
                    self.titleLabel.text = [NSString stringWithFormat:FDLocalizedString(@"catalog_question_prompt"), [question name]];
            }
            [self underlineButton:self.secondaryTitleButton withText:FDLocalizedString(@"research_questions_caps") color:[FDStyle greyColor]];
            
            [self showEmbeddedViewControllerWithStoryboardIdentifier:StoryboardIdentifierSelectQuestionTableView];
            
            FDSelectQuestionTableViewController *questionVC = (FDSelectQuestionTableViewController *)_currentViewController;
            questionVC.mainViewDelegate = _mainViewDelegate;
            [questionVC initWithQuestion:question];
        }
    }
    
    [self sizeToFitContent];
    
    if([[self.secondaryTitleButton titleForState:UIControlStateNormal] isEqualToString:@""]) {
        [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, (self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + self.secondaryTitleButton.frame.origin.y) / 2,
                                             self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
    }
}

- (void)setTitle:(NSString *)title secondaryTitle:(NSString *)secondaryTitle editAction:(SEL)editAction
{
    self.titleLabel.text = title;
    [self underlineButton:self.secondaryTitleButton withText:secondaryTitle color:[FDStyle blueColor]];
    [self.secondaryTitleButton addTarget:self action:editAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)showEmbeddedViewControllerWithStoryboardIdentifier:(NSString *)identifier
{
    UIViewController *embeddedViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self addChildViewController:embeddedViewController];
    
    if([embeddedViewController respondsToSelector:@selector(contentViewDelegate)]) {
        [embeddedViewController setValue:self forKey:@"contentViewDelegate"];
    }
    
    UIView *view = embeddedViewController.view;
    view.backgroundColor = [UIColor clearColor];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [_embedView addSubview:view];
    
//    [FDStyle addRoundedCornersToTopOfView:_contentView];
//    [FDStyle addShadowToView:_contentView];
//    [FDStyle addRoundedCornersToBottomOfView:_embedView];
//    [FDStyle addShadowToView:_embedView];

    if(_currentViewController) {
        [_currentViewController.view removeFromSuperview];
        [_currentViewController willMoveToParentViewController:nil];
        [self transitionFromViewController:_currentViewController toViewController:embeddedViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            [_currentViewController removeFromParentViewController];
            [embeddedViewController didMoveToParentViewController:self];
        }];
    } else {
        [embeddedViewController didMoveToParentViewController:self];
    }
    
    _currentViewController = embeddedViewController;
}

- (void)sizeToFitContent
{
    UIView *view = _currentViewController.view;
    
    float height = view.frame.size.height;
    float width = view.frame.size.width;
    
    _embedViewHeightConstraint.constant = height;
    _embedViewWidthConstraint.constant = width;
    [_embedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [_embedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [_embedView setNeedsLayout];
    [_embedView layoutIfNeeded];
}

- (void)underlineButton:(UIButton *)button withText:(NSString *)text color:(UIColor *)color
{
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName:color};
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:text attributes:underlineAttribute] forState:UIControlStateNormal];
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

- (void)resizeScrollView
{
    [_contentView sizeToFit];
    
    float contentSize = 0;
    UIView *lastView = [_scrollView.subviews lastObject];
    contentSize += lastView.frame.origin.y + lastView.frame.size.height;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, contentSize);
}

@end

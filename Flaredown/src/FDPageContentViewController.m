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

//Ratio of popup : window
#define POPUP_SIZE_WIDTH .9
#define POPUP_SIZE_HEIGHT .7

@interface FDPageContentViewController ()

@end

@implementation FDPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Style
    self.view.layer.masksToBounds = YES;
//    self.view.clipsToBounds = NO;
    [FDStyle addRoundedCornersToView:self.view];
    [FDStyle addShadowToView:self.view];
    self.view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);

    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName:[FDStyle greyColor]};
    
    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    
    if(_pageIndex == 0 && [[FDModelManager sharedManager] conditions].count == 0) {
        //Add conditions
        self.titleLabel.text = NSLocalizedString(@"You are not tracking any conditions", nil);
        [self.secondaryTitleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"EDIT CONDITIONS", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
        [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];

        _editSegueType = EditSegueConditions;
    } else if(offsetIndex >= numSections) {
        if(offsetIndex == numSections && [[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            self.titleLabel.text = NSLocalizedString(@"You are not tracking any symptoms", nil);
            [self.secondaryTitleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"EDIT SYMPTOMS", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            
            _editSegueType = EditSegueSymptoms;
        } else if(offsetIndex == numSections || (offsetIndex == numSections + 1 && [[FDModelManager sharedManager] symptoms].count == 0 && [[FDModelManager sharedManager] conditions].count == 0)) {
            //Treatments
            if([[[FDModelManager sharedManager] entry] treatments].count == 0)
                self.titleLabel.text = NSLocalizedString(@"You are not tracking any treatments", nil);
            else
                self.titleLabel.text = NSLocalizedString(@"Which treatments did you take?", nil);
            [self.secondaryTitleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"EDIT TREATMENTS", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            
            _editSegueType = EditSegueTreatments;
        } else if(offsetIndex == numSections + 1 || offsetIndex == numSections + 2) {
            //Notes
            [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
            self.titleLabel.text = NSLocalizedString(@"Leave a note", nil);
        }
    } else {
        FDQuestion *question = [[FDModelManager sharedManager] questionsForSection:offsetIndex][0];
        
        if([[question catalog] isEqualToString:@"symptoms"]) {
            if(![[NSNull null] isEqual:[question name]])
                self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"How active is your %@ today?", nil), [question name]];
            [self.secondaryTitleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"EDIT SYMPTOMS", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            _editSegueType = EditSegueSymptoms;
        } else if([[question catalog] isEqualToString:@"conditions"]) {
            if(![[NSNull null] isEqual:[question name]])
                self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"How active is your %@ today?", nil), [question name]];
            [self.secondaryTitleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"EDIT CONDITIONS", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
            [self.secondaryTitleButton addTarget:self action:@selector(editList) forControlEvents:UIControlEventTouchUpInside];
            _editSegueType = EditSegueConditions;
        } else if([[question kind] isEqualToString:@"checkbox"]) {
            if(![[NSNull null] isEqual:[question name]])
                self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Check any complications:", nil)];
            [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
        } else if([[question kind] isEqualToString:@"number"]) {
            if(![[NSNull null] isEqual:[question name]])
                self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"How many %@ today?", nil), [question name]];
            [self.secondaryTitleButton setTitle:@"" forState:UIControlStateNormal];
        }else {
            if(![[NSNull null] isEqual:[question name]])
                self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"What is your current level of %@?", nil), [question name]];
            [self.secondaryTitleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"RESEARCH QUESTIONS", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editList
{
    //The popup is dependent on _parentViewController being set properly (check MJPopupViewController library). When coming back from search, this value hasn't been set yet since this method is called via delegate from search's viewDidDisappear, so manually setting it fixes the issue.
//    if([self valueForKey:@"_parentViewController"] == nil)
//        [self setValue:(FDViewController *)[_mainViewDelegate instance] forKey:@"_parentViewController"];
    
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

- (void)refreshEditList
{
    FDSelectListViewController *listController = (FDSelectListViewController *)_popupController;
    if(listController.listType == ListTypeSymptoms)
        [listController initWithSymptoms];
    else if(listController.listType == ListTypeConditions)
        [listController initWithConditions];
    [listController.tableView reloadData];
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

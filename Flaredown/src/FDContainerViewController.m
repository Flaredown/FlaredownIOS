//
//  FDContainerViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 10/6/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDContainerViewController.h"
#import "FDSelectListViewController.h"
#import "FDNumberViewController.h"
#import "FDSelectCollectionViewController.h"
#import "FDSelectQuestionTableViewController.h"
#import "FDMeterTableViewController.h"
#import "FDNotesViewController.h"
#import "FDTagsCollectionViewController.h"
#import "FDModelManager.h"

@interface FDContainerViewController ()

@end

@implementation FDContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
//    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    
    if(_pageIndex == 0) {
        if([[FDModelManager sharedManager] conditions].count == 0) {
            //Add conditions
            self.currentStoryboardIdentifier = StoryboardIdentifierSelectListView;
        } else {
            self.currentStoryboardIdentifier = StoryboardIdentifierMeterView;
        }
    } else if(_pageIndex == 1) {
        if([[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            self.currentStoryboardIdentifier = StoryboardIdentifierSelectListView;
        } else {
            self.currentStoryboardIdentifier = StoryboardIdentifierMeterView;
        }
    } else if(_pageIndex == 2) {
        //Treatments
        self.currentStoryboardIdentifier = StoryboardIdentifierTreatmentsCollectionView;
    } else if(_pageIndex == 3) {
        //Tags
        self.currentStoryboardIdentifier = StoryboardIdentifierTagsView;
    } else {
        return;
//        FDQuestion *question = [[FDModelManager sharedManager] questionsForSection:offsetIndex][0];
//        NSString *pageType = [question kind];
//        NSString *catalog = [question catalog];
//        if([catalog isEqualToString:@"symptoms"] || [catalog isEqualToString:@"conditions"]) {
//            pageType = @"meter";
//        }
//        
//        if([pageType isEqualToString:@"select"]) {
////            self.currentStoryboardIdentifier = SegueIdentifierSelectCollectionView;
//            self.currentStoryboardIdentifier = StoryboardIdentifierSelectQuestionTableView;
//        } else if([pageType isEqualToString:@"checkbox"]) {
//            self.currentStoryboardIdentifier = StoryboardIdentifierSelectListView;
//        } else if([pageType isEqualToString:@"number"]) {
//            self.currentStoryboardIdentifier = StoryboardIdentifierNumberView;
//        } else if([pageType isEqualToString:@"meter"]) {
//            self.currentStoryboardIdentifier = StoryboardIdentifierMeterView;
//        } else if([pageType isEqualToString:@"tags"]) {
//            self.currentStoryboardIdentifier = StoryboardIdentifierTagsView;
//        } else {
//            NSLog(@"Invalid page kind");
//            return;
//        }
    }
    
    [self showEmbeddedViewControllerWithStoryboardIdentifier:self.currentStoryboardIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showEmbeddedViewControllerWithStoryboardIdentifier:(NSString *)identifier
{
    NSString *pageType;
    UIViewController *embeddedViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    if(self.childViewControllers.count > 0) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embeddedViewController];
    } else {
        [self addChildViewController:embeddedViewController];
        embeddedViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:embeddedViewController.view];
        [embeddedViewController didMoveToParentViewController:self];
    }
    
//    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
//    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    NSMutableArray *questions;
    if(_pageIndex == 0) {
        if([[FDModelManager sharedManager] conditions].count == 0) {
            //Add conditions
            pageType = @"checkbox";
            FDSelectListViewController *listVC = (FDSelectListViewController *)embeddedViewController;
            //send empty array so you only get the add button
            [listVC initWithQuestions:[@[] mutableCopy]];
            listVC.mainViewDelegate = _mainViewDelegate;
            listVC.listType = ListTypeConditions;
        } else {
            pageType = @"meter";
            questions = [[FDModelManager sharedManager] conditions];
        }
    } else if(_pageIndex == 1) {
        if([[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            pageType = @"checkbox";
            FDSelectListViewController *listVC = (FDSelectListViewController *)embeddedViewController;
            //send empty array so you only get the add button
            [listVC initWithQuestions:[@[] mutableCopy]];
            listVC.mainViewDelegate = _mainViewDelegate;
            listVC.listType = ListTypeSymptoms;
        } else {
            pageType = @"meter";
            questions = [[FDModelManager sharedManager] symptoms];
        }
    } else if(_pageIndex == 2) {
        //treatments
    } else if(_pageIndex == 3) {
        //Tags
        pageType = @"tags";
        FDTagsCollectionViewController *tagsVC = (FDTagsCollectionViewController *)embeddedViewController;
        tagsVC.mainViewDelegate = _mainViewDelegate;
    }
    
    if([pageType isEqualToString:@"checkbox"]) {
        FDSelectListViewController *listVC = (FDSelectListViewController *)embeddedViewController;
        listVC.contentViewDelegate = _contentViewDelegate;
    } else if([pageType isEqualToString:@"meter"]) {
//        questions = [[FDModelManager sharedManager] questionsForSection:_pageIndex];
        FDMeterTableViewController *meterVC = (FDMeterTableViewController *)embeddedViewController;
        [meterVC initWithQuestions:questions];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}

#pragma mark - Navigation

@end

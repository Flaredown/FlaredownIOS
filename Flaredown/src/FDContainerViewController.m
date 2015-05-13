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
#import "FDMeterViewController.h"
#import "FDNotesViewController.h"
#import "FDTagsCollectionViewController.h"
#import "FDModelManager.h"

@interface FDContainerViewController ()

@end

@implementation FDContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    
    if(_pageIndex == 0 && [[FDModelManager sharedManager] conditions].count == 0) {
        //Add conditions
        self.currentSegueIdentifier = SegueIdentifierSelectListView;
    } else if(offsetIndex >= numSections) {
        if(offsetIndex == numSections && [[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            self.currentSegueIdentifier = SegueIdentifierSelectListView;
        } else if(offsetIndex == numSections || (offsetIndex == numSections + 1 && [[FDModelManager sharedManager] symptoms].count == 0)) {
            //Treatments
            self.currentSegueIdentifier = SegueIdentifierSelectListView;
        } else if(offsetIndex == numSections + 1 || offsetIndex == numSections + 2) {
            //Tags
            self.currentSegueIdentifier = SegueIdentifierTagsView;
        }
    } else {
        FDQuestion *question = [[FDModelManager sharedManager] questionsForSection:offsetIndex][0];
        NSString *pageType = [question kind];
        NSString *catalog = [question catalog];
        if([catalog isEqualToString:@"symptoms"] || [catalog isEqualToString:@"conditions"]) {
            pageType = @"meter";
        }
        
        if([pageType isEqualToString:@"select"]) {
            self.currentSegueIdentifier = SegueIdentifierSelectCollectionView;
        } else if([pageType isEqualToString:@"checkbox"]) {
            self.currentSegueIdentifier = SegueIdentifierSelectListView;
        } else if([pageType isEqualToString:@"number"]) {
            self.currentSegueIdentifier = SegueIdentifierNumberView;
        } else if([pageType isEqualToString:@"meter"]) {
            self.currentSegueIdentifier = SegueIdentifierMeterView;
        } else if([pageType isEqualToString:@"tags"]) {
            self.currentSegueIdentifier = SegueIdentifierTagsView;
        } else {
            NSLog(@"Invalid page kind");
            return;
        }
    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *pageType;
    UIViewController *dvc = segue.destinationViewController;
    
    if(self.childViewControllers.count > 0) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    } else {
        [self addChildViewController:segue.destinationViewController];
        ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
        [segue.destinationViewController didMoveToParentViewController:self];
    }
    
    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
    int offsetIndex = [[FDModelManager sharedManager] conditions].count == 0 ? _pageIndex - 1 : _pageIndex;
    
    if(_pageIndex == 0 && [[FDModelManager sharedManager] conditions].count == 0) {
        //Add conditions
        pageType = @"checkbox";
        FDSelectListViewController *listVC = (FDSelectListViewController *)dvc;
        //send empty array so you only get the add button
        [listVC initWithQuestions:[@[] mutableCopy]];
        listVC.mainViewDelegate = _mainViewDelegate;
        listVC.listType = ListTypeConditions;
    } else if(offsetIndex >= numSections) {
        if(offsetIndex == numSections && [[FDModelManager sharedManager] symptoms].count == 0) {
            //Add symptoms
            pageType = @"checkbox";
            FDSelectListViewController *listVC = (FDSelectListViewController *)dvc;
            //send empty array so you only get the add button
            [listVC initWithQuestions:[@[] mutableCopy]];
            listVC.mainViewDelegate = _mainViewDelegate;
            listVC.listType = ListTypeSymptoms;
        } else if(offsetIndex == numSections || (offsetIndex == numSections + 1 && [[FDModelManager sharedManager] symptoms].count == 0)) {
            //Treatments
            pageType = @"checkbox";
            FDSelectListViewController *listVC = (FDSelectListViewController *)dvc;
            [listVC initWithTreatments];
            listVC.mainViewDelegate = _mainViewDelegate;
        } else if(offsetIndex == numSections + 1 || offsetIndex == numSections + 2) {
            //Tags
            pageType = @"tags";
            FDTagsCollectionViewController *tagsVC = (FDTagsCollectionViewController *)dvc;
//            tagsVC.mainViewDelegate = _mainViewDelegate;
        }
    } else {
        NSMutableArray *questions = [[FDModelManager sharedManager] questionsForSection:offsetIndex];
        pageType = [questions[0] kind];
        if([[questions[0] catalog] isEqualToString:@"symptoms"] || [[questions[0] catalog] isEqualToString:@"conditions"]) {
            pageType = @"meter";
        }
        
        if([pageType isEqualToString:@"checkbox"]) {
            FDSelectListViewController *listVC = (FDSelectListViewController *)dvc;
            [listVC initWithQuestions:questions];
            listVC.mainViewDelegate = _mainViewDelegate;
        } else if([pageType isEqualToString:@"number"]) {
            [((FDNumberViewController *)dvc) initWithQuestion:questions[0]];
        } else if([pageType isEqualToString:@"select"]) {
            FDSelectCollectionViewController *selectVC = (FDSelectCollectionViewController *)dvc;
            [selectVC initWithQuestion:questions[0]];
        } else if([pageType isEqualToString:@"meter"]) {
            FDMeterViewController *meterVC = (FDMeterViewController *)dvc;
            [meterVC initWithQuestion:questions[0]];
        }
    }
    
    if([pageType isEqualToString:@"checkbox"]) {
        FDSelectListViewController *listVC = (FDSelectListViewController *)dvc;
        listVC.contentViewDelegate = _contentViewDelegate;
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

@end

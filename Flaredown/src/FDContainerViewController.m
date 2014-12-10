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
#import "FDModelManager.h"

@interface FDContainerViewController ()

@end

@implementation FDContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pageType = [[[FDModelManager sharedManager] questionsForSection:self.pageIndex+1][0] kind];
    
    if([pageType isEqualToString:@"select"]) {
        self.currentSegueIdentifier = SegueIdentifierSelectCollectionView;
    } else if([pageType isEqualToString:@"checkbox"]) {
        self.currentSegueIdentifier = SegueIdentifierSelectListView;
    } else if([pageType isEqualToString:@"number"]) {
        self.currentSegueIdentifier = SegueIdentifierNumberView;
    } else if([pageType isEqualToString:@"notes"]) {
        self.currentSegueIdentifier = SegueIdentifierNotesView;
    } else {
        NSLog(@"Invalid page kind");
        return;
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
    NSArray *questions = [[FDModelManager sharedManager] questionsForSection:self.pageIndex+1];
    NSString *pageType = [questions[0] kind];
    
    if(self.childViewControllers.count > 0) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    } else {
        [self addChildViewController:segue.destinationViewController];
        ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
        [segue.destinationViewController didMoveToParentViewController:self];
    }
    
    if(/* DISABLES CODE */ (NO)) {
        ((FDSelectListViewController *)segue.destinationViewController).dynamic = true;
    }
    
    UIViewController *dvc = segue.destinationViewController;
    if([pageType isEqualToString:@"checkbox"])
        [((FDSelectListViewController *)dvc) initWithQuestions:questions];
    else if([pageType isEqualToString:@"number"])
        [((FDNumberViewController *)dvc) initWithQuestion:questions[0]];
    else if([pageType isEqualToString:@"select"])
        [((FDSelectCollectionViewController *)dvc) initWithQuestion:questions[0]];
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

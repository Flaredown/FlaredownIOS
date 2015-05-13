//
//  FDViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "FDPageContentViewController.h"
#import "FDSearchTableViewController.h"
#import "FDStyle.h"
#import "FDLocalizationManager.h"
#import "FDSummaryCollectionViewController.h"

#define CARD_BUMP_OFFSET 60

@interface FDViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation FDViewController

- (id)instance {
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Style
    [FDStyle addRoundedCornersToView:_continueBtn];
    [FDStyle addShadowToView:_continueBtn];
    _continueBtn.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_continueBtn];
    
    [_continueBtn setTitle:FDLocalizedString(@"onboarding/continue") forState:UIControlStateNormal];
    
    //Localized date
//    NSString *dateString = [[[FDModelManager sharedManager] entry] date];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:now];
    [_dateLabel setText:dateString];
    
    self.pageIndex = 0;
    
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self refreshPages];
    
    self.pageViewController.view.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 140);
    
    //Create summary view controller
    self.summaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"summary"];
    [self.summaryViewController setMainViewDelegate:self];
    self.summaryViewController.entry = [[FDModelManager sharedManager] entry];
    self.summaryViewController.view.frame = CGRectMake(10, 90, self.view.frame.size.width - 20, self.view.frame.size.height - 160);
    
    if(_loadSummary)
        [self showSummary];
    else
        [self showPages];
}

- (void)showPages
{
    if([self.summaryViewController parentViewController])
        [self removeViewController:self.summaryViewController];
    [self addViewController:self.pageViewController];
}

- (void)showSummary
{
    self.summaryViewController.entry = [[FDModelManager sharedManager] entry];
    if([self.pageViewController parentViewController])
        [self removeViewController:self.pageViewController];
    [self addViewController:self.summaryViewController];
}

- (void)addViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)removeViewController:(UIViewController *)viewController
{
    [viewController removeFromParentViewController];
    [viewController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Refresh pages in case new ones were added when page appears
- (void)refreshPages
{
    //Number of questions + Treatments + Notes
    self.numPages = [[FDModelManager sharedManager] numberOfQuestionSections] + 2;
    if([[FDModelManager sharedManager] symptoms].count == 0) { //Add symptom page
        self.numPages++;
    }
    if([[FDModelManager sharedManager] conditions].count == 0) { //Add condition page
        self.numPages++;
    }
    
    FDPageContentViewController *startingViewController = [self viewControllerAtIndex:self.pageIndex];
    startingViewController.mainViewDelegate = self;
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)adjustPageIndexForRemovedItem:(int)firstIndex
{
    if(firstIndex != _pageIndex)
        _pageIndex--;
}

- (void)toggleCardBumped
{
    CGRect frame = _pageViewController.view.frame;
    if(_cardBumped) {
        [_pageViewController.view setFrame:CGRectMake(frame.origin.x, frame.origin.y + CARD_BUMP_OFFSET, frame.size.width, frame.size.height)];
    } else {
        [_pageViewController.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - CARD_BUMP_OFFSET, frame.size.width, frame.size.height)];
    }
    _cardBumped = !_cardBumped;
}

- (void)openPage:(int)pageIndex
{
    [self showPages];
    self.pageIndex = pageIndex;
    [self refreshPages];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FDPageContentViewController *) viewController).pageIndex;
    
    if(index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FDPageContentViewController *) viewController).pageIndex;
    
    if(index == NSNotFound) {
        return nil;
    }
    
    index++;
    if(index == self.numPages) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (FDPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if(self.numPages == 0 || index >= self.numPages) {
        return nil;
    }
    
    //Create a new view controller and pass suitable data.
    FDPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.mainViewDelegate = self;
    pageContentViewController.pageIndex = (int)index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.numPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pageIndex;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    FDPageContentViewController *pvc = previousViewControllers[0];
    FDPageContentViewController *nvc = [pageViewController viewControllers][0];
    if([pvc pageIndex] < [nvc pageIndex])
        self.pageIndex++;
    else
        self.pageIndex--;
}

- (IBAction)continueButton:(id)sender
{
    if(self.pageViewController == nil)
        return;
    
    if(self.pageIndex < self.numPages - 1) {
        UIViewController *vc = [self viewControllerAtIndex:self.pageIndex+1];
        NSArray *viewControllers = @[vc];
        self.pageIndex++;
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else {
        [self submitEntry];
    }
    
}

- (void)submitEntry
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FDNetworkManager sharedManager] putEntry:[entry responseDictionaryCopy] date:[entry date] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            NSLog(@"Success!");
            
            [self showSummary];
//            [self performSegueWithIdentifier:@"finish" sender:self];
        }
        else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error submitting entry", nil)
                                        message:NSLocalizedString(@"Looks like there was a problem submitting your entry, please try again.", nil)
                                       delegate:nil
                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)openSearch:(NSString *)type
{
    _searchType = type;
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"search"]) {
        UINavigationController *dvc = (UINavigationController *)segue.destinationViewController;
        FDSearchTableViewController *searchViewController = (FDSearchTableViewController *)dvc.topViewController;
        searchViewController.mainViewDelegate = self;
        searchViewController.contentViewDelegate = self.pageViewController.viewControllers[0];
        if([_searchType isEqualToString:@"symptoms"])
            searchViewController.searchType = SearchSymptoms;
        else if([_searchType isEqualToString:@"treatments"])
            searchViewController.searchType = SearchTreatments;
        else if([_searchType isEqualToString:@"conditions"])
            searchViewController.searchType = SearchConditions;
    }
}

@end

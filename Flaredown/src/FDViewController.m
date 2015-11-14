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
#import "FDLaunchViewController.h"
#import "FDSummaryCollectionViewController.h"
#import "FDEntry.h"
#import "FDNetworkManager.h"

#import "FDLoginViewController.h"

#define CARD_BUMP_OFFSET 60
#define CARD_INSET 10
#define CARD_OFFSET_Y 80
#define CARD_HEIGHT_DIFF 140

#define ANIMATION_DURATION 0.5

#define CONTENT_RECT (CGRectMake(0, CARD_OFFSET_Y, self.view.frame.size.width, self.view.frame.size.height - CARD_HEIGHT_DIFF))

#define SUMMARY_RECT (CGRectMake(CARD_INSET, 0, CONTENT_RECT.size.width-CARD_INSET*2, CONTENT_RECT.size.height + _continueBtn.frame.size.height))
#define PAGE_RECT (CGRectMake(0, 0, CONTENT_RECT.size.width, CONTENT_RECT.size.height))
#define LAUNCH_RECT (CGRectMake(CARD_INSET, 0, CONTENT_RECT.size.width-CARD_INSET*2, CONTENT_RECT.size.height))

@interface FDViewController ()

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *previousDayButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDayButton;

@end

@implementation FDViewController

- (id)instance {
    return self;
}

- (BOOL)day:(NSDate *)dateA newerThan:(NSDate *)dateB
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:flags fromDate:dateB];
    NSDate *dateBDay = [calendar dateFromComponents:components];
    
    components = [calendar components:flags fromDate:dateA];
    NSDate *dateADay = [calendar dateFromComponents:components];
    
    return [dateBDay compare:dateADay] == NSOrderedAscending;
}

- (BOOL)dateOlderThanToday:(NSDate *)date
{
    return ![self day:date newerThan:[NSDate date]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Style
    [FDStyle addRoundedCornersToView:_continueBtn];
    [FDStyle addShadowToView:_continueBtn];
    _continueBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_continueBtn];
    
    [_continueBtn setTitle:FDLocalizedString(@"onboarding/continue") forState:UIControlStateNormal];
    [_continueBtn setHidden:YES];
    
    if([self selectedDateIsToday])
        [_nextDayButton setHidden:YES];
    
    //Localized date
//    NSString *dateString = [[[FDModelManager sharedManager] entry] date];
    NSDate *now = [NSDate date];
    [self setDateTitle:now];
    
    _contentView = [[UIView alloc] initWithFrame:CONTENT_RECT];
    [self.view addSubview:_contentView];
    
    self.launchViewController = (FDLaunchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"launch"];
    self.launchViewController.view.frame = CGRectMake(LAUNCH_RECT.origin.x, self.view.frame.size.height, LAUNCH_RECT.size.width, LAUNCH_RECT.size.height);
    [self.launchViewController setMainViewDelegate:self];
    
    //Create page view controller
    self.pageIndex = 0;
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:@{UIPageViewControllerOptionInterPageSpacingKey:@10}];
    self.pageViewController.view.frame = CGRectMake(PAGE_RECT.origin.x, self.view.frame.size.height, PAGE_RECT.size.width, PAGE_RECT.size.height);
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self refreshPages];
    
    //Create summary view controller
    self.summaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"summary"];
    self.summaryViewController.view.frame = CGRectMake(SUMMARY_RECT.origin.x, self.view.frame.size.height, SUMMARY_RECT.size.width, SUMMARY_RECT.size.height);
    [self.summaryViewController setMainViewDelegate:self];
    self.summaryViewController.entry = [[FDModelManager sharedManager] entry];
    
    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    if([[FDModelManager sharedManager] entry]) {
        // Convert string to date object
        
//        NSDate *date = [FDStyle dateFromString:[[[FDModelManager sharedManager] entry] date] detailed:NO];
//        if([self dateOlderThanToday:date]) {
//            [[FDModelManager sharedManager] setEntry:nil];
//            //            [[FDModelManager sharedManager] entry];
//        }
    }
    
    if(![[FDModelManager sharedManager] userObject]) {
        _loginNeeded = YES;
        return;
    }
    
    [self loadEntry];
    
    [[FDNetworkManager sharedManager] getLocale:[[FDLocalizationManager sharedManager] currentLocale] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id response) {
        if(success) {
            NSLog(@"Success!");
            
            [[FDLocalizationManager sharedManager] setLocalizationDictionaryForCurrentLocale:response];
        } else {
            NSLog(@"Failure!");
        }
    }];
}

- (void)loadEntry
{
    FDUser __block *user = [[FDModelManager sharedManager] userObject];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FDNetworkManager sharedManager] getUserWithEmail:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        if(success) {
            NSLog(@"Success!");
            
            FDUser *newUser = [[FDUser alloc] initWithDictionary:responseObject];
            if([[user updatedAt] compare:[user updatedAt]] == NSOrderedDescending) {
                NSLog(@"Updated user");
                [[FDModelManager sharedManager] setUserObject:newUser];
                user = newUser;
            }
        } else {
            NSLog(@"Failure!");
            NSLog(@"Error retreiving latest user from server");
        }
    }];
    
    NSDate *now = [NSDate date];
    NSString *dateString = [FDStyle dateStringForDate:now detailed:NO];
    
    [[FDNetworkManager sharedManager] createEntryWithEmail:[user email] authenticationToken:[user authenticationToken] date:dateString completion:^(bool success, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            NSLog(@"Success!");
            
            FDEntry *oldEntry = [[FDModelManager sharedManager] entry];
            FDEntry *entry = [[FDEntry alloc] initWithDictionary:[responseObject objectForKey:@"entry"]];
            if(!oldEntry || [[entry updatedAt] compare:[oldEntry updatedAt]] == NSOrderedDescending) {
                
                NSLog(@"New entry");
                _entryLoaded = NO;
                
                [[FDModelManager sharedManager] setEntry:entry forDate:now];
                [[FDModelManager sharedManager] setSelectedDate:now];
                
                for (NSDictionary *input in [responseObject objectForKey:@"inputs"]) {
                    [[FDModelManager sharedManager] addInput:[[FDInput alloc] initWithDictionary:input]];
                }
            } else {
                _entryLoaded = YES;
            }
            
            if(!oldEntry || [self day:[entry updatedAt] newerThan:[oldEntry updatedAt]])
                _entryPreloaded = NO;
            else
                _entryPreloaded = YES;
            
        } else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retreiving entry", nil)
                                        message:NSLocalizedString(@"Looks like there was a problem retreiving your entry, please try again.", nil)
                                       delegate:nil
                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                              otherButtonTitles:nil] show];
        }
        _entryLoaded = YES;
        
        if(_entryPreloaded) {
            [_summaryViewController setPreloaded:YES];
            [self showSummary];
        } else
            [self showLaunch];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(_loginNeeded) {
        _loginNeeded = NO;
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)setDateTitle:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
}

- (void)showLaunch
{
    [self hideActiveViewController];
    
    [self transitionToViewController:self.launchViewController withFrame:LAUNCH_RECT continueButton:NO];
    
    [_continueBtn setHidden:YES];
}

- (void)hideActiveViewController
{
    if([self.activeViewController parentViewController])
        [self.activeViewController willMoveToParentViewController:nil];
}

- (void)showPages
{
    [self hideActiveViewController];

    [self transitionToViewController:self.pageViewController withFrame:PAGE_RECT continueButton:YES];
    
    [[FDModelManager sharedManager] saveSession];
}

- (void)showSummary
{
    [self hideActiveViewController];
    
    self.summaryViewController.entry = [[FDModelManager sharedManager] entry];
    
    [self transitionToViewController:self.summaryViewController withFrame:SUMMARY_RECT continueButton:NO];
}

- (void)transitionToViewController:(UIViewController *)viewController withFrame:(CGRect)frame continueButton:(BOOL)continueButtonOn
{
    [self addViewController:viewController];
    
    CGRect offscreenRect = CGRectMake(self.activeViewController.view.frame.origin.x, self.view.frame.size.height, self.activeViewController.view.frame.size.width, self.view.frame.size.height);
    if(self.activeViewController && [self.activeViewController parentViewController]) {
        [self transitionFromViewController:self.activeViewController toViewController:viewController duration:ANIMATION_DURATION options:0 animations:^{
            viewController.view.frame = frame;
            self.activeViewController.view.frame = offscreenRect;
        } completion:^(BOOL finished) {
            [self removeViewController:self.activeViewController];
            [viewController didMoveToParentViewController:self];
            self.activeViewController = viewController;
            [_continueBtn setHidden:!continueButtonOn];
        }];
    } else {
        viewController.view.frame = frame;
        self.activeViewController.view.frame = offscreenRect;
        self.activeViewController = viewController;
        [_continueBtn setHidden:!continueButtonOn];
    }
}

- (void)hideSummary
{
    if([self.summaryViewController parentViewController])
        [self.summaryViewController willMoveToParentViewController:nil];
}

- (void)refreshSummary
{
    [self.summaryViewController refresh];
}

- (void)addViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.contentView addSubview:viewController.view];
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

- (void)launch
{
    [self refreshPages];
    [self showPages];
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
    [FDStyle addRoundedCornersToView:startingViewController.view];
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
    [self nextQuestion];
}

- (void)nextQuestion
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

- (IBAction)previousDayButton:(id)sender
{
    [self getPreviousEntry];
    if(_nextDayButton.hidden)
       [_nextDayButton setHidden:NO];
}

- (IBAction)nextDayButton:(id)sender
{
    [self getNextEntry];
    if([self selectedDateIsToday])
        [_nextDayButton setHidden:YES];
}

- (BOOL)selectedDateIsToday
{
    return [[NSCalendar currentCalendar] isDateInToday:[[FDModelManager sharedManager] selectedDate]];
}

- (void)getEntryForDate:(NSDate *)date
{
    FDModelManager *modelManager = [FDModelManager sharedManager];
    
    FDUser *user = [modelManager userObject];
    NSString *dateString = [FDStyle dateStringForDate:date detailed:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FDNetworkManager sharedManager] createEntryWithEmail:[user email] authenticationToken:[user authenticationToken] date:dateString completion:^(bool success, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            FDEntry *entry = [[modelManager entries] objectForKey:[FDStyle dateStringForDate:date detailed:NO]];
            FDEntry *newEntry = [[FDEntry alloc] initWithDictionary:[responseObject objectForKey:@"entry"]];
            if(!entry || [[entry updatedAt] compare:[newEntry updatedAt]] == NSOrderedAscending) {
                [modelManager setEntry:newEntry forDate:date];
            }
            [modelManager setSelectedDate:date];
            [self setDateTitle:date];
            if([self selectedDateIsToday])
                [_nextDayButton setHidden:YES];
            else
                [_nextDayButton setHidden:NO];
            [self refreshSummary];
        } else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retreiving entry", nil)
                                        message:NSLocalizedString(@"Looks like there was a problem retreiving your entry, please try again.", nil)
                                       delegate:nil
                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
                              otherButtonTitles:nil] show];

        }
    }];
}

- (void)showInitialPage
{
    self.pageIndex = 0;
    [self refreshPages];
}

- (void)getPreviousEntry
{
    NSDate *date = [[FDModelManager sharedManager] selectedDate];
    date = [date dateByAddingTimeInterval:-1*24*60*60];
    [self getEntryForDate:date];
}

- (void)getNextEntry
{
    NSDate *date = [[FDModelManager sharedManager] selectedDate];
    date = [date dateByAddingTimeInterval:1*24*60*60];
    [self getEntryForDate:date];
}

- (void)submitEntry
{
//    FDEntry *entry = [[FDModelManager sharedManager] entry];
//    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    [self refreshSummary];
    [self showSummary];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[FDNetworkManager sharedManager] putEntry:[entry responseDictionaryCopy] date:[entry date] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if(success) {
//            NSLog(@"Success!");
//            
//            [self showSummary];
////            [self performSegueWithIdentifier:@"finish" sender:self];
//        }
//        else {
//            NSLog(@"Failure!");
//            
//            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error submitting entry", nil)
//                                        message:NSLocalizedString(@"Looks like there was a problem submitting your entry, please try again.", nil)
//                                       delegate:nil
//                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
//                              otherButtonTitles:nil] show];
//        }
//    }];
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
    } else if([segue.identifier isEqualToString:@"login"]) {
        FDLoginViewController *loginViewController = (FDLoginViewController *)segue.destinationViewController;
        [loginViewController setMainViewDelegate:self];
    }
}

@end

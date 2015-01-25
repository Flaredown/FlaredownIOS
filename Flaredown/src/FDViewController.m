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
#import "MBProgressHUD.h"
#import "FDPageContentViewController.h"

@interface FDViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation FDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Style
    _continueBtn.layer.cornerRadius = 8;
    
    _continueBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
    _continueBtn.layer.shadowOpacity = 0.1;
    _continueBtn.layer.shadowRadius = 0;
    _continueBtn.layer.shadowOffset = CGSizeMake(0, 4);
    _continueBtn.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:_continueBtn];
    
    //Localized date
    NSString *dateString = [[[FDModelManager sharedManager] entry] date];
    [_dateLabel setText:dateString];
    
    self.pageIndex = 0;
    
    //Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self refreshPages];
    
    //change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height - 140);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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
    
    FDPageContentViewController *startingViewController = [self viewControllerAtIndex:self.pageIndex];
    startingViewController.mainViewDelegate = self;
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
            
            [self performSegueWithIdentifier:@"finish" sender:self];
        }
        else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error submitting entry", nil)
                                        message:NSLocalizedString(@"Looks like there was a problem submitting your entry, please try again.", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil] show];
        }
    }];
}

@end

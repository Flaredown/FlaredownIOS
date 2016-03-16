//
//  FDTagsCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 5/12/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTagsCollectionViewController.h"

#import "FDModelManager.h"

#import "FDTrackableResult.h"
#import "FDSearchTableViewController.h"
#import "FDTagsCollectionViewLayout.h"

#import "FDNetworkManager.h"
#import "FDStyle.h"
#import "FDAnalyticsManager.h"

#define CONTENT_INSET 10

@interface FDTagsCollectionViewController ()

@end

@implementation FDTagsCollectionViewController

static NSString * const AddTagIdentifier = @"addTag";
static NSString * const TagIdentifier = @"tag";
static NSString * const PopularIdentifier = @"popular";
static NSString * const PopularTagIdentifier = @"popularTag";
static NSString * const DividerIdentifier = @"divider";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height);
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.collectionView.frame.size.height);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, CONTENT_INSET, 20, CONTENT_INSET);
    
    _tags = [[[FDModelManager sharedManager] entry] tags];
    _popularTags = [[NSMutableArray alloc] init];
    
    FDModelManager *modelManager = [FDModelManager sharedManager];
    FDUser *user = [modelManager userObject];
    [[FDNetworkManager sharedManager] getPopularTagsWithEmail:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        if(success) {
            for (NSDictionary *dictionary in responseObject) {
                FDTrackableResult *result = [[FDTrackableResult alloc] initWithDictionary:dictionary];
                BOOL found = NO;
                for (NSString *tag in _tags) {
                    if([tag isEqualToString:[result name]]) {
                        found = YES;
                        break;
                    }
                }
                if(!found)
                    [_popularTags addObject:result];
            }
            [self refresh];
        }
    }];
}

- (void)refresh
{
    [self.collectionView reloadData];
    
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionViewLayout.collectionViewContentSize.height);
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.collectionView.frame.size.height);
    
    [_contentViewDelegate sizeToFitContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[FDAnalyticsManager sharedManager] trackPageView:@"Tags"];
}

- (IBAction)addTagButton:(id)sender
{
    [_mainViewDelegate openSearch:@"tags"];
//    [self performSegueWithIdentifier:@"search" sender:nil];
}

- (IBAction)tagButton:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FDTrackableResult *tag = _tags[[indexPath row]];
    [_tags removeObject:tag];
    [self refresh];
//    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (IBAction)popularTagButton:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FDTrackableResult *tag = _popularTags[[indexPath row]/2];
    if([_tags containsObject:[tag name]])
        return;
    [_tags addObject:[tag name]];
    [_popularTags removeObject:tag];
    
    [self refresh];
    
//    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
//    [indexSet addIndex:1];
//    [indexSet addIndex:3];
//    [self.collectionView reloadSections:indexSet];
}

- (UICollectionViewCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UICollectionViewCell class]]) {
            return (UICollectionViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return _tags.count;
    } else if(section == 2) {
        return 1;
    } else if(section == 3) {
        NSInteger count = _popularTags.count*2-1;
        return count > 0 ? count : 0;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if(section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddTagIdentifier forIndexPath:indexPath];
    } else if(section == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        
        button.layer.cornerRadius = button.frame.size.height/2;
        
        
//        [FDStyle addRoundedCornersToView:button];
        [button setTitle:_tags[row] forState:UIControlStateNormal];
    } else if(section == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularIdentifier forIndexPath:indexPath];
    } else if(section == 3) {
        if(row % 2 == 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularTagIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            FDTrackableResult *tag = _popularTags[row/2];
            [button setTitle:[tag name] forState:UIControlStateNormal];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:DividerIdentifier forIndexPath:indexPath];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    FDTagsCollectionViewLayout *layout = (FDTagsCollectionViewLayout *)self.collectionViewLayout;
    if(section == 1) {
        NSString *tag = _tags[row];
        return [layout sizeForTag:tag];
    } else if(section == 3) {
        if(row % 2 == 0) {
            FDTrackableResult *tag = _popularTags[row/2];
            return [layout sizeForPopularTag:tag];
        } else {
            return CGSizeMake(10, TAG_HEIGHT);
        }
    }
    return CGSizeMake(self.collectionView.bounds.size.width, 50);
}

#pragma mark navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"search"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        FDSearchTableViewController *dvc = (FDSearchTableViewController *)navigationController.viewControllers[0];
        [dvc setSearchType:SearchTags];
        [dvc setMainViewDelegate:_mainViewDelegate];
    }
}

@end

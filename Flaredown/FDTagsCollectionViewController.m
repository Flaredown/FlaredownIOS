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

#import "FDNetworkManager.h"
#import "FDStyle.h"

@interface FDTagsCollectionViewController ()

@end

@implementation FDTagsCollectionViewController

static NSString * const AddTagIdentifier = @"addTag";
static NSString * const TagIdentifier = @"tag";
static NSString * const PopularIdentifier = @"popular";
static NSString * const PopularTagIdentifier = @"popularTag";

- (void)viewDidLoad {
    [super viewDidLoad];
    _tags = [[[FDModelManager sharedManager] entry] tags];
    _popularTags = [[NSMutableArray alloc] init];
    
    FDModelManager *modelManager = [FDModelManager sharedManager];
    FDUser *user = [modelManager userObject];
    [[FDNetworkManager sharedManager] getPopularTagsWithEmail:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        if(success) {
            for (NSDictionary *dictionary in responseObject) {
                FDTrackableResult *result = [[FDTrackableResult alloc] initWithDictionary:dictionary];
                if(![_tags containsObject:result])
                    [_popularTags addObject:result];
            }
            [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:3]];
        }
            
    }];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTagButton:(id)sender
{
    
}

- (IBAction)tagButton:(id)sender
{
    
}

- (IBAction)popularTagButton:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FDTrackableResult *tag = _popularTags[[indexPath row]];
    if([_tags containsObject:[tag name]])
        return;
    [_tags addObject:[tag name]];
    [_popularTags removeObject:tag];
    
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndex:1];
    [indexSet addIndex:3];
    [self.collectionView reloadSections:indexSet];
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
        return _popularTags.count;
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
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularTagIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        FDTrackableResult *tag = _popularTags[row];
        [button setTitle:[tag name] forState:UIControlStateNormal];
    }
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if(section == 1) {
        CGRect buttonRect = [_tags[row] boundingRectWithSize:CGSizeMake(collectionView.frame.size.width-ROUNDED_CORNER_OFFSET, TAG_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TAG_FONT} context:nil];
        buttonRect.size.width += ROUNDED_CORNER_OFFSET;
        return buttonRect.size;
    } else if(section == 3) {
        FDTrackableResult *tag = _popularTags[row];
        CGRect buttonRect = [[tag name] boundingRectWithSize:CGSizeMake(collectionView.frame.size.width, TAG_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TAG_FONT} context:nil];
        return buttonRect.size;
    }
    return CGSizeMake(175, 50);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
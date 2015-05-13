//
//  FDTagsCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 5/12/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTagsCollectionViewController.h"

#import "FDStyle.h"

#define ROUNDED_CORNER_OFFSET 20
#define TAG_HEIGHT 30
#define TAG_FONT [UIFont fontWithName:@"ProximaNova-Regular" size:19.0f]

@interface FDTagsCollectionViewController ()

@end

@implementation FDTagsCollectionViewController

static NSString * const AddTagIdentifier = @"addTag";
static NSString * const TagIdentifier = @"tag";

- (void)viewDidLoad {
    [super viewDidLoad];
    _tags = [@[@"poopy", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants", @"pants"] mutableCopy];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        //return 1;
    } else if(section == 3) {

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

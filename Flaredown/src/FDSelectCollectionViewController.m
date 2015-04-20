//
//  FDSelectCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/29/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDSelectCollectionViewController.h"
#import "FDModelManager.h"

#import "FDLocalizationManager.h"

@interface FDSelectCollectionViewController ()

@end

@implementation FDSelectCollectionViewController

static NSString * const imageCellIdentifier = @"imageCell";
static NSString * const numberCellIdentifier = @"numberCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)initWithQuestion:(FDQuestion *)question
{
    self.question = question;
    self.inputs = [question inputs];
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    
    self.response = [[FDResponse alloc] init];
    [self.response setResponseIdWithEntryId:[entry entryId] name:[self.question name]];
    if([entry responseForId:[self.response responseId]]) {
        self.response = [entry responseForId:[self.response responseId]];
    } else {
        self.response = [self.response initWithEntry:entry question:question];
        [[[FDModelManager sharedManager] entry] insertResponse:self.response];
    }
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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.inputs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    FDInput *input = self.inputs[[indexPath row]];
    NSString *metaLabel = [input metaLabel];
    NSString *imageStr;
    if(![[NSNull null] isEqual:metaLabel]) {
        if([metaLabel isEqualToString:@"happy_face"])
            imageStr = @"fd_smiley_best";
        else if([metaLabel isEqualToString:@"neutral_face"])
            imageStr = @"fd_smiley_ok";
        else if([metaLabel isEqualToString:@"frowny_face"])
            imageStr = @"fd_smiley_bad";
        else if([metaLabel isEqualToString:@"sad_face"])
            imageStr = @"fd_smiley_worst";
        else if([metaLabel isEqualToString:@"terrible_face"])
            imageStr = @"fd_smiley_worst";
        else
            NSLog(@"Invalid meta_label for select view: %@", metaLabel);
    }
    
    if(imageStr != nil) {
        // Face image
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        imageView.image = [UIImage imageNamed:imageStr];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:numberCellIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"%d", [input value]];
    }

    NSString *labelText = [self.inputs[[indexPath row]] label];
    if(![[NSNull null] isEqual:labelText]) {
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        label.numberOfLines = 0;
        NSString *path = [NSString stringWithFormat:@"labels/%@", [self.inputs[[indexPath row]] label]];
        label.text = FDLocalizedString(path);
    }
    
    [self setCellAppearance:cell];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.itemSelected = YES;
    
    NSInteger rows = [collectionView numberOfItemsInSection:0];
    for(int i = 0; i < rows; i++) {
        [self deselectCell:[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self selectCell:cell];
    
    return YES;
}

- (void)selectCell:(UICollectionViewCell *)cell
{
    [cell setSelected:YES];
    
    [self setCellAppearance:cell];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSInteger row = [indexPath row];
    FDInput *input = self.inputs[row];
    [self.response setValue:[input value]];
}

- (void)deselectCell:(UICollectionViewCell *)cell
{
    [cell setSelected:NO];
    
    [self setCellAppearance:cell];
}

- (void)setCellAppearance:(UICollectionViewCell *)cell
{
    UIView *mainView = (UIView *)[cell viewWithTag:1];
    
    if(cell.selected || !self.itemSelected) { //100% opacity until the first item is selected
        [mainView setAlpha:1.0];
    } else {
        [mainView setAlpha:0.3];
    }
}

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

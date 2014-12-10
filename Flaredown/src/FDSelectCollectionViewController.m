//
//  FDSelectCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/29/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDSelectCollectionViewController.h"

@interface FDSelectCollectionViewController ()

@end

@implementation FDSelectCollectionViewController

static NSString * const itemCellIdentifier = @"itemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)initWithQuestion:(FDQuestion *)question
{
    self.question = question;
    
    NSMutableArray *inputs = [[NSMutableArray alloc] init];
    for(int i = 0; i < [[question inputIds] count]; i++) {
        FDInput *input = [[FDModelManager sharedManager] inputForId:[[question inputIds][i] intValue]];
        [inputs addObject:input];
    }
    self.inputs = [inputs copy];
    
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    
    self.response = [[FDResponse alloc] init];
    [self.response setResponseIdWithEntryId:[entry entryId] name:[self.question name]];
    if([entry responseForId:[self.response responseId]]) {
        self.response = [entry responseForId:[self.response responseId]];
    } else {
        [self.response setName:[question name]];
        [self.response setValue:0];
        [self.response setCatalog:[question catalog]];
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCellIdentifier forIndexPath:indexPath];
    
    // Face image
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    
    NSString *metaLabel = [self.inputs[[indexPath row]] metaLabel];
    if(![[NSNull null] isEqual:metaLabel]) {
        NSString *imageStr;
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
        
        if(imageStr != nil)
            imageView.image = [UIImage imageNamed:imageStr];
    }

    NSString *labelText = [self.inputs[[indexPath row]] label];
    if(![[NSNull null] isEqual:labelText]) {
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        label.numberOfLines = 0;
        label.text = [self.inputs[[indexPath row]] label];
    }
    
    return cell;
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

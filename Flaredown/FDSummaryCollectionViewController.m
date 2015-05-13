//
//  FDSummaryCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 5/12/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDSummaryCollectionViewController.h"
#import "FDLocalizationManager.h"
#import "FDStyle.h"
#import "FDModelManager.h"

#define CONDITION_TITLE_SECTION 0
#define CONDITION_BASE_SECTION (CONDITION_TITLE_SECTION+1)
#define CONDITION_COUNT [[_entry questionsForCatalog:@"conditions"] count]

#define SYMPTOM_TITLE_SECTION (CONDITION_BASE_SECTION+CONDITION_COUNT)
#define SYMPTOM_BASE_SECTION (SYMPTOM_TITLE_SECTION+1)
#define SYMPTOM_COUNT [[_entry questionsForCatalog:@"symptoms"] count]

@interface FDSummaryCollectionViewController ()

@end

@implementation FDSummaryCollectionViewController

static NSString * const TitleIdentifier = @"title";
static NSString * const ItemNameIdentifier = @"itemName";
static NSString * const ItemValueIdentifier = @"itemValue";
static NSString * const ItemNoneIdentifier = @"itemNone";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.collectionView reloadData];
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

- (IBAction)titleButton:(id)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[self parentCellForView:sender];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSUInteger section = [indexPath section];
    
    if(section == CONDITION_TITLE_SECTION) {
        //conditions
        [_mainViewDelegate openPage:0];
    } else if(section == SYMPTOM_TITLE_SECTION) {
        //symptoms
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]-SYMPTOM_COUNT+1];
    }
}

- (IBAction)questionButton:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)[self parentCellForView:sender];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSUInteger section = [indexPath section];
    
    if(section >= CONDITION_BASE_SECTION && section < CONDITION_BASE_SECTION+CONDITION_COUNT) {
        //conditions
        [_mainViewDelegate openPage:0+section-CONDITION_BASE_SECTION];
    } else if(section >= SYMPTOM_BASE_SECTION && section < SYMPTOM_BASE_SECTION+SYMPTOM_COUNT) {
        //symptoms
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]-SYMPTOM_COUNT+1+section-SYMPTOM_BASE_SECTION];
    }
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
    
    NSUInteger conditions = CONDITION_COUNT+1;
    NSUInteger symptoms = SYMPTOM_COUNT+1;
    
    return conditions + symptoms;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == CONDITION_TITLE_SECTION) {
        return 1;
    } else if(section < CONDITION_BASE_SECTION + CONDITION_COUNT) {
        FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE_SECTION];
        return [self numberOfItemsForQuestion:question];
    } else if(section == SYMPTOM_TITLE_SECTION) {
        return 1;
    } else if(section < SYMPTOM_BASE_SECTION + SYMPTOM_COUNT) {
        int i = SYMPTOM_BASE_SECTION;
        FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE_SECTION];
        return [self numberOfItemsForQuestion:question];
    }
    return 0;
}

- (NSInteger)numberOfItemsForQuestion:(FDQuestion *)question
{
    if(![_entry responseForQuestion:question] || [[_entry responseForQuestion:question] value] < 0) {
        return 2;
    }
    return 1 + [[_entry responseForQuestion:question] value];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSUInteger numConditions = [[_entry questionsForCatalog:@"conditions"] count];
    NSUInteger numSymptoms = [[_entry questionsForCatalog:@"symptoms"] count];
    
    UICollectionViewCell *cell;
    
    if(section == CONDITION_TITLE_SECTION) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        [button setTitle:FDLocalizedString(@"conditions") forState:UIControlStateNormal];
        
    } else if(section < CONDITION_BASE_SECTION + CONDITION_COUNT) {
        
        FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE_SECTION];
        FDResponse *response = [_entry responseForQuestion:question];
        
        if(row == 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNameIdentifier forIndexPath:indexPath];
            
            //1 Label
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            [label setText:[question name]];
            
        } else if(response && [response value] > 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemValueIdentifier forIndexPath:indexPath];
            [FDStyle addSmallRoundedCornersToView:cell];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
        }
        
    } else if(section == SYMPTOM_TITLE_SECTION) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        [button setTitle:FDLocalizedString(@"symptoms") forState:UIControlStateNormal];
        
    } else if(section < SYMPTOM_BASE_SECTION + SYMPTOM_COUNT) {
        
        FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE_SECTION];
        FDResponse *response = [_entry responseForQuestion:question];
        
        if(row == 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNameIdentifier forIndexPath:indexPath];
            
            //1 Label
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            [label setText:[question name]];
            
        } else if(response && [response value] > 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemValueIdentifier forIndexPath:indexPath];
            [FDStyle addSmallRoundedCornersToView:cell];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
        }
    }
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if(section == CONDITION_TITLE_SECTION) {
        return CGSizeMake(collectionView.frame.size.width, 55);
    } else if(section < CONDITION_BASE_SECTION + CONDITION_COUNT) {
        FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE_SECTION];
        FDResponse *response = [_entry responseForQuestion:question];
        
        if(row == 0)
            return CGSizeMake(collectionView.frame.size.width, 35);
        else if(response && [response value] > 0)
            return CGSizeMake(54, 15);
        else
            return CGSizeMake(75, 25);
    } else if(section == SYMPTOM_TITLE_SECTION) {
        return CGSizeMake(collectionView.frame.size.width, 55);
    } else if(section < SYMPTOM_BASE_SECTION + SYMPTOM_COUNT) {
        FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE_SECTION];
        FDResponse *response = [_entry responseForQuestion:question];
        
        if(row == 0)
            return CGSizeMake(collectionView.frame.size.width, 35);
        else if(response && [response value] > 0)
            return CGSizeMake(54, 15);
        else
            return CGSizeMake(75, 25);
    }
    return CGSizeZero;
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

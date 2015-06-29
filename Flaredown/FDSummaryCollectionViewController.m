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

#define CONDITION_TITLE 0
#define CONDITION_BASE (CONDITION_TITLE+1)
#define CONDITION_COUNT [[_entry questionsForCatalog:@"conditions"] count]
#define NO_CONDITIONS (CONDITION_COUNT == 0)
#define CONDITION_END (CONDITION_BASE + (NO_CONDITIONS ? 1 : CONDITION_COUNT))

#define SYMPTOM_TITLE (CONDITION_END)
#define SYMPTOM_BASE (SYMPTOM_TITLE+1)
#define SYMPTOM_COUNT [[_entry questionsForCatalog:@"symptoms"] count]
#define NO_SYMPTOMS (SYMPTOM_COUNT == 0)
#define SYMPTOM_END (SYMPTOM_BASE + (NO_SYMPTOMS ? 1 : SYMPTOM_COUNT))

#define TREATMENT_TITLE (SYMPTOM_END)
#define TREATMENT_BASE (TREATMENT_TITLE+1)
#define TREATMENT_COUNT [[_entry treatments] count]
#define NO_TREATMENTS (TREATMENT_COUNT == 0)
#define TREATMENT_END (TREATMENT_BASE + (NO_TREATMENTS ? 1 : TREATMENT_COUNT))

#define TAG_TITLE (TREATMENT_END)
#define TAG_BASE (TAG_TITLE+1)
#define TAG_COUNT [[_entry tags] count]
#define NO_TAGS (TAG_COUNT == 0)
#define TAG_END (TAG_BASE + 2)

#define NOTE_BASE (TAG_END)

@interface FDSummaryCollectionViewController ()

@end

@implementation FDSummaryCollectionViewController

static NSString * const TitleIdentifier = @"title";
static NSString * const ItemNameIdentifier = @"itemName";
static NSString * const ItemValueIdentifier = @"itemValue";
static NSString * const ItemNoneIdentifier = @"itemNone";
static NSString * const ItemNoValueIdentifier = @"itemNoValue";
static NSString * const TreatmentTakenIdentifier = @"treatmentTaken";
static NSString * const TagIdentifier = @"tag";
static NSString * const AddNoteIdentifier = @"addNote";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Style
//    self.collectionView.clipsToBounds = NO;
    self.collectionView.frame = CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+10, self.view.frame.size.width-20, self.view.frame.size.height-20);
    
    self.view.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:self.view];
    [FDStyle addShadowToView:self.collectionView];
    self.view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
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

- (IBAction)questionButton:(id)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[self parentCellForView:sender];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSUInteger section = [indexPath section];
    
    if(section >= CONDITION_BASE && section < CONDITION_END) {
        //conditions
        [_mainViewDelegate openPage:0+section-CONDITION_BASE];
    } else if(section >= SYMPTOM_BASE && section < SYMPTOM_END) {
        //symptoms
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]-SYMPTOM_COUNT+1+section-SYMPTOM_BASE];
    } else if(section >= TREATMENT_BASE && section < TREATMENT_END) {
        //treatments
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]+1];
    } else if(section >= TAG_BASE && section < TAG_END) {
        //tags
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]+2];
    }
}

- (IBAction)noItemsButton:(id)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[self parentCellForView:sender];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSUInteger section = [indexPath section];

    if(section >= CONDITION_BASE && section < CONDITION_END) {
        //conditions
        [_mainViewDelegate openPage:0];
    } else if(section >= SYMPTOM_BASE && section < SYMPTOM_END) {
        //symptoms
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]-SYMPTOM_COUNT+1];
    } else if(section >= TREATMENT_BASE && section < TREATMENT_END) {
        //treatments
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]+1];
    } else if(section >= TAG_BASE && section < TAG_END) {
        //tags
        [_mainViewDelegate openPage:[[FDModelManager sharedManager] numberOfQuestionSections]+2];
    } else if(section >= NOTE_BASE) {
        //notes
        [self performSegueWithIdentifier:@"notes" sender:nil];
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
    
    NSUInteger conditions = CONDITION_END - CONDITION_BASE + 1;
    NSUInteger symptoms = SYMPTOM_END - SYMPTOM_BASE + 1;
    NSUInteger treatments = TREATMENT_END - TREATMENT_BASE + 1;
    NSUInteger tags = 2;
    NSUInteger notes = 2;
    
    return conditions+symptoms+treatments+tags+notes;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == CONDITION_TITLE) {
        return 1;
    } else if(section < CONDITION_END) {
        if(NO_CONDITIONS)
            return 1;
        FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE];
        return [self numberOfItemsForQuestion:question];
    } else if(section == SYMPTOM_TITLE) {
        return 1;
    } else if(section < SYMPTOM_END) {
        if(NO_SYMPTOMS)
            return 1;
        FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE];
        return [self numberOfItemsForQuestion:question];
    } else if(section == TREATMENT_TITLE) {
        return 1;
    } else if(section < TREATMENT_END) {
        if(NO_TREATMENTS)
            return 1;
        FDTreatment *treatment = [_entry treatments][section-TREATMENT_BASE];
        return [self numberOfItemsForTreatment:treatment];
    } else if(section == TAG_TITLE) {
        return 1;
    } else if (section < TAG_END) {
        if(NO_TAGS)
            return 1;
        return [[[[FDModelManager sharedManager] entry] tags] count];
    } else if(section == NOTE_BASE) {
        return 1;
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

- (NSInteger)numberOfItemsForTreatment:(FDTreatment *)treatment
{
    return [[treatment doses] count] > 0 ? 1 + [[treatment doses] count] : 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    UICollectionViewCell *cell;
    
    if(section == CONDITION_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:FDLocalizedString(@"conditions")];
        
    } else if(section < CONDITION_END) {
        if(NO_CONDITIONS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
        } else {
            FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE];
            FDResponse *response = [_entry responseForQuestion:question];
            
            if(row == 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNameIdentifier forIndexPath:indexPath];
                
                //1 Label
                UILabel *label = (UILabel *)[cell viewWithTag:1];
                [label setText:[question name]];
                
            } else if(response && [response value] > 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemValueIdentifier forIndexPath:indexPath];
                
                //1 Button
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                [FDStyle addSmallRoundedCornersToView:button];
            } else {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoValueIdentifier forIndexPath:indexPath];
            }
        }
        
    } else if(section == SYMPTOM_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:FDLocalizedString(@"symptoms")];
        
    } else if(section < SYMPTOM_END) {
        if(NO_SYMPTOMS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
        } else {
            FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE];
            FDResponse *response = [_entry responseForQuestion:question];
            
            if(row == 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNameIdentifier forIndexPath:indexPath];
                
                //1 Label
                UILabel *label = (UILabel *)[cell viewWithTag:1];
                [label setText:[question name]];
                
            } else if(response && [response value] > 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemValueIdentifier forIndexPath:indexPath];
                
                //1 Button
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                [FDStyle addSmallRoundedCornersToView:button];
            } else {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoValueIdentifier forIndexPath:indexPath];
            }
        }
    } else if(section == TREATMENT_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:FDLocalizedString(@"treatments")];
        
    } else if(section < TREATMENT_END) {
        if(NO_TREATMENTS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
        } else {
            FDTreatment *treatment = [_entry treatments][section-TREATMENT_BASE];
            
            if(row == 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNameIdentifier forIndexPath:indexPath];
                
                //1 Label
                UILabel *label = (UILabel *)[cell viewWithTag:1];
                [label setText:[treatment name]];
                
            } else if([[treatment doses] count] == 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:TreatmentTakenIdentifier forIndexPath:indexPath];
            } else {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoValueIdentifier forIndexPath:indexPath];
            }
        }
    } else if(section == TAG_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:@"tags"]; //TODO:Localized
    } else if(section < TAG_END) {
        if(NO_TAGS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
        } else {
            NSString *tag = [_entry tags][row];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagIdentifier forIndexPath:indexPath];
            
            //1  Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            [button setTitle:tag forState:UIControlStateNormal];
        }
    } else if(section == NOTE_BASE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddNoteIdentifier forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        [button setTitle:@"+ Add a note" forState:UIControlStateNormal]; //TODO:Localized
    }
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if(section == CONDITION_TITLE) {
        return CGSizeMake(collectionView.frame.size.width, 40);
    } else if(section < CONDITION_END) {
        if(NO_CONDITIONS) {
            return CGSizeMake(collectionView.frame.size.width, 50);
        } else {
            FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE];
            FDResponse *response = [_entry responseForQuestion:question];
            
            if(row == 0)
                return CGSizeMake(collectionView.frame.size.width, 30);
            else if(response && [response value] > 0)
                return CGSizeMake(54, 15);
            else
                return CGSizeMake(115, 35);
        }
    } else if(section == SYMPTOM_TITLE) {
        return CGSizeMake(collectionView.frame.size.width, 40);
    } else if(section < SYMPTOM_END) {
        if(NO_SYMPTOMS) {
            return CGSizeMake(collectionView.frame.size.width, 50);
        } else {
            FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE];
            FDResponse *response = [_entry responseForQuestion:question];
            
            if(row == 0)
                return CGSizeMake(collectionView.frame.size.width, 30);
            else if(response && [response value] > 0)
                return CGSizeMake(54, 15);
            else
                return CGSizeMake(115, 35);
            }
    } else if(section == TREATMENT_TITLE) {
        return CGSizeMake(collectionView.frame.size.width, 40);
    } else if(section < TREATMENT_END) {
        if(NO_TREATMENTS) {
            return CGSizeMake(collectionView.frame.size.width, 50);
        } else {
            FDTreatment *treatment = [_entry treatments][section-TREATMENT_BASE];
            if(row == 0)
                return CGSizeMake(collectionView.frame.size.width, 30);
            else
                return CGSizeMake(115, 35);
        }
    } else if(section == TAG_TITLE) {
        return CGSizeMake(collectionView.frame.size.width, 40);
    } else if(section < TAG_END) {
        if(NO_TAGS) {
            return CGSizeMake(collectionView.frame.size.width, 50);
        } else {
            NSString *tag = [[[FDModelManager sharedManager] entry] tags][row];
            CGRect buttonRect = [tag boundingRectWithSize:CGSizeMake(collectionView.frame.size.width-ROUNDED_CORNER_OFFSET, TAG_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TAG_FONT} context:nil];
            buttonRect.size.width += ROUNDED_CORNER_OFFSET;
            return buttonRect.size;
        }
    } else if(section == NOTE_BASE) {
        return CGSizeMake(collectionView.frame.size.width, 50);
    }
    return CGSizeZero;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}

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

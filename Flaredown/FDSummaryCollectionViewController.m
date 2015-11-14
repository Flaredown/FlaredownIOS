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
#import "FDNetworkManager.h"
#import "FDAnalyticsManager.h"

#import "FDTreatmentCollectionViewController.h"
#import "FDNotesViewController.h"

#import "FDSummaryCollectionViewLayout.h"

#define CONDITION_SECTION 0
#define SYMPTOM_SECTION 1
#define TREATMENT_SECTION 2
#define TAGS_SECTION 3
#define NOTES_SECTION 4

#define CONDITION_TITLE 0
#define CONDITION_BASE (CONDITION_TITLE+1)
#define CONDITION_COUNT [[_entry questionsForCatalog:@"conditions"] count]
#define NO_CONDITIONS (CONDITION_COUNT == 0)
#define CONDITION_END (CONDITION_BASE + (NO_CONDITIONS ? 1 : CONDITION_COUNT))

#define SYMPTOM_TITLE (CONDITION_END+1)
#define SYMPTOM_BASE (SYMPTOM_TITLE+1)
#define SYMPTOM_COUNT [[_entry questionsForCatalog:@"symptoms"] count]
#define NO_SYMPTOMS (SYMPTOM_COUNT == 0)
#define SYMPTOM_END (SYMPTOM_BASE + (NO_SYMPTOMS ? 1 : SYMPTOM_COUNT))

#define TREATMENT_TITLE (SYMPTOM_END+1)
#define TREATMENT_BASE (TREATMENT_TITLE+1)
#define TREATMENT_COUNT [[_entry treatments] count]
#define NO_TREATMENTS (TREATMENT_COUNT == 0)
#define TREATMENT_END (TREATMENT_BASE + (NO_TREATMENTS ? 1 : TREATMENT_COUNT))

#define TAG_TITLE (TREATMENT_END+1)
#define TAG_BASE (TAG_TITLE+1)
#define TAG_COUNT [[_entry tags] count]
#define NO_TAGS (TAG_COUNT == 0)
#define TAG_END (TAG_BASE + 2)

#define NOTE_TITLE (TAG_END+1)
#define NOTE_BASE (NOTE_TITLE+1)
#define NO_NOTES ([[_entry notes] length] == 0)
#define NOTE_END (NOTE_BASE + 1)

#define NOTES_FONT_SIZE 16
#define NOTES_LABEL_PADDING 8
#define COLLECTION_CONTENT_INSET 10

#define SUBMIT_INFO_HEIGHT 70

@interface FDSummaryCollectionViewController ()

@end

@implementation FDSummaryCollectionViewController

static NSString * const TitleIdentifier = @"title";
static NSString * const ItemNameIdentifier = @"itemName";
static NSString * const ItemValueIdentifier = @"itemValue";
static NSString * const ItemNoneIdentifier = @"itemNone";
static NSString * const ItemNoValueIdentifier = @"itemNoValue";
static NSString * const TreatmentNoValueIdentifier = @"treatmentNoValue";
static NSString * const TreatmentTakenIdentifier = @"treatmentTaken";
static NSString * const TagIdentifier = @"tag";
static NSString * const AddNoteIdentifier = @"addNote";
static NSString * const DoseIdentifier = @"dose";
static NSString * const NotesIdentifier = @"notes";
static NSString * const EmptyIdentifier = @"empty";

static NSString * const SubmitInfoHeaderIdentifier = @"submitInfo";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    FDSummaryCollectionViewLayout *layout = (FDSummaryCollectionViewLayout *)self.collectionViewLayout;
    layout.summaryCollectionViewDelegate = self;
    
//    self.view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    self.collectionView.contentInset = UIEdgeInsetsMake(COLLECTION_CONTENT_INSET, COLLECTION_CONTENT_INSET, COLLECTION_CONTENT_INSET, COLLECTION_CONTENT_INSET);
}

- (void)viewDidAppear:(BOOL)animated
{
    [[FDAnalyticsManager sharedManager] trackPageView:@"Summary"];
    if(!_preloaded) {
        [self submitEntry];
    } else
        _preloaded = NO;
}

- (void)submitEntry
{
    FDModelManager *modelManager = [FDModelManager sharedManager];
    FDEntry *entry = [modelManager entry];
    NSDate *date = [modelManager selectedDate];
    FDUser *user = [modelManager userObject];
    [[FDNetworkManager sharedManager] putEntry:[entry dictionaryCopy] date:[FDStyle dateStringForDate:date detailed:NO] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        if(success) {
            NSLog(@"Success!");
            _failedToSubmit = NO;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            NSLog(@"Failure!");
            _failedToSubmit = YES;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            //            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error submitting entry", nil)
            //                                        message:NSLocalizedString(@"Looks like there was a problem submitting your entry, please try again.", nil)
            //                                       delegate:nil
            //                              cancelButtonTitle:FDLocalizedString(@"nav/ok_caps")
            //                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    _entry = [[FDModelManager sharedManager] entry];
    [self.collectionView reloadData];
}

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

- (BOOL)cardBackgroundForSection:(NSInteger)section
{
    return section == CONDITION_END;
}

- (IBAction)submitButton:(id)sender
{
    [self submitEntry];
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

//TODO: Sort everything into rows instead of sections. Should be conditions, symptoms, treatments, tags, notes as sections; everything else as rows

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSUInteger conditions = CONDITION_END - CONDITION_BASE + 1 + 1;
    NSUInteger symptoms = SYMPTOM_END - SYMPTOM_BASE + 1 + 1;
    NSUInteger treatments = TREATMENT_END - TREATMENT_BASE + 1 + 1;
    NSUInteger tags = 4;
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
    } else if(section == CONDITION_END) {
        return 1;
    } else if(section == SYMPTOM_TITLE) {
        return 1;
    } else if(section < SYMPTOM_END) {
        if(NO_SYMPTOMS)
            return 1;
        FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE];
        return [self numberOfItemsForQuestion:question];
    } else if(section == SYMPTOM_END) {
        return 1;
    } else if(section == TREATMENT_TITLE) {
        return 1;
    } else if(section < TREATMENT_END) {
        if(NO_TREATMENTS)
            return 1;
        FDTreatment *treatment = [_entry treatments][section-TREATMENT_BASE];
        return [self numberOfItemsForTreatment:treatment];
    } else if(section == TREATMENT_END) {
        return 1;
    } else if(section == TAG_TITLE) {
        return 1;
    } else if (section < TAG_END) {
        if(NO_TAGS || section == TAG_END - 1)
            return 1;
        return [[[[FDModelManager sharedManager] entry] tags] count];
    } else if(section == TAG_END) {
        return 1;
    } else if(section == NOTE_TITLE) {
        return 1;
    } else if(section < NOTE_END) {
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
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:FDLocalizedString(@"conditions")];
    } else if(section < CONDITION_END) {
        if(NO_CONDITIONS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            [button setTitle:@"+ Add a condition" forState:UIControlStateNormal];//TODO:Localized
            
            //2 Label
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            [label setText:@"No conditions"];//TODO:Localized
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
            } else {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoValueIdentifier forIndexPath:indexPath];
            }
        }
    } else if(section == CONDITION_END) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmptyIdentifier forIndexPath:indexPath];
    } else if(section == SYMPTOM_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:FDLocalizedString(@"symptoms")];
    } else if(section < SYMPTOM_END) {
        if(NO_SYMPTOMS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            [button setTitle:@"+ Add a symptom" forState:UIControlStateNormal];//TODO:Localized
            
            //2 Label
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            [label setText:@"No symptoms"];//TODO:Localized
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
            } else {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoValueIdentifier forIndexPath:indexPath];
            }
        }
    } else if(section == SYMPTOM_END) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmptyIdentifier forIndexPath:indexPath];
    } else if(section == TREATMENT_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Button
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:FDLocalizedString(@"treatments")];
    } else if(section < TREATMENT_END) {
        if(NO_TREATMENTS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            [button setTitle:@"+ Add a treatment" forState:UIControlStateNormal];//TODO:Localized
            
            //2 Label
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            [label setText:@"No treatments"];//TODO:Localized
        } else {
            FDTreatment *treatment = [_entry treatments][section-TREATMENT_BASE];
            
            if(row == 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNameIdentifier forIndexPath:indexPath];
                
                //1 Label
                UILabel *label = (UILabel *)[cell viewWithTag:1];
                [label setText:[treatment name]];
            } else if([[treatment doses] count] > 0) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:DoseIdentifier forIndexPath:indexPath];
                
                NSInteger doseRow = row - 1;
                
                //1 Button
                UIButton *button = (UIButton *)[cell viewWithTag:1];
                
                FDDose *dose = [treatment doses][doseRow];
                NSString *title = [NSString stringWithFormat:@"%@ %@", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]];
                [button setTitle:title forState:UIControlStateNormal];
            } else {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:TreatmentNoValueIdentifier forIndexPath:indexPath];
            }
        }
    } else if(section == TREATMENT_END) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmptyIdentifier forIndexPath:indexPath];
    } else if(section == TAG_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:@"Tags"]; //TODO:Localized
    } else if(section < TAG_END) {
        if(NO_TAGS) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemNoneIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            [button setTitle:@"+ Add a tag" forState:UIControlStateNormal];//TODO:Localized
            
            //2 Label
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            [label setText:@"No tags"];//TODO:Localized
        } else if(section == TAG_END - 1) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmptyIdentifier forIndexPath:indexPath];
        } else {
            NSString *tag = [_entry tags][row];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagIdentifier forIndexPath:indexPath];
            
            //1  Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            [button setTitle:tag forState:UIControlStateNormal];
            [FDStyle addBorderToView:button withColor:[FDStyle blueColor]];
        }
    } else if(section == TAG_END) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmptyIdentifier forIndexPath:indexPath];
    } else if(section == NOTE_TITLE) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleIdentifier forIndexPath:indexPath];
        
        //1 Label
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:@"Notes"]; //TODO:Localized
    } else if(section < NOTE_END) {
        if([[_entry notes] length] > 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NotesIdentifier forIndexPath:indexPath];
            
            //1 Label
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            [label setText:[_entry notes]];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddNoteIdentifier forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
                
            [button setTitle:@"+ Add a note" forState:UIControlStateNormal]; //TODO:Localized
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *submitInfoHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SubmitInfoHeaderIdentifier forIndexPath:indexPath];
    return submitInfoHeaderView;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    float maxWidth = self.collectionView.frame.size.width-COLLECTION_CONTENT_INSET*2;
    float placeholderHeight = 20;
    
    if(section == CONDITION_TITLE) {
        return CGSizeMake(maxWidth, 40);
    } else if(section < CONDITION_END) {
        if(NO_CONDITIONS) {
            return CGSizeMake(maxWidth, 72);
        } else {
            FDQuestion *question = [_entry questionsForCatalog:@"conditions"][section-CONDITION_BASE];
            FDResponse *response = [_entry responseForQuestion:question];
            
            if(row == 0)
                return CGSizeMake(maxWidth, 30);
            else if(response && [response value] > 0)
                return CGSizeMake(54, 15);
            else
                return CGSizeMake(maxWidth, 35);
        }
    } else if(section == CONDITION_END) {
        return CGSizeMake(maxWidth, placeholderHeight);
    } else if(section == SYMPTOM_TITLE) {
        return CGSizeMake(maxWidth, 40);
    } else if(section < SYMPTOM_END) {
        if(NO_SYMPTOMS) {
            return CGSizeMake(maxWidth, 72);
        } else {
            FDQuestion *question = [_entry questionsForCatalog:@"symptoms"][section-SYMPTOM_BASE];
            FDResponse *response = [_entry responseForQuestion:question];
            
            if(row == 0)
                return CGSizeMake(maxWidth, 30);
            else if(response && [response value] > 0)
                return CGSizeMake(54, 15);
            else
                return CGSizeMake(maxWidth, 35);
            }
    } else if(section == SYMPTOM_END) {
        return CGSizeMake(maxWidth, placeholderHeight);
    } else if(section == TREATMENT_TITLE) {
        return CGSizeMake(maxWidth, 40);
    } else if(section < TREATMENT_END) {
        if(NO_TREATMENTS) {
            return CGSizeMake(maxWidth, 72);
        } else {
            FDTreatment *treatment = [_entry treatments][section-TREATMENT_BASE];
            if(row == 0)
                return CGSizeMake(maxWidth, 30);
            else {
                if([[treatment doses] count] > 0) {
                    FDDose *dose = [treatment doses][row-1];
                    CGSize doseSize = CGSizeMake(maxWidth, 32);
                    NSString *title = [NSString stringWithFormat:@"%@ %@", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]];
                    UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:DOSE_FONT_SIZE];
                    CGRect rect = [title boundingRectWithSize:doseSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:font}
                                                      context:nil];
                    return CGSizeMake(rect.size.width+DOSE_BUTTON_PADDING, doseSize.height);
                } else
                    return CGSizeMake(maxWidth, 35);
            }
        }
    } else if (section == TREATMENT_END) {
        return CGSizeMake(maxWidth, placeholderHeight);
    } else if(section == TAG_TITLE) {
        return CGSizeMake(maxWidth, 40);
    } else if(section < TAG_END) {
        if(NO_TAGS) {
            return CGSizeMake(maxWidth, 72);
        } else if(section == TAG_END - 1) {
            return CGSizeMake(maxWidth, 15);
        } else {
            NSString *tag = [[[FDModelManager sharedManager] entry] tags][row];
            CGSize tagSize = CGSizeMake(maxWidth, 32);
            UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:DOSE_FONT_SIZE];
            CGRect rect = [tag boundingRectWithSize:tagSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            return CGSizeMake(rect.size.width+DOSE_BUTTON_PADDING, tagSize.height);
        }
    } else if(section == TAG_END) {
        return CGSizeMake(maxWidth, placeholderHeight);
    } else if(section == NOTE_TITLE) {
        return CGSizeMake(maxWidth, 40);
    } else if(section < NOTE_END) {
        if([[_entry notes] length] > 0) {
            CGSize notesSize = CGSizeMake(maxWidth - NOTES_LABEL_PADDING * 2, CGFLOAT_MAX);
            NSString *notes = [_entry notes];
            UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:NOTES_FONT_SIZE];
            CGRect rect = [notes boundingRectWithSize:notesSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            return CGSizeMake(maxWidth, rect.size.height + NOTES_LABEL_PADDING*2);
        } else {
            return CGSizeMake(maxWidth, 72);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0 && _failedToSubmit) {
        return CGSizeMake(self.collectionView.bounds.size.width, SUBMIT_INFO_HEIGHT);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"notes"]) {
        FDNotesViewController *dvc = segue.destinationViewController;
        [dvc setMainViewDelegate:_mainViewDelegate];
    }
}

- (NSArray *)cardStartSections
{
    return @[@CONDITION_TITLE,@SYMPTOM_TITLE,@TREATMENT_TITLE,@TAG_TITLE,@NOTE_TITLE];
}

- (NSArray *)cardEndSections
{
    return @[@(CONDITION_END-1),@(SYMPTOM_END-1),@(TREATMENT_END-1),@(TAG_END-1),@(NOTE_END-1)];
}

- (BOOL)sectionIsCardEnd:(NSInteger)section
{
    return section == CONDITION_END || section == SYMPTOM_END || section == TREATMENT_END || section == TAG_END;
}

- (BOOL)sectionIsCardTop:(NSInteger)section
{
    return section == CONDITION_TITLE || section == SYMPTOM_TITLE || section == TREATMENT_TITLE || section == TAG_TITLE || section == NOTE_TITLE;
}

- (BOOL)sectionIsCardBottom:(NSInteger)section
{
    return section == CONDITION_END - 1 || section == SYMPTOM_END - 1 || section == TREATMENT_END - 1 || section == TAG_END - 1 || section == NOTE_END - 1;
}

@end

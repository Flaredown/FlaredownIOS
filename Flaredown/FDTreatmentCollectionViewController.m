//
//  FDTreatmentCollectionViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 5/27/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import "FDTreatmentCollectionViewController.h"

#import "FDStyle.h"
#import "FDPopupManager.h"
#import "FDModelManager.h"
#import "FDLocalizationManager.h"

#import "HTAutocompleteManager.h"

#define CONTENT_INSET 20

@interface FDTreatmentCollectionViewController ()

@end

@implementation FDTreatmentCollectionViewController

static NSString * const TreatmentID = @"treatment";
static NSString * const AddDoseID = @"addDose";
static NSString * const DoseID = @"dose";
static NSString * const LatestDoseID = @"latestDose";

static NSString * const PreviousDoseDecorationID = @"previousDoseDecoration";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, CONTENT_INSET, 0, CONTENT_INSET);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addDose:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSInteger section = [indexPath section];
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    _selectedTreatment = treatment;
    
    UIView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"AddDoseView" owner:self options:nil] objectAtIndex:0];
    [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*POPUP_HEIGHT/2, self.view.window.frame.size.width*POPUP_WIDTH, self.view.window.frame.size.height*POPUP_HEIGHT)];
    popupView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:popupView];
    
    [_addDoseTitleLabel setText:FDLocalizedString(@"add_dose")];
    _addDoseQuantityTextField.delegate = self;
    [_addDoseQuantityTextField setPlaceholder:FDLocalizedString(@"edit_treatment_dose_placeholder")];
    _addDoseUnitTextField.delegate = self;
    [_addDoseUnitTextField setPlaceholder:FDLocalizedString(@"edit_treatment_unit_placeholder")];
    _addDoseUnitTextField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    _addDoseUnitTextField.autocompleteType = HTAutocompleteTypeTreatmentUnits;
    [_addDoseCancelButton setTitle:FDLocalizedString(@"nav/cancel") forState:UIControlStateNormal];
    [_addDoseDoneButton setTitle:FDLocalizedString(@"nav/done") forState:UIControlStateNormal];
    
    [[FDPopupManager sharedManager] addPopupView:popupView];
}

- (IBAction)addDoseDoneButton:(id)sender
{
    FDDose *dose = [[FDDose alloc] init];
    [dose setQuantity:[_addDoseQuantityTextField.text floatValue]];
    [dose setUnit:_addDoseUnitTextField.text];
    [[_selectedTreatment doses] addObject:dose];
    
    [self clearSelection];
}

- (IBAction)editDose:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    _selectedTreatment = treatment;
    FDDose *dose = [treatment doses][row-1];
    _selectedDose = dose;
    
    UIView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"EditDoseView" owner:self options:nil] objectAtIndex:0];
    [popupView setFrame:CGRectMake(self.view.window.frame.size.width/2-self.view.window.frame.size.width*POPUP_WIDTH/2, self.view.window.frame.size.height/2-self.view.window.frame.size.height*POPUP_HEIGHT/2, self.view.window.frame.size.width*POPUP_WIDTH, self.view.window.frame.size.height*POPUP_HEIGHT)];
    popupView.layer.masksToBounds = YES;
    [FDStyle addRoundedCornersToView:popupView];
    
    [_editDoseTitleLabel setText:FDLocalizedString(@"edit_dose")];
    _editDoseQuantityTextField.delegate = self;
    [_editDoseQuantityTextField setPlaceholder:FDLocalizedString(@"edit_treatment_dose_placeholder")];
    [_editDoseQuantityTextField setText:[FDStyle trimmedDecimal:[dose quantity]]];
    _editDoseUnitTextField.delegate = self;
    [_editDoseUnitTextField setPlaceholder:FDLocalizedString(@"edit_treatment_unit_placeholder")];
    [_editDoseUnitTextField setText:[dose unit]];
    _editDoseUnitTextField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    _editDoseUnitTextField.autocompleteType = HTAutocompleteTypeTreatmentUnits;
    [_editDoseCancelButton setTitle:FDLocalizedString(@"nav/cancel") forState:UIControlStateNormal];
    [_editDoseDoneButton setTitle:FDLocalizedString(@"nav/done") forState:UIControlStateNormal];
    
    [[FDPopupManager sharedManager] addPopupView:popupView];
}

- (IBAction)editDoseDoneButton:(id)sender
{
    [_selectedDose setQuantity:[_editDoseQuantityTextField.text floatValue]];
    [_selectedDose setUnit:_editDoseUnitTextField.text];
    
    [self clearSelection];
}

- (IBAction)previousDoses:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSInteger section = [indexPath section];
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    
    [self usePreviousDosesForTreatment:treatment];
    [self.collectionView reloadData];
}

- (void)usePreviousDosesForTreatment:(FDTreatment *)treatment
{
    NSArray *doses = [[[[FDModelManager sharedManager] userObject] previousDoses] objectForKey:[treatment name]];
    if(!doses)
        return;
    [treatment setDoses:[doses mutableCopy]];
}

- (IBAction)removeDoseButton:(id)sender
{
    [[_selectedTreatment doses] removeObject:_selectedDose];
    
    [self clearSelection];
}

- (IBAction)cancelButton:(id)sender
{
    [[FDPopupManager sharedManager] removeTopPopup];
}

- (void)clearSelection
{
    _selectedTreatment = nil;
    _selectedDose = nil;
    [self.collectionView reloadData];
    [[FDPopupManager sharedManager] removeTopPopup];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[[[FDModelManager sharedManager] entry] treatments] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    NSArray *previousDoses = [[[[FDModelManager sharedManager] userObject] previousDoses] objectForKey:[treatment name]];
    if([[treatment doses] count] > 0)
        return 2 + [[treatment doses] count];
    else if(previousDoses && [previousDoses count] > 0)
        return 3;
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    
    UICollectionViewCell *cell;
    
    NSArray *previousDoses = [[[[FDModelManager sharedManager] userObject] previousDoses] objectForKey:[treatment name]];
    
    BOOL usePreviousDoses = [[treatment doses] count] == 0 && [previousDoses count] > 0;
    NSInteger doseStartRow = 1;
    NSInteger lastRow = previousDoses ? doseStartRow + 1 : doseStartRow + [[treatment doses] count];
    
    if(row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TreatmentID forIndexPath:indexPath];
        
        //2 Label
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        [label setText:[treatment name]];
        [label setTextColor:[FDStyle blackColor]];
    } else if(row < lastRow) {
        if(usePreviousDoses) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:LatestDoseID forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            NSString *titleString = @"Used ";
            for(FDDose *dose in previousDoses) {
                titleString = [titleString stringByAppendingString:[NSString stringWithFormat:@"%@%@ + ", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]]];
            }
            titleString = [titleString substringToIndex:[titleString length]-3];
            [button setTitle:titleString forState:UIControlStateNormal];
            [FDStyle addSmallRoundedCornersToView:button];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:DoseID forIndexPath:indexPath];
            
            //1 Button
            UIButton *button = (UIButton *)[cell viewWithTag:1];
            
            FDDose *dose;
            dose = [treatment doses][row-doseStartRow];
            [button addTarget:self action:@selector(editDose:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *title = [NSString stringWithFormat:@"%@ %@", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]];
            [button setTitle:title forState:UIControlStateNormal];
            if(usePreviousDoses) {
                [button setTitleColor:[FDStyle whiteColor] forState:UIControlStateNormal];
                button.layer.borderWidth = 0.0;
            } else {
                [button setTitleColor:[FDStyle blueColor] forState:UIControlStateNormal];
                [FDStyle addBorderToView:button withColor:[FDStyle blueColor]];
            }
        }
    } else if(row == lastRow) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddDoseID forIndexPath:indexPath];
        
        //1 Label
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        if(usePreviousDoses) {
            //TODO: Localized
            [button setTitle:@"Used a different dose..." forState:UIControlStateNormal];
            [FDStyle addBorderToView:button withColor:[FDStyle blueColor]];
            [FDStyle addSmallRoundedCornersToView:button];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            //TODO: Localized
            [button setTitle:@"Add dose" forState:UIControlStateNormal];
            button.layer.borderWidth = 0.0;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        [button setTitleColor:[FDStyle blueColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    CGSize treatmentSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 30);
    CGSize addDoseSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 30);
    CGSize doseSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 32);
    CGSize useLatestSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 40);
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    
    NSArray *previousDoses = [[[[FDModelManager sharedManager] userObject] previousDoses] objectForKey:[treatment name]];
    
    BOOL usePreviousDoses = [[treatment doses] count] == 0 && [previousDoses count] > 0;
    NSInteger doseStartRow = 1;
    NSInteger lastRow = previousDoses ? doseStartRow + 1 : doseStartRow + [[treatment doses] count];
    
    if(row == 0) {
        return treatmentSize;
    } else if(row < lastRow) {
        if(usePreviousDoses) {
            return useLatestSize;
        } else {
            FDDose *dose = [treatment doses][row-doseStartRow];
            NSString *title = [NSString stringWithFormat:@"%@ %@", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]];
            UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:DOSE_FONT_SIZE];
            CGRect rect = [title boundingRectWithSize:doseSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            return CGSizeMake(rect.size.width+DOSE_BUTTON_PADDING, doseSize.height);
        }
    } else if(row == lastRow) {
        if(previousDoses)
            return useLatestSize;
        else
            return addDoseSize;
    }
    
    return CGSizeZero;
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *allAttributes = [[NSMutableArray alloc] initWithCapacity:4];
//    
//    [allAttributes addObject:[self layoutAttributesForDecorationViewOfKind:@"FloorPlan" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
//    
//    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
//    {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [allAttributes addObject:layoutAttributes];
//    }
//    return allAttributes;
//}

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


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

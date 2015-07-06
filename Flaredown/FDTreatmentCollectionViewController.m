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

#define CONTENT_INSET 20

#define DOSE_FONT_SIZE 15
#define DOSE_BUTTON_PADDING 25

@interface FDTreatmentCollectionViewController ()

@end

@implementation FDTreatmentCollectionViewController

static NSString * const TreatmentID = @"treatment";
static NSString * const AddDoseID = @"addDose";
static NSString * const DoseID = @"dose";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
    
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
    
    _selectedTreatment = nil;
    [self.collectionView reloadData];
    [[FDPopupManager sharedManager] removeTopPopup];
}

- (IBAction)editDose:(id)sender
{
    UICollectionViewCell *cell = [self parentCellForView:sender];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
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
    [_editDoseCancelButton setTitle:FDLocalizedString(@"nav/cancel") forState:UIControlStateNormal];
    [_editDoseDoneButton setTitle:FDLocalizedString(@"nav/done") forState:UIControlStateNormal];
    
    [[FDPopupManager sharedManager] addPopupView:popupView];
}

- (IBAction)editDoseDoneButton:(id)sender
{
    [_selectedDose setQuantity:[_editDoseQuantityTextField.text floatValue]];
    [_selectedDose setUnit:_editDoseUnitTextField.text];
    
    _selectedDose = nil;
    [self.collectionView reloadData];
    [[FDPopupManager sharedManager] removeTopPopup];
}

- (IBAction)cancelButton:(id)sender
{
    [[FDPopupManager sharedManager] removeTopPopup];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[[[FDModelManager sharedManager] entry] treatments] count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    return [[treatment doses] count] > 0 ? 2 + [[treatment doses] count] : 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    
    UICollectionViewCell *cell;
    
    if(row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TreatmentID forIndexPath:indexPath];
        
        //2 Label
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        [label setText:[treatment name]];
        [label setTextColor:[FDStyle blackColor]];
    } else if(row <= [[treatment doses] count]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:DoseID forIndexPath:indexPath];
        
        //1 Button
        UIButton *button = (UIButton *)[cell viewWithTag:1];
        
        FDDose *dose = [treatment doses][row-1];
        NSString *title = [NSString stringWithFormat:@"%@ %@", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]];
        [button setTitle:title forState:UIControlStateNormal];
        [FDStyle addBorderToView:button withColor:[FDStyle blueColor]];
        [FDStyle addRoundedCornersToView:button];
    } else if(row == [[treatment doses] count] + 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddDoseID forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    CGSize treatmentSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 45);
    CGSize addDoseSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 20);
    CGSize doseSize = CGSizeMake(collectionView.frame.size.width-CONTENT_INSET*2, 30);
    
    FDTreatment *treatment = [[[FDModelManager sharedManager] entry] treatments][section];
    
    if(row == 0)
        return treatmentSize;
    else if(row == [[treatment doses] count]+1)
        return addDoseSize;
    else {
        FDDose *dose = [treatment doses][row-1];
        NSString *title = [NSString stringWithFormat:@"%@ %@", [FDStyle trimmedDecimal:[dose quantity]], [dose unit]];
        UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:DOSE_FONT_SIZE];
        CGRect rect = [title boundingRectWithSize:doseSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil];
        return CGSizeMake(rect.size.width+DOSE_BUTTON_PADDING, doseSize.height);
    }
    
    return CGSizeZero;
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

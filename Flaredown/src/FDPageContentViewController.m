//
//  FDPageContentViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDPageContentViewController.h"
#import "FDContainerViewController.h"
#import "FDModelManager.h"

@interface FDPageContentViewController ()

@end

@implementation FDPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSInteger numSections = [[FDModelManager sharedManager] numberOfQuestionSections];
    if(_pageIndex >= numSections) {
        if(_pageIndex == numSections-1) { // TODO: change these numbers
            //Treatments
            self.titleLabel.text = NSLocalizedString(@"Treatments", nil);
        } else if(_pageIndex == numSections) {
            //Notes
            self.titleLabel.text = NSLocalizedString(@"Notes", nil);
        }
    } else {
        FDQuestion *question = [[FDModelManager sharedManager] questionsForSection:_pageIndex][0];
        if(![[NSNull null] isEqual:[question name]])
            self.titleLabel.text = [question name];
        
        if([[question catalog] isEqualToString:@"symptoms"]) {
            [self.secondaryTitleButton setTitle:@"Edit Symptoms" forState:UIControlStateNormal];
            [self.secondaryTitleButton addTarget:self action:@selector(editSymptoms) forControlEvents:UIControlEventTouchUpInside];
            self.providesPresentationContextTransitionStyle = YES;
            self.definesPresentationContext = YES;
        }
    }
    
//    if(![[NSNull null] isEqual:[question group]]) {
//        
//        NSString *title = [question group];
//        /* create a locale where diacritic marks are not considered important, e.g. US English */
//        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
//        
//        /* get first char */
//        NSString *firstChar = [title substringToIndex:1];
//        
//        /* remove any diacritic mark */
//        NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
//        
//        /* create the new string */x
//        self.titleLabel.text = [[folded uppercaseString] stringByAppendingString:[title substringFromIndex:1]];
//
}

- (void)editSymptoms
{
    [self performSegueWithIdentifier:@"editList" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ContainerEmbedSegueIdentifier]) {
        FDContainerViewController *containerViewController = (FDContainerViewController *)segue.destinationViewController;
        containerViewController.pageIndex = self.pageIndex;
    } else if([segue.identifier isEqualToString:@"editList"]) {
        [segue.destinationViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
}


@end

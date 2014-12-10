//
//  FDViewController.m
//  Flaredown
//
//  Created by Cole Cunningham on 9/23/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import "FDViewController.h"
#import "FDNetworkManager.h"
#import "FDModelManager.h"
#import "MBProgressHUD.h"

@interface FDViewController ()

@end

@implementation FDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numPages = [[FDModelManager sharedManager] numberOfQuestionSections];
    self.pageIndex = 0;
    
    //Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    FDPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height - 140);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FDPageContentViewController *) viewController).pageIndex;
    
    if(index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FDPageContentViewController *) viewController).pageIndex;
    
    if(index == NSNotFound) {
        return nil;
    }
    
    index++;
    if(index == self.numPages) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (FDPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if(self.numPages == 0 || index >= self.numPages) {
        return nil;
    }
    
    //Create a new view controller and pass suitable data.
    FDPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = (int)index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.numPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pageIndex;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    FDPageContentViewController *pvc = previousViewControllers[0];
    FDPageContentViewController *nvc = [pageViewController viewControllers][0];
    if([pvc pageIndex] < [nvc pageIndex])
        self.pageIndex++;
    else
        self.pageIndex--;
}

- (IBAction)continueButton:(id)sender
{
//    UIViewController *cont = self.pageViewController;
    if(self.pageIndex < self.numPages - 1) {
        UIViewController *vc = [self viewControllerAtIndex:self.pageIndex+1];
        NSArray *viewControllers = @[vc];
        self.pageIndex++;
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else {
        [self submitEntry];
    }
    
}

- (void)submitEntry
{
    FDEntry *entry = [[FDModelManager sharedManager] entry];
    FDUser *user = [[FDModelManager sharedManager] userObject];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FDNetworkManager sharedManager] putEntry:[entry dictionaryCopy] atId:[entry entryId] email:[user email] authenticationToken:[user authenticationToken] completion:^(bool success, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            NSLog(@"Success!");
            
            [self performSegueWithIdentifier:@"finish" sender:self];
        }
        else {
            NSLog(@"Failure!");
            
            [[[UIAlertView alloc] initWithTitle:@"Error submitting entry"
                                        message:@"Looks like there was a problem submitting your entry, please try again."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

//- (NSDictionary *)getResponse
//{
//    NSDictionary *response = @{
//                               @"entry": @{
//                                       @"date": @"2014-09-22",
//                                       @"id": @"xyz789",
//                                       @"questions": @[
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @57,
//                                                   @"input_ids": @[
//                                                           @65,
//                                                           @66,
//                                                           @67,
//                                                           @68
//                                                           ],
//                                                   @"kind": @"select",
//                                                   @"localized_name": @"What is your level of abdominal pain?",
//                                                   @"name": @"ab_pain",
//                                                   @"section": @1
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @58,
//                                                   @"input_ids": @[
//                                                           @69,
//                                                           @70,
//                                                           @71,
//                                                           @72,
//                                                           @73
//                                                           ],
//                                                   @"kind": @"select",
//                                                   @"localized_name": @"What is your general level of pain?",
//                                                   @"name": @"general",
//                                                   @"section": @2
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @59,
//                                                   @"input_ids": @[
//                                                           @74,
//                                                           @75,
//                                                           @76
//                                                           ],
//                                                   @"kind": @"select",
//                                                   @"localized_name": @"Do you have an abdominal mass?",
//                                                   @"name": @"mass",
//                                                   @"section": @3
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @60,
//                                                   @"input_ids": @[
//                                                           @77
//                                                           ],
//                                                   @"kind": @"number",
//                                                   @"localized_name": @"How many soft/liquid stools did you pass today?",
//                                                   @"name": @"stools",
//                                                   @"section": @4
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @61,
//                                                   @"input_ids": @[
//                                                           @78
//                                                           ],
//                                                   @"kind": @"number",
//                                                   @"localized_name": @"Hematocrit level (optional)",
//                                                   @"name": @"hematocrit",
//                                                   @"section": @5
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @62,
//                                                   @"input_ids": @[
//                                                           @79
//                                                           ],
//                                                   @"kind": @"number",
//                                                   @"localized_name": @"What is your current weight?",
//                                                   @"name": @"weight_current",
//                                                   @"section": @6
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": [NSNull null],
//                                                   @"id": @63,
//                                                   @"input_ids": @[
//                                                           @80
//                                                           ],
//                                                   @"kind": @"number",
//                                                   @"localized_name": @"What is your typical weight?",
//                                                   @"name": @"weight_typical",
//                                                   @"section": @7
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @64,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Are you taking lomotil or opiates for diarrhea?",
//                                                   @"name": @"opiates",
//                                                   @"section": @8
//                                                   },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @65,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Arthritis",
//                                                   @"name": @"complication_arthritis",
//                                                   @"section": @8
//                                               },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @66,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Iritis or uveitis",
//                                                   @"name": @"complication_iritis",
//                                                   @"section": @8
//                                               },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @67,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Erythema nodosum, pyoderma gangrenosum, or aphthous ulcers",
//                                                   @"name": @"complication_erythema",
//                                                   @"section": @8
//                                               },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @68,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Fever",
//                                                   @"name": @"complication_fever",
//                                                   @"section": @8
//                                               },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @69,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Anal fistula, fissure, or abcess",
//                                                   @"name": @"complication_fistula",
//                                                   @"section": @8
//                                               },
//                                               @{
//                                                   @"catalog": @"cdai",
//                                                   @"group": @"complications",
//                                                   @"id": @70,
//                                                   @"input_ids": @[],
//                                                   @"kind": @"checkbox",
//                                                   @"localized_name": @"Other fistula",
//                                                   @"name": @"complication_other_fistula",
//                                                   @"section": @8
//                                               }
//                                               ],
//                                       @"responses": @[
//                                                     @{
//                                                         @"id": @"ab_pain_d07b851b0f241f707dafa7c3619ad12a",
//                                                         @"name": @"ab_pain",
//                                                         @"value": @3
//                                                     }
//                                                 ],
//                                       @"scores": @[
//                                                  @{
//                                                      @"id": @"cdai_d07b851b0f241f707dafa7c3619ad12a",
//                                                      @"name": @"cdai",
//                                                      @"value": @-1
//                                                  }
//                                                  ]
//                                       },
//                               @"inputs": @[
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @65,
//                                              @"label": @"none",
//                                              @"meta_label": @"happy_face",
//                                              @"value": @0
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @66,
//                                              @"label": @"mild",
//                                              @"meta_label": @"neutral_face",
//                                              @"value": @1
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @67,
//                                              @"label": @"moderate",
//                                              @"meta_label": @"frowny_face",
//                                              @"value": @2
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @68,
//                                              @"label": @"severe",
//                                              @"meta_label": @"sad_face",
//                                              @"value": @3
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @69,
//                                              @"label": @"well",
//                                              @"meta_label": @"happy_face",
//                                              @"value": @0
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @70,
//                                              @"label": @"below_par",
//                                              @"meta_label": @"neutral_face",
//                                              @"value": @1
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @71,
//                                              @"label": @"poor",
//                                              @"meta_label": @"frowny_face",
//                                              @"value": @2
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @72,
//                                              @"label": @"very_poor",
//                                              @"meta_label": @"sad_face",
//                                              @"value": @3
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @73,
//                                              @"label": @"terrible",
//                                              @"meta_label": @"terrible_face",
//                                              @"value": @4
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @74,
//                                              @"label": @"none",
//                                              @"meta_label": [NSNull null],
//                                              @"value": @0
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @75,
//                                              @"label": @"questionable",
//                                              @"meta_label": [NSNull null],
//                                              @"value": @2
//                                          },
//                                          @{
//                                              @"helper": [NSNull null],
//                                              @"id": @76,
//                                              @"label": @"present",
//                                              @"meta_label": [NSNull null],
//                                              @"value": @5
//                                          },
//                                          @{
//                                              @"helper": @"stools_daily",
//                                              @"id": @77,
//                                              @"label": [NSNull null],
//                                              @"meta_label": [NSNull null],
//                                              @"value": @3
//                                          },
//                                          @{
//                                              @"helper": @"hematocrit_without_decimal",
//                                              @"id": @78,
//                                              @"label": [NSNull null],
//                                              @"meta_label": [NSNull null],
//                                              @"value": @0
//                                          },
//                                          @{
//                                              @"helper": @"current_weight",
//                                              @"id": @79,
//                                              @"label": [NSNull null],
//                                              @"meta_label": [NSNull null],
//                                              @"value": @180
//                                          },
//                                          @{
//                                              @"helper": @"typical_weight",
//                                              @"id": @80,
//                                              @"label": [NSNull null],
//                                              @"meta_label": [NSNull null],
//                                              @"value": @195
//                                          }
//                                      ]
//                               };
//    return response;
//}

//- (void)processResponse
//{
//    self.pages = [[NSMutableArray alloc] init];
//    NSDictionary *response = [self getResponse];
//    
//    NSArray *questions = [[response objectForKey:@"entry"] objectForKey:@"questions"];
//    NSArray *inputHelpers = [response objectForKey:@"inputs"];
//    
//    for(NSDictionary *question in questions) {
//        
//        NSMutableDictionary *page = [[NSMutableDictionary alloc] init];
//        
//        if([question objectForKey:@"group"] != [NSNull null]) {
//            
//            NSString *group = [question objectForKey:@"group"];
//            BOOL isPageFound = false;
//            for (NSMutableDictionary *existingPage in self.pages) {
//                if(!isPageFound && [existingPage objectForKey:@"section"] == [question objectForKey:@"section"]
//                   && [[existingPage objectForKey:@"group"] isEqualToString:[question objectForKey:@"group"]]) {
//                    
//                    [[existingPage objectForKey:@"inputs"] addObject:@{
//                                                                       @"localized_name":[question objectForKey:@"localized_name"],
//                                                                       @"name":[question objectForKey:@"name"]
//                                                                       }];
//                    isPageFound = true;
//                }
//            }
//            
//            if(!isPageFound) {
//                
//                [page setObject:group forKey:@"group"];
//                [page setObject:[question objectForKey:@"section"] forKey:@"section"];
//                [page setObject:[question objectForKey:@"kind"] forKey:@"kind"];
//                [page setObject:@[[question objectForKey:@"localized_name"]] forKey:@"options"];
//                [page setObject:[@[@{
//                                      @"localized_name":[question objectForKey:@"localized_name"],
//                                      @"name":[question objectForKey:@"name"]
//                                  }] mutableCopy] forKey:@"inputs"];
//    //            [page setObject:@"dynamic" forKey:@"subtype"];
//                [page setObject:@"static" forKey:@"subtype"];
//
//                [self.pages addObject:page];
//            }
//            
//        } else {
//            
//            [page setObject:[question objectForKey:@"section"] forKey:@"section"];
//            [page setObject:[question objectForKey:@"kind"] forKey:@"kind"];
//            [page setObject:[question objectForKey:@"localized_name"] forKey:@"title"];
//            
//            NSMutableArray *inputs = [[NSMutableArray alloc] init];
//            for (NSNumber *input in [question objectForKey:@"input_ids"]) {
//                
//                BOOL inputIsFound = false;
//                for(NSDictionary *inputHelper in inputHelpers) {
//                    if([[inputHelper objectForKey:@"id"] intValue] == [input intValue]) {
//                        [inputs addObject:@{
//                                            @"label": [inputHelper objectForKey:@"label"],
//                                            @"meta_label": [inputHelper objectForKey:@"meta_label"],
//                                            @"value": [inputHelper objectForKey:@"value"]
//                                            }];
//                        inputIsFound = true;
//                    }
//                }
//                
//                if(!inputIsFound) {
//                    NSLog(@"Input helper for input id %i not found", [input intValue]);
//                }
//            }
//            [page setObject:inputs forKey:@"inputs"];
//            
//            [self.pages addObject:page];
//        }
//    }
//    return;
//}

@end

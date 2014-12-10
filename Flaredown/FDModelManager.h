//
//  FDModelManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 11/3/14.
//  Copyright (c) 2014 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDUser.h"
#import "FDEntry.h"
#import "FDInput.h"
#import "FDQuestion.h"
#import "FDResponse.h"

@interface FDModelManager : NSObject

@property FDUser *userObject;
@property FDEntry *entry;
@property NSArray *inputs;

+ (id)sharedManager;

- (FDInput *)inputForId:(int)inputId;
- (NSArray *)questionsForSection:(int)section;
- (int)numberOfQuestionSections;

- (void)saveSession;
- (void)restoreSession;
- (void)clearCurrentEntry;
- (void)clearSession;

@end

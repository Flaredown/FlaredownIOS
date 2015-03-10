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
#import "FDSymptom.h"
#import "FDTreatment.h"

@interface FDModelManager : NSObject

@property FDUser *userObject;
@property FDEntry *entry;
@property NSArray *inputs;

+ (id)sharedManager;

//- (FDInput *)inputForId:(int)inputId;
- (NSMutableArray *)questionsForSection:(int)section;
- (int)numberOfQuestionSections;
- (NSMutableArray *)symptoms;

- (BOOL)reminder;
- (void)setReminder:(BOOL)reminder;
- (NSDate *)reminderTime;
- (void)setReminderTime:(NSDate *)reminderTime;

- (void)saveSession;
- (void)restoreSession;
- (void)clearCurrentEntry;
- (void)clearSession;

@end

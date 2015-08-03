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
#import "FDCondition.h"

@interface FDModelManager : NSObject

@property FDUser *userObject;
@property FDEntry *entry;
@property (nonatomic) NSDate *selectedDate;
@property NSMutableDictionary *entries;
@property NSMutableArray *inputs;
@property NSMutableDictionary *treatmentReminderTimes;
@property NSMutableDictionary *treatmentReminderDays;


+ (id)sharedManager;

- (void)setEntry:(FDEntry *)entry forDate:(NSDate *)date;
- (void)addInput:(FDInput *)input;
- (NSMutableArray *)questionsForSection:(int)section;
- (int)numberOfQuestionSections;
- (NSMutableArray *)symptoms;
- (NSMutableArray *)conditions;

- (BOOL)reminder;
- (void)setReminder:(BOOL)reminder;
- (NSDate *)reminderTime;
- (void)setReminderTime:(NSDate *)reminderTime;

- (NSArray *)reminderTimesForTreatment:(FDTreatment *)treatment;
- (void)addReminderTime:(NSDate *)date forTreatment:(FDTreatment *)treatment;
- (void)removeReminderTimeAtIndex:(NSInteger)index forTreatment:(FDTreatment *)treatment;
- (NSMutableArray *)reminderDaysForTreatment:(FDTreatment *)treatment;
- (void)setReminderDay:(NSInteger)dayOfTheWeek forTreatment:(FDTreatment *)treatment on:(BOOL)on;

- (void)logout;

- (void)saveSession;
- (void)restoreSession;
- (void)clearCurrentEntry;
- (void)clearSession;

@end

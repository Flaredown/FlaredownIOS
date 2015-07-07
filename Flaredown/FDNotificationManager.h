//
//  FDNotificationManager.h
//  Flaredown
//
//  Created by Cole Cunningham on 7/6/15.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FDTreatment;

@interface FDNotificationManager : NSObject

+ (id)sharedManager;

- (void)setCheckinReminder:(NSDate *)date;
- (void)removeCheckinReminder;
- (void)setRemindersForTreatment:(FDTreatment *)treatment;
- (void)removeRemindersForTreatment:(FDTreatment *)treatment;

@end

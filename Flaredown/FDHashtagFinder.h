//
//  FDHashtagFinder.h
//  Flaredown
//
//  Created by joshua may on 14/03/2015.
//  Copyright (c) 2015 Flaredown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDHashtagFinder : NSObject

- (NSArray *)rangesInString:(NSString *)string;
- (NSArray *)rangesInString:(NSString *)string range:(NSRange)range;

@end

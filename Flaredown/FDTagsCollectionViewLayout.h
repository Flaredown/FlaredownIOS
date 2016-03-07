//
//  FDTagsCollectionViewLayout.h
//  Flaredown
//
//  Created by Cole Cunningham on 3/2/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import <KTCenterFlowLayout/KTCenterFlowLayout.h>

#import "FDTrackableResult.h"

@interface FDTagsCollectionViewLayout : KTCenterFlowLayout

- (CGSize)sizeForTag:(NSString *)tag;
- (CGSize)sizeForPopularTag:(FDTrackableResult *)popularTag;

@end

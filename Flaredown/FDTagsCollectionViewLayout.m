//
//  FDTagsCollectionViewLayout.m
//  Flaredown
//
//  Created by Cole Cunningham on 3/2/16.
//  Copyright © 2016 Flaredown. All rights reserved.
//

#import "FDTagsCollectionViewLayout.h"

#import "FDTagsCollectionViewController.h";

#import "FDStyle.h"

#define CELL_SPACING 2
#define TRUE_WIDTH (self.collectionView.frame.size.width-self.collectionView.contentInset.left-self.collectionView.contentInset.right)
#define CONTENT_INSET (self.collectionView.contentInset.left + self.collectionView.contentInset.right)

@implementation FDTagsCollectionViewLayout

- (CGSize)sizeForTag:(NSString *)tag
{
    
    CGSize tagSize = CGSizeMake(TRUE_WIDTH-ROUNDED_CORNER_OFFSET, 38);
    UIFont *font = [UIFont fontWithName:@"ProximaNova-Regular" size:16];
    CGRect rect = [tag boundingRectWithSize:tagSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(rect.size.width+DOSE_BUTTON_PADDING, tagSize.height);
}

- (CGSize)sizeForPopularTag:(FDTrackableResult *)popularTag
{
    NSString *tagName = [popularTag name];
    CGRect buttonRect = [tagName boundingRectWithSize:CGSizeMake(TRUE_WIDTH, TAG_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TAG_FONT} context:nil];
    return buttonRect.size;
}

- (CGSize)collectionViewContentSize
{
    float width = TRUE_WIDTH;
    if(TRUE_WIDTH < 320)
        width=width;
    float height = 0;
    FDTagsCollectionViewController *collectionViewController = (FDTagsCollectionViewController *)self.collectionView.delegate;

    //section 0
    height += 50;
    
    //section 1
    int tagRows = 1;
    float rowWidth = 0;
    for(NSString *tag in collectionViewController.tags) {
        float tagWidth = [self sizeForTag:tag].width;
        if(rowWidth + tagWidth + CELL_SPACING > width) {
            tagRows++;
            rowWidth = 0;
        }
        rowWidth += tagWidth + rowWidth == 0 ? 0 : CELL_SPACING;
    }
    height += tagRows * TAG_HEIGHT;
    
    //section 2
    height += 50;
    
    //section 3
    int popularTagRows = 1;
    rowWidth = 0;
    for(int i = 0; i < collectionViewController.popularTags.count*2; i++) {
        float itemWidth;
        if(i % 2 == 0) {
            FDTrackableResult *popularTag = collectionViewController.popularTags[i/2];
            itemWidth = [self sizeForPopularTag:popularTag].width;
        } else {
            itemWidth = 10;
        }
        if(rowWidth + itemWidth + CELL_SPACING > width) {
            popularTagRows++;
            rowWidth = 0;
        }
        rowWidth += itemWidth + (rowWidth == 0 ? 0 : CELL_SPACING);
    }
    height += popularTagRows * TAG_HEIGHT;
    
    CGSize size = CGSizeMake(width, height);
    self.collectionView.contentSize = size;
    
    collectionViewController.view.frame = CGRectMake(0, collectionViewController.view.frame.origin.y, collectionViewController.view.frame.size.width, size.height);
    self.collectionView.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, size.height);

    return size;
}

@end

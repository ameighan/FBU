//
//  FBUCollectionViewLayout.h
//  FBUFood
//
//  Created by Amber Meighan on 8/5/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegateJSPintLayout <UICollectionViewDelegate>
@optional

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;
- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;

@end

@interface FBUCollectionViewLayout : UICollectionViewLayout

- (id)init;

@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat interitemSpacing;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat columnWidth;
@property (nonatomic) NSUInteger numberOfColumns;


@end

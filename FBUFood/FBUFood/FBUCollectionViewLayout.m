//
//  FBUCollectionViewLayout.m
//  FBUFood
//
//  Created by Amber Meighan on 8/5/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUCollectionViewLayout.h"

@interface FBUCollectionViewLayout()

@property(nonatomic,strong) NSMutableArray* layoutAttributes;  // array of UICollectionViewLayoutAttributes
@property(nonatomic,strong) NSMutableArray* pendingLayoutAttributes;
@property(nonatomic) CGSize contentSize;
@property(nonatomic,strong) UICollectionViewUpdateItem* updateItem;

@end


@implementation FBUCollectionViewLayout

#pragma mark - Getters and Setters

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    // sanity checks
    if((lineSpacing >= 0.0) && (lineSpacing < 400))
        _lineSpacing = lineSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing
{
    // sanity checks
    if((interitemSpacing >= 0.0) && (interitemSpacing < 400))
        _interitemSpacing = interitemSpacing;
}

-(void)setItemHeight:(CGFloat)itemHeight
{
    // sanity checks
    if((itemHeight > 0.0) && (itemHeight < 10000))
        _itemHeight = itemHeight;
}

-(void)setColumnWidth:(CGFloat)columnWidth
{
    // sanity checks
    if((columnWidth > 0.0) && (columnWidth < 10000))
        _columnWidth = columnWidth;
}

-(void)setNumberOfColumns:(NSUInteger)numberOfColumns
{
    // sanity checks
    if((numberOfColumns > 0) && (numberOfColumns < 20))
        _numberOfColumns = numberOfColumns;
}


#pragma mark - Initialization

// this assumes the this object is being created programmatically.  you may need to instead do this in awakeFromNib.
- (id)init
{
    self = [super init];
    if(self)
        [self internalInitialize];
    
    return self;
}

- (void)awakeFromNib
{
    [self internalInitialize];
}

- (void)internalInitialize
{
    // set default values for all properties
    self.lineSpacing = 10.0;
    self.interitemSpacing = 10.0;
    self.itemHeight = 50.0;
    self.columnWidth = 40.0;
    self.numberOfColumns = 2;
}



#pragma mark - UICollectionViewLayout

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    if(!self.layoutAttributes)
    {
        [self doNewLayout];
        self.layoutAttributes = self.pendingLayoutAttributes;
    }
    
    // create a predicate to find cells that intersect with the passed rectangle, then use it to filter the array of layout attributes
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary* bindings) {
        
        UICollectionViewLayoutAttributes* layoutAttributes = evaluatedObject;
        CGRect cellFrame = layoutAttributes.frame;
        
        return CGRectIntersectsRect(cellFrame,rect);
    }];
    NSArray* filteredLayoutAttributes = [self.layoutAttributes filteredArrayUsingPredicate:predicate];
    
    // return the filtered array
    return filteredLayoutAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if(!self.layoutAttributes)
    {
        [self doNewLayout];
        self.layoutAttributes = self.pendingLayoutAttributes;
    }
    
    NSUInteger index = [indexPath indexAtPosition:1];
    UICollectionViewLayoutAttributes* layoutAttributes = self.pendingLayoutAttributes[index];
    
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath*)itemIndexPath
{
    NSUInteger index = [itemIndexPath indexAtPosition:1];
    
    UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    
    if(self.updateItem.updateAction == UICollectionUpdateActionInsert)
    {
        UICollectionViewLayoutAttributes* layoutAttributesOrigin = self.pendingLayoutAttributes[index];
        layoutAttributes.size = layoutAttributesOrigin.size;
        layoutAttributes.center = layoutAttributesOrigin.center;
        
        NSUInteger indexOfInsertedItemAfterUpdate = [self.updateItem.indexPathAfterUpdate indexAtPosition:1];
        
        if(index == indexOfInsertedItemAfterUpdate)
            layoutAttributes = nil;
    }
    else if(self.updateItem.updateAction == UICollectionUpdateActionDelete)
    {
        UICollectionViewLayoutAttributes* layoutAttributesOrigin = self.layoutAttributes[index + 1];
        layoutAttributes.size = layoutAttributesOrigin.size;
        layoutAttributes.center = layoutAttributesOrigin.center;
        
        NSUInteger indexOfDeletedItemBeforeUpdate = [self.updateItem.indexPathBeforeUpdate indexAtPosition:1];
        if(index < indexOfDeletedItemBeforeUpdate)
            layoutAttributes = nil;
        
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath*)itemIndexPath
{
    NSUInteger index = [itemIndexPath indexAtPosition:1];
    
    UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    UICollectionViewLayoutAttributes* layoutAttributesOrigin = self.layoutAttributes[index];
    layoutAttributes.size = layoutAttributesOrigin.size;
    layoutAttributes.center = layoutAttributesOrigin.center;
    
    if(self.updateItem.updateAction == UICollectionUpdateActionDelete)
    {
        NSUInteger indexOfDeletedItemBeforeUpdate = [self.updateItem.indexPathBeforeUpdate indexAtPosition:1];
        if(index == indexOfDeletedItemBeforeUpdate)
            layoutAttributes.alpha = 0.0;
    }
    else if(self.updateItem.updateAction == UICollectionUpdateActionInsert)
        layoutAttributes = nil;
    
    return layoutAttributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray*)updateItems
{
    // we only support one update at a time
    self.updateItem = updateItems[0];
    
    [self doNewLayout];
}

- (void)finalizeCollectionViewUpdates
{
    self.layoutAttributes = self.pendingLayoutAttributes;
}

- (void)prepareLayout
{
    id<UICollectionViewDelegateJSPintLayout> delegate = (id<UICollectionViewDelegateJSPintLayout>)self.collectionView.delegate;
    
    // get column width from delegate.  If the method isn't implemented fall back to our property
    NSUInteger columnWidth = self.columnWidth;
    if(delegate && [delegate respondsToSelector:@selector(columnWidthForCollectionView:layout:)])
    {
        columnWidth = [delegate columnWidthForCollectionView:self.collectionView
                                                      layout:self];
    }
    
    // find out how many cells there are
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    // get max number of columns from the delegate.  If the method isn't implemented, fall back to our property
    NSUInteger maximumNumberOfColumns = self.numberOfColumns;
    if(delegate && [delegate respondsToSelector:@selector(maximumNumberOfColumnsForCollectionView:layout:)])
    {
        maximumNumberOfColumns = [delegate maximumNumberOfColumnsForCollectionView:self.collectionView
                                                                            layout:self];
    }
    
    // build an array of all the cell heights.
    NSMutableArray* cellHeights = [NSMutableArray arrayWithCapacity:cellCount];
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        CGFloat itemHeight = self.itemHeight;  // set default item size, then optionally override it
        if(delegate && [delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)])
        {
            itemHeight = [delegate collectionView:self.collectionView
                                           layout:self
                         heightForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex
                                                                      inSection:0]];
        }
        
        cellHeights[cellIndex] = @(itemHeight);
    }
    
    // now build the array of layout attributes
    self.pendingLayoutAttributes = [NSMutableArray arrayWithCapacity:cellCount];
    
    // will need an array of column heights
    CGFloat* columnHeights = calloc(maximumNumberOfColumns,sizeof(CGFloat));  // calloc() initializes to zero.
    CGFloat contentHeight = 0.0;
    CGFloat contentWidth = 0.0;
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        CGFloat itemHeight = [cellHeights[cellIndex] floatValue];
        
        // find shortest column
        NSUInteger useColumn = 0;
        CGFloat shortestHeight = DBL_MAX;
        for(NSUInteger col = 0; col < maximumNumberOfColumns; ++col)
        {
            if(columnHeights[col] < shortestHeight)
            {
                useColumn = col;
                shortestHeight = columnHeights[col];
            }
        }
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:cellIndex
                                                     inSection:0];
        UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.size = CGSizeMake(columnWidth,itemHeight);
        layoutAttributes.center = CGPointMake((useColumn * (columnWidth + self.interitemSpacing)) + (columnWidth / 2.0),columnHeights[useColumn] + (itemHeight / 2.0));
        self.pendingLayoutAttributes[cellIndex] = layoutAttributes;
        columnHeights[useColumn] += itemHeight;
        if(columnHeights[useColumn] > contentHeight)
            contentHeight = columnHeights[useColumn];
        CGFloat rightEdge = (useColumn * (columnWidth + self.interitemSpacing)) + columnWidth;
        if(rightEdge > contentWidth)
            contentWidth = rightEdge;
        columnHeights[useColumn] += self.lineSpacing;
    }
    self.contentSize = CGSizeMake(contentWidth,contentHeight);
    
    free(columnHeights);

}

-(void)doNewLayout
{
    id<UICollectionViewDelegateJSPintLayout> delegate = (id<UICollectionViewDelegateJSPintLayout>)self.collectionView.delegate;
    
    // get column width from delegate.  If the method isn't implemented fall back to our property
    NSUInteger columnWidth = self.columnWidth;
    if(delegate && [delegate respondsToSelector:@selector(columnWidthForCollectionView:layout:)])
    {
        columnWidth = [delegate columnWidthForCollectionView:self.collectionView
                                                      layout:self];
    }
    
    // find out how many cells there are
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    // get max number of columns from the delegate.  If the method isn't implemented, fall back to our property
    NSUInteger maximumNumberOfColumns = self.numberOfColumns;
    if(delegate && [delegate respondsToSelector:@selector(maximumNumberOfColumnsForCollectionView:layout:)])
    {
        maximumNumberOfColumns = [delegate maximumNumberOfColumnsForCollectionView:self.collectionView
                                                                            layout:self];
    }
    
    // build an array of all the cell heights.
    NSMutableArray* cellHeights = [NSMutableArray arrayWithCapacity:cellCount];
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        CGFloat itemHeight = self.itemHeight;  // set default item size, then optionally override it
        if(delegate && [delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)])
        {
            itemHeight = [delegate collectionView:self.collectionView
                                           layout:self
                         heightForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex
                                                                      inSection:0]];
        }
        
        cellHeights[cellIndex] = @(itemHeight);
    }
    
    // now build the array of layout attributes
    self.pendingLayoutAttributes = [NSMutableArray arrayWithCapacity:cellCount];
    
    // will need an array of column heights
    CGFloat* columnHeights = calloc(maximumNumberOfColumns,sizeof(CGFloat));  // calloc() initializes to zero.
    CGFloat contentHeight = 0.0;
    CGFloat contentWidth = 0.0;
    for(NSUInteger cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        CGFloat itemHeight = [cellHeights[cellIndex] floatValue];
        
        // find shortest column
        NSUInteger useColumn = 0;
        CGFloat shortestHeight = DBL_MAX;
        for(NSUInteger col = 0; col < maximumNumberOfColumns; ++col)
        {
            if(columnHeights[col] < shortestHeight)
            {
                useColumn = col;
                shortestHeight = columnHeights[col];
            }
        }
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:cellIndex
                                                     inSection:0];
        UICollectionViewLayoutAttributes* layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.size = CGSizeMake(columnWidth,itemHeight);
        layoutAttributes.center = CGPointMake((useColumn * (columnWidth + self.interitemSpacing)) + (columnWidth / 2.0),columnHeights[useColumn] + (itemHeight / 2.0));
        self.pendingLayoutAttributes[cellIndex] = layoutAttributes;
        columnHeights[useColumn] += itemHeight;
        if(columnHeights[useColumn] > contentHeight)
            contentHeight = columnHeights[useColumn];
        CGFloat rightEdge = (useColumn * (columnWidth + self.interitemSpacing)) + columnWidth;
        if(rightEdge > contentWidth)
            contentWidth = rightEdge;
        columnHeights[useColumn] += self.lineSpacing;
    }
    self.contentSize = CGSizeMake(contentWidth,contentHeight);
    
    free(columnHeights);
}


- (void)invalidateLayout
{
}
- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
{
    NSLog(@"A");
}
- (void)finalizeAnimatedBoundsChange
{
}


@end

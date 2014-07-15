//
//  FBUBucketListItemStore.h
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBUBucketListItem;

@interface FBUBucketListItemStore : NSObject

//@property (nonatomic, readonly, copy) NSArray *allItems;

+ (instancetype)sharedStore;
- (NSArray *)allItems;

@end

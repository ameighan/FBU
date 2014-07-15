//
//  FBUBucketListItemStore.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListItemStore.h"

@interface FBUBucketListItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation FBUBucketListItemStore

+ (instancetype)sharedStore
{
    static FBUBucketListItemStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use + [FBUBucketListItemStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

@end

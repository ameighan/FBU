//
//  FBUBucketListItem.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListItem.h"

@implementation FBUBucketListItem

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name];
}

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"%@", self.itemName];
}

@end

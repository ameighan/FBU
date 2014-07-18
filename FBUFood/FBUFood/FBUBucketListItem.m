//
//  FBUBucketListItem.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListItem.h"
#import <Parse/PFObject+Subclass.h>

@implementation FBUBucketListItem

+ (NSString *)parseClassName
{
    return @"FBUBucketListItem";
}

@dynamic itemName;
@dynamic owner;

@end

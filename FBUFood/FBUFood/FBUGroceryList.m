//
//  FBUGroceryList.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryList.h"
#import <Parse/PFObject+Subclass.h>

@implementation FBUGroceryList

+ (NSString *)parseClassName
{
    return @"FBUGroceryList";
}

@dynamic recipesToFollow;
@dynamic ingredientsToBuy;


@end

//
//  FBUGroceryList.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FBURecipe.h"

@interface FBUGroceryList : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSMutableArray *recipesToFollow;
@property (strong, nonatomic) NSMutableArray *ingredientsToBuy;

- (void)fillInGroceryList;

@end

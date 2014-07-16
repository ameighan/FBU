//
//  FBURecipe.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipe.h"
#import <Parse/PFObject+Subclass.h>

@implementation FBURecipe

+ (NSString *)parseClassName
{
    return @"FBURecipe";
}

@dynamic titleOfRecipe;
@dynamic pictureOfMeal;
@dynamic ingredientsList;
@dynamic quantityOfIngredients;
@dynamic directions;


@end

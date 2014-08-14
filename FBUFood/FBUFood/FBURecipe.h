//
//  FBURecipe.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FBURecipe : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) PFFile *image;
@property (strong, nonatomic) PFUser *publisher;

//NSArrays will contain NSStrings of ingredient names and ints of quantity of each ingredient
//Index numbers of each array will match up
@property (strong, nonatomic) NSString *ingredientsList;
@property (nonatomic) BOOL isYummlyRecipe;
@property (strong, nonatomic) NSArray *quantityOfIngredients;

//Directions will be an NSArray of strings for Step 1, 2, etc.
@property (strong, nonatomic) NSString *directions;

@property (nonatomic) BOOL fromYummly;

@end

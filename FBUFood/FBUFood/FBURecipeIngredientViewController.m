//
//  FBURecipeIngredientViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeIngredientViewController.h"
#import "FBURecipeContainerViewController.h"


@interface FBURecipeIngredientViewController ()

@end

@implementation FBURecipeIngredientViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ingredientsList.text = self.recipe.ingredientsList;

}


@end

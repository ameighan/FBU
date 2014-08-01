//
//  FBURecipeDirectionsViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeDirectionsViewController.h"
#import "FBURecipeContainerViewController.h"


@interface FBURecipeDirectionsViewController ()

@end

@implementation FBURecipeDirectionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.directions.text = self.recipe.directions;

}



@end

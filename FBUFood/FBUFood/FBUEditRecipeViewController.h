//
//  FBUEditRecipeViewController.h
//  FBUFood
//
//  Created by Amber Meighan on 7/21/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBURecipe;

@interface FBUEditRecipeViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic) FBURecipe *recipe;


@end

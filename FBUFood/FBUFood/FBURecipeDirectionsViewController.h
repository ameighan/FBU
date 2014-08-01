//
//  FBURecipeDirectionsViewController.h
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBURecipe;

@interface FBURecipeDirectionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *directions;
@property (nonatomic) FBURecipe *recipe;


@end

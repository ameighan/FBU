//
//  FBURecipeContainerViewController.h
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBURecipe.h"

@interface FBURecipeContainerViewController : UIViewController

@property (strong, nonatomic) NSString *toViewSegueIdentifier;
@property (nonatomic) FBURecipe *recipe;


@end


//
//  FBURecipeViewController.h
//  FBUFood
//
//  Created by Amber Meighan on 7/18/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBURecipe;
@class FBUEvent;

@interface FBURecipeViewController : UIViewController <UITabBarDelegate>

@property (nonatomic) FBURecipe *recipe;
@property (nonatomic) FBUEvent *event;
@property (nonatomic) NSString *eventRecipe;

@end

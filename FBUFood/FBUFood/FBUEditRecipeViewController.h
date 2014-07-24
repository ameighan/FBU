//
//  FBUEditRecipeViewController.h
//  FBUFood
//
//  Created by Amber Meighan on 7/21/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBURecipe;

@interface FBUEditRecipeViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic) FBURecipe *recipe;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *recipeTextField;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;

-(void)saveRecipe;
@end

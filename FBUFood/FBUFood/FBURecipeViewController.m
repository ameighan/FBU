//
//  FBURecipeViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/18/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeViewController.h"
#import "FBURecipe.h"
#import "FBUEditRecipeViewController.h"

@interface FBURecipeViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsList;
@property (weak, nonatomic) IBOutlet UITextView *directions;


@end

@implementation FBURecipeViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navBar setTitle:self.recipe.title];
    
    UIImage *image = [UIImage imageWithData:[self.recipe.image getData]];
    self.imageView.image = image;
    
    self.ingredientsList.text = self.recipe.ingredientsList;
    
    self.directions.text = self.recipe.directions;
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailToEditView"]){
        
        FBUEditRecipeViewController *controller = (FBUEditRecipeViewController *)segue.destinationViewController;
        
        [controller.navBar setTitle:@"Edit Recipe"];
        
//        UIImage *ig = [UIImage imageWithData:[self.recipe.image getData]];
        controller.recipe.image= self.recipe.image;
        NSLog(@"It has been assigned: %@", controller.recipe.image);
        
        controller.recipe.ingredientsList = self.recipe.ingredientsList;
        
        controller.recipe.directions = self.recipe.directions;
        
        controller.recipe.title = self.recipe.title;
        
        controller.recipe = self.recipe;

    }
}

@end

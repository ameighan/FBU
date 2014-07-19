//
//  FBURecipeViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/18/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeViewController.h"
#import <Parse/Parse.h>
#import "FBURecipe.h"
#import "FBUNewRecipeController.h"

@class FBURecipe;

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
    
    
    [self.navBar setTitle:self.recipe[@"title"]];
    
    UIImage *image = [UIImage imageWithData:[self.recipe[@"image"] getData]];
    self.imageView.image = image;
    
    self.ingredientsList.text = self.recipe[@"ingredients"];
    
    self.directions.text = self.recipe[@"directions"];
    
    
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"detailToEditView"]){
//        
//        FBUNewRecipeController *controller = (FBUNewRecipeController *)segue.destinationViewController;
//    
//        
//        
//    }
//}

@end

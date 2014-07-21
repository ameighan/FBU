//
//  FBUEditRecipeViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/21/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEditRecipeViewController.h"
#import <Parse/Parse.h>
#import "FBURecipesListViewController.h"
#import "FBURecipeViewController.h"
#import "FBURecipe.h"

@interface FBUEditRecipeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *recipeTextField;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;

@end


@implementation FBUEditRecipeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.recipe){
        UIImage *image = [UIImage imageWithData:[self.recipe.image getData]];
        self.imageView.image = image;
        self.recipeTextField.text = self.recipe.title;
        self.ingredientsTextView.text = self.recipe.ingredientsList;
        self.directionsTextView.text = self.recipe.directions;
    }
    
}


- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    NSLog(@"Picked a photo: %@", image);
    self.imageView.image = image;
//        NSLog(@"Assigning the image: %@", self.imageView.image);
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)backgroundPressed:(id)sender
{
    [self.view endEditing:YES];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newRecipeToRecipeTableView"]) {
        if(self.recipe) {
            self.recipe.title= self.recipeTextField.text;
            self.recipe.ingredientsList = self.ingredientsTextView.text;
            self.recipe.directions = self.directionsTextView.text;
            if(self.imageView.image){
                NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
                NSString *filename = [NSString stringWithFormat:@"%@.png", self.recipeTextField.text];
                PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
                self.recipe.image = imageFile;
            }
            
            [self.recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Resaving recipe data");
                }
            }];
            
        } else {
        // Create Recipe
        FBURecipe *newRecipe = [FBURecipe object];
        
        // Set content
        newRecipe.title = self.recipeTextField.text;
        newRecipe.ingredientsList = self.ingredientsTextView.text;
        newRecipe.directions = self.directionsTextView.text;
        if(self.imageView.image){
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
            NSString *filename = [NSString stringWithFormat:@"%@.png", self.recipeTextField.text];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            newRecipe.image = imageFile;
        }
        
        // Create relationship
        newRecipe.publisher = [PFUser currentUser];
        
        // Save the new post
        [newRecipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Dismiss the NewPostViewController and show the BlogTableViewController
                NSLog(@"Saving recipe to Parse");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"savedToParse" object:self];
                
                //In the future, look here to solve the Bad file name issue that occurs when characters are entered in the recipe name and prevents the recipe from saving.
                }
            }];
        }
    
    }
    
}




@end

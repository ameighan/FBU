//
//  FBUNewRecipeController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/16/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUNewRecipeController.h"
#import <Parse/Parse.h>
#import "FBURecipesListViewController.h"

@interface FBUNewRecipeController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *recipeTextField;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end

@implementation FBUNewRecipeController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)backgroundPressed:(id)sender
{
    [self.view endEditing:YES];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newRecipeToRecipeTableView"]) {
        // Create Recipe
//        PFObject *newRecipe = [PFObject objectWithClassName:@"Recipe"];
        FBURecipe *newRecipe = [FBURecipe object];
        
        // Set content
        [newRecipe setObject:self.recipeTextField.text forKey:@"title"];
        [newRecipe setObject:self.ingredientsTextView.text forKey:@"ingredients"];
        [newRecipe setObject:self.directionsTextView.text forKey:@"directions"];
        if(self.imageView.image){
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
            NSString *filename = [NSString stringWithFormat:@"%@.png", self.recipeTextField.text];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            newRecipe[@"image"] = imageFile;
        }
        
        // Create relationship
        [newRecipe setObject:[PFUser currentUser] forKey:@"publisher"];
        
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



@end

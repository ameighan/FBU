//
//  FBUEditProfileViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/13/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEditProfileViewController.h"
#import <Parse/Parse.h>
#import "FBUProfileViewController.h"

@interface FBUEditProfileViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextView *allergiesTextView;

@end

@implementation FBUEditProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    
    self.fullNameTextField.text = user[@"name"];
    self.emailTextField.text = user[@"email"];
    self.phoneNumberTextField.text = user[@"additional"];
//    self.allergiesTextView.text = user[@"allergies"];
    if(!user[@"fbImage"]) {
        UIImage *image = [UIImage imageWithData:[user[@"profileImage"] getData]];
        self.imageView.image = image;
    } else {
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"fbImage"]]]];
        self.imageView.image = img;
    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        PFUser *user = [PFUser currentUser];
        user[@"name"] = self.fullNameTextField.text;
        user[@"additional"] = self.phoneNumberTextField.text;
        user[@"email"] = self.emailTextField.text;
        if(!user[@"fbImage"]) {
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
            NSString *filename = [NSString stringWithFormat:@"%@.png", self.fullNameTextField.text];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            user[@"profileImage"] = imageFile;
        }
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Saving Profile Data");
        }];
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
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

@end

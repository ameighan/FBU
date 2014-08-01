//
//  FBUBucketListDetailViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListDetailViewController.h"
#import "FBUBucketListItem.h"

@interface FBUBucketListDetailViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@end

@implementation FBUBucketListDetailViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    
    return YES;
}

- (IBAction)backgroundPressed:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)userDidSave:(id)sender
{
    
    [self showAlertWithTitle: [NSString stringWithFormat:@"%@", self.addTextfield.text]
                     message: [NSString stringWithFormat:@"%@ was saved!", self.addTextfield.text]];
    FBUBucketListItem *newBucketItem = [FBUBucketListItem object];
    newBucketItem.itemName = self.addTextfield.text;
    newBucketItem.owner = [PFUser currentUser];
    [newBucketItem saveInBackground];
    
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end

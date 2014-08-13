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
    self.addTextfield.delegate = self;
    if(self.item){
        UIImage *image = [UIImage imageWithData:[self.item.picture getData]];
        self.imageView.image = image;
        self.addTextfield.text = self.item.itemName;
    }
    UIImage *backImage = [UIImage imageNamed:@"BucketListBackground.jpg"];
    [self.backgroundImageView setImage:backImage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
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
    [self showAlertWithTitle:@"Success!" message:@"You saved an item!"];
    if (self.item){
        self.item.itemName = self.addTextfield.text;
        if(self.imageView.image){
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
            NSString *filename = [NSString stringWithFormat:@"%@.png", self.addTextfield.text];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            self.item.picture = imageFile;
        }
        [self.item saveInBackground];
    } else {
        FBUBucketListItem *newBucketItem = [FBUBucketListItem object];
        newBucketItem.itemName = self.addTextfield.text;
        newBucketItem.owner = [PFUser currentUser];
        if(self.imageView.image){
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
            NSString *filename = [NSString stringWithFormat:@"%@.png", self.addTextfield.text];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            newBucketItem.picture = imageFile;
        }
        newBucketItem.isCrossedOff = false;
        newBucketItem.owner = [PFUser currentUser];
        [newBucketItem saveInBackground];
    }
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

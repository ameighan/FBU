//
//  FBUGroupsDetailViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/16/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroupsDetailViewController.h"
#import "FBUGroup.h"

@interface FBUGroupsDetailViewController () <UITextViewDelegate>

@property (nonatomic) UIImage *groupImage;

@end

@implementation FBUGroupsDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nameOfGroupTextField becomeFirstResponder];
    self.descriptionOfGroupTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.descriptionOfGroupTextView.layer.borderWidth = 0.5;
    self.descriptionOfGroupTextView.layer.cornerRadius = 8;
    
    self.descriptionOfGroupTextView.text = @"#italian #pasta #pizza";
    self.descriptionOfGroupTextView.textColor = [UIColor lightGrayColor];
    
    [self createButtonUI:self.uploadPhotoButton];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"#italian #pasta #pizza"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"#italian #pasta #pizza";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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
        return NO;
    }
    
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (void)createButtonUI:(UIButton *)button
{
    [button setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [[button layer] setBorderWidth:1.5f];
    [[button layer] setBorderColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00].CGColor];
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    
}


-(void)saveGroup
{
    //Saves the data to Parse as a FBUGroup (subclass of PFObject)
    
    FBUGroup *newGroup = [FBUGroup object];
    newGroup.groupName = self.nameOfGroupTextField.text;
    newGroup.groupDescription = self.descriptionOfGroupTextView.text;
    
    if (self.groupImage == nil) {
        UIImage *image = [UIImage imageNamed:@"dining.png"];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSString *filename = [NSString stringWithFormat:@"%@.png", @"group image"];
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        newGroup.groupImage = imageFile;
        newGroup.groupImageHeight = 200;
    } else {
        NSData *imageData = UIImageJPEGRepresentation(self.groupImage, 0.8);
        NSString *filename = [NSString stringWithFormat:@"%@.png", @"group image"];
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        newGroup.groupImage = imageFile;
        newGroup.groupImageHeight = self.groupImage.size.height/(self.groupImage.size.height*0.005);
    }
    newGroup.owner = [PFUser currentUser];
    [newGroup addObject:[PFUser currentUser] forKey:@"cooksInGroup"];
    [newGroup addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    
    [newGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving group");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"savedGroup" object:self];
    }];

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
    self.groupImage = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}






@end

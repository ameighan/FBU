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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FBUGroupsDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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


-(void)saveGroup
{
    //Saves the data to Parse as a FBUGroup (subclass of PFObject)
    
    FBUGroup *newGroup = [FBUGroup object];
    newGroup.groupName = self.nameOfGroupTextField.text;
    newGroup.groupDescription = self.descriptionOfGroupTextView.text;
    
    if (!self.imageView.image) {
        UIImage *image = [UIImage imageNamed:@"dining.png"];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *filename = [NSString stringWithFormat:@"%@.png", @"group image"];
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        newGroup.groupImage = imageFile;
        newGroup.groupImageHeight = image.size.height/10;
    } else {
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
        NSString *filename = [NSString stringWithFormat:@"%@.png", @"group image"];
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        newGroup.groupImage = imageFile;
        newGroup.groupImageHeight = self.imageView.image.size.height/(self.imageView.image.size.height*0.005);
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
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}






@end

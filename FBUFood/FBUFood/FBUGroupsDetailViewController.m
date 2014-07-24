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

@end

@implementation FBUGroupsDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)userDidSave:(id)sender
{
    //Make an alert that says that the data is saved for UI purposes
    
    [self showAlertWithTitle: [NSString stringWithFormat:@"%@", self.nameOfGroupTextField.text]
                     message: [NSString stringWithFormat:@"%@ was saved!", self.nameOfGroupTextField.text]];
    
    
    //Saves the data to Parse as a FBUGroup (subclass of PFObject)
    
    FBUGroup *newGroup = [FBUGroup object];
    newGroup.groupName = self.nameOfGroupTextField.text;
    newGroup.groupDescription = self.descriptionOfGroupTextView.text;
    newGroup.owner = [PFUser currentUser];
    [newGroup addObject:[PFUser currentUser] forKey:@"cooksInGroup"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *meetingTime = [dateFormatter stringFromDate:self.generalMeetingTimesDatePicker.date];
    
    newGroup.generalMeetingTimes = [NSString stringWithFormat:@"%@ at %@", self.dayOfWeekTextField.text, meetingTime];
    
    [newGroup saveInBackground];
    
    
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

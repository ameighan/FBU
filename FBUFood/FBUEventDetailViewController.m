//
//  FBUEventDetailViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventDetailViewController.h"
#import "FBUEvent.h"

@implementation FBUEventDetailViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)userDidSaveEvent:(id)sender
{
    //Make an alert that says that the data is saved for UI purposes
    
    [self showAlertWithTitle: [NSString stringWithFormat:@"%@", self.eventNameTextField.text]
                     message: [NSString stringWithFormat:@"%@ was saved!", self.eventNameTextField.text]];
    
    
    //Saves the data to Parse as a FBUGroup (subclass of PFObject)
    
    FBUEvent *newEvent = [FBUEvent object];
    newEvent.eventName = self.eventNameTextField.text;
    newEvent.eventDescription = self.eventDescriptionTextView.text;
    newEvent.eventAddress = self.eventAddressTextField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy 'at' h:mm a"];
    newEvent.eventTimeDate = [dateFormatter stringFromDate:self.eventDatePicker.date];
    
    [newEvent saveInBackground];
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

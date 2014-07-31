//
//  FBUEventViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventViewController.h"
#import "FBUEvent.h"
#import "FBUEventDetailViewController.h"

@interface FBUEventViewController ()
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation FBUEventViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.event.eventName;
    self.eventLocationLabel.text = self.event.eventAddress;
    self.eventTimeDateLabel.text = self.event.eventTimeDate;
    if (self.event.creator != [PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = nil;
    }

    NSLog(@"%@", self.event.membersOfEvent);
    if (self.event.membersOfEvent == NULL) {
        self.eventJoinButton.hidden = NO;
        self.eventJoinButton.enabled = YES;
    } else if ([self.event checkIfUserIsInEventArray:self.event.membersOfEvent]) {
        NSLog(@"%@", self.event.membersOfEvent);
        self.eventJoinButton.hidden = YES;
        self.eventJoinButton.enabled = NO;
    }
    
}


- (IBAction)userDidJoinEvent:(id)sender
{
    [self showAlertWithTitle:self.title
                     message:[NSString stringWithFormat:@"You are going to %@ !", self.title]];
    
    [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
    [self.event saveInBackground];
    
    //Disable join button once user has joined.
    self.eventJoinButton.hidden = YES;
    self.eventJoinButton.enabled = NO;

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

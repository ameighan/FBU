//
//  FBUGroupsViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroupsViewController.h"
#import "FBUGroupsListViewController.h"
#import "FBUGroupSubscribersViewController.h"
//#import "FBUEventDetailViewController.h"


@implementation FBUGroupsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.group.cooksInGroup containsObject:[PFUser currentUser]]) {
        [self toggleCookView];
    }
    
    self.title = self.group.groupName;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    self.generalMeetingTimesLabel.text = self.group.generalMeetingTimes;
}


- (void)toggleCookView
{
    self.createEventInGroupButton.hidden = NO;
    self.addRecipeInGroupButton.hidden = NO;
    self.viewSubscribersInGroupButton.hidden = NO;
    
    
    //Disable and hide the old buttons
    self.joinGroupButton.hidden = YES;
    self.joinGroupButton.enabled = NO;
    self.subscribeGroupButton.hidden = YES;
    self.subscribeGroupButton.enabled = NO;
}


- (IBAction)addUserToGroupAsCook:(id)sender
{
    
    [self showAlertWithTitle:@"Success!" message:@"You have joined this group!"];
    
    [self.group addObject:[PFUser currentUser] forKey:@"cooksInGroup"];
    [self.group saveInBackground];
    
    [self toggleCookView];
    
}


- (IBAction)addUserToGroupAsSubscriber:(id)sender
{
    
    [self showAlertWithTitle:@"Success!" message:@"You have subscribed to this group!"];
    
    [self.group addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    [self.group saveInBackground];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewSubscribers"]) {
        
        FBUGroupSubscribersViewController *groupSubscribersViewController = segue.destinationViewController;
        
        groupSubscribersViewController.group = self.group;
        NSLog(@"Accessing subscribers of %@", groupSubscribersViewController.group.groupName);
        
    }
//    else if ([segue.identifier isEqualToString:@"createEvent"]) {
//        
//        FBUEventDetailViewController *eventDetailViewController = segue.destinationViewController;
//        
//        eventDetailViewController.group = self.group;
//        
//    }
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

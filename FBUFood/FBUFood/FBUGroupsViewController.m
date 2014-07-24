//
//  FBUGroupsViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroupsViewController.h"
#import "FBUGroupsListViewController.h"
#import "FBUGroup.h"


@implementation FBUGroupsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.groupNameLabel.text = self.group.groupName;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    self.generalMeetingTimesLabel.text = self.group.generalMeetingTimes;
    
    if ([self.group.cooksInGroup containsObject:[PFUser currentUser]]) {
        //Show buttons now that the user is part of the group
        self.createEventInGroupButton.hidden = NO;
        self.addRecipeInGroupButton.hidden = NO;
        self.viewSubscribersInGroupButton.hidden = NO;
        
        
        //Disable and hide the old buttons
        self.joinGroupButton.hidden = YES;
        self.joinGroupButton.enabled = NO;
        self.subscribeGroupButton.hidden = YES;
        self.subscribeGroupButton.enabled = NO;
    }
}


- (IBAction)addUserToGroupAsMember:(id)sender
{
    [self.group addObject:[PFUser currentUser] forKey:@"cooksInGroup"];
    [self.group saveInBackground];
    
}


- (IBAction)addUserToGroupAsSubscriber:(id)sender
{
    [self.group addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    [self.group saveInBackground];
}


@end

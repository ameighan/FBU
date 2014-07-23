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

@interface FBUGroupsViewController ()

@property (strong, nonatomic) NSArray *membersOfGroup;
@property (strong, nonatomic) NSArray *subscribersOfGroup;

@end


@implementation FBUGroupsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.groupNameLabel.text = self.group.groupName;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    self.generalMeetingTimesLabel.text = self.group.generalMeetingTimes;
    
    if ([self.membersOfGroup containsObject:[PFUser currentUser]]) {
        self.createEventInGroupButton.hidden = NO;
        self.addRecipeInGroupButton.hidden = NO;
        self.viewSubscribersInGroupButton.hidden = NO;
        
        self.joinGroupButton.hidden = YES;
        self.joinGroupButton.enabled = NO;
        self.subscribeGroupButton.hidden = YES;
        self.subscribeGroupButton.enabled = NO;
    }
}


- (IBAction)addUserToGroupAsMember:(id)sender
{
    [self.group addMemberToGroup:[PFUser currentUser]];
    
}


- (IBAction)addUserToGroupAsSubscriber:(id)sender
{
    [self.group addSubscriberToGroup:[PFUser currentUser]];
}



@end

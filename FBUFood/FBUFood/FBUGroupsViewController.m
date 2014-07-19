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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.groupNameLabel.text = self.group.groupName;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    self.generalMeetingTimesLabel.text = self.group.generalMeetingTimes;
}

- (IBAction)addUserToGroupAsCook:(id)sender
{
    
}


- (IBAction)addUserToGroupAsSubscriber:(id)sender
{
    
}



@end

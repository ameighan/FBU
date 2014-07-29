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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.event.eventName;
    if (self.event.creator != [PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}


- (IBAction)userDidJoinEvent:(id)sender
{
    [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
    [self.event saveInBackground];
}


@end

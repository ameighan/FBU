//
//  FBUProfileViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUProfileViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBUDashboardViewController.h"

@implementation FBUProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([PFUser currentUser]){
        PFUser *user = [PFUser currentUser];
        NSURL *url = [NSURL URLWithString:user[@"profileImage"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.profileImage.image = img;
        self.nameLabel.text = user[@"name"];
        self.emailLabel.text = user[@"email"];
    }
}


@end

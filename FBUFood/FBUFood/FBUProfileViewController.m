//
//  FBUProfileViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUProfileViewController.h"
#import <Parse/Parse.h>


@implementation FBUProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]){
        PFUser *user = [PFUser currentUser];
        if(user[@"fbImage"]) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"fbImage"]]]];
            self.profileImage.image = img;

        } else {
            UIImage *image = [UIImage imageWithData:[user[@"profileImage"] getData]];
            self.profileImage.image = image;
        }
        self.nameLabel.text = user[@"name"];
        self.emailLabel.text = user[@"email"];
        self.phoneLabel.text = user[@"additional"];
    }
}


@end

//
//  FBULoginViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/23/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBULoginViewController.h"
#import <Parse/Parse.h>

@interface FBULogInViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@property (nonatomic, strong) UIImageView *orLabel;
@property (nonatomic, strong) UIImageView *signupLabel;
@end

@implementation FBULogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]]];
    
    // Set buttons appearance
    
    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fbDown.png"] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];

    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signupDown.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    

    
    //Add login field background
    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginField.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    self.orLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orLabel.png"]];
    [self.logInView addSubview:self.orLabel];
    [self.logInView bringSubviewToFront:self.orLabel];

    self.signupLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signupLabel.png"]];
    [self.logInView addSubview:self.signupLabel];
    [self.logInView bringSubviewToFront:self.signupLabel];
    
    //Set field text color
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.passwordField setTextColor:[UIColor whiteColor]];
    self.logInView.externalLogInLabel.hidden = YES;
    self.logInView.signUpLabel.hidden = YES;

    //Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;

    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.logo setFrame:CGRectMake(35.0f, 0.0f, 250.0f, 250.0f)];
    [self.fieldsBackground setFrame:CGRectMake(40.0f, 170.0f, 250.0f, 100.0f)];
    [self.orLabel setFrame:CGRectMake(10.0f, 240.0f, 300.0f, 100.0f)];
    [self.logInView.facebookButton setFrame:CGRectMake(115.0f, 310.0f, 100.0f, 100.0f)];
    [self.signupLabel setFrame:CGRectMake(50.0f, 420.0f, 230.0, 50.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(90.0f, 460.0f, 150.0f, 35.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(40.0f, 180.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(40.0f, 210.0f, 250.0f, 50.0f)];
    
}

@end

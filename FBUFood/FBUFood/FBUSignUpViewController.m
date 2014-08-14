//
//  FBUSignUpViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/24/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUSignUpViewController.h"

@interface FBUSignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation FBUSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]]];
    
    // Change button apperance
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"dismiss.png"] forState:UIControlStateNormal];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signupDown.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add background for fields
    [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signupField.png"]]];
    [self.signUpView insertSubview:self.fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    // Change "Additional" to match our use
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.signUpView.dismissButton setFrame:CGRectMake(10.0f, 25.0f, 25.5f, 25.5f)];
    [self.signUpView.logo setFrame:CGRectMake(35.0f, 0.0f, 250.0f, 250.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(50.0f, 385.0f, 225.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(40.0f, 170.0f, 250.0f, 174.0f)];
    [self.signUpView.usernameField setFrame:CGRectMake(40.0f, 110.0f, 250.0f, 174.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(40.0f, 150.0f, 250.0f, 174.0f)];
    [self.signUpView.emailField setFrame:CGRectMake(40.0f, 190.0f, 250.0f, 174.0f)];
    [self.signUpView.additionalField setFrame:CGRectMake(40.0f, 230.0f, 250.0f, 174.0f)];
}


@end

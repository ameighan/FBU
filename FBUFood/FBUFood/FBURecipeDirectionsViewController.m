//
//  FBURecipeDirectionsViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeDirectionsViewController.h"
#import "FBURecipeContainerViewController.h"


@interface FBURecipeDirectionsViewController ()

@end

@implementation FBURecipeDirectionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.recipe.isYummlyRecipe) {
        NSString *directionsURL = self.recipe.directions;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:directionsURL]];
        UIWebView *myWV = [[UIWebView alloc] init];
        myWV.scalesPageToFit = YES;
        self.view = myWV;
        [(UIWebView *)self.view loadRequest:request];
    } else {
        self.directions.text = self.recipe.directions;
        [self.directions setFont:[UIFont fontWithName:@"Avenir" size:17.0]];

    }
}



@end

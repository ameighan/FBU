//
//  FBURecipeContainerViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeContainerViewController.h"
#import "FBURecipeDishViewController.h"
#import "FBURecipeIngredientViewController.h"
#import "FBURecipeDirectionsViewController.h"



@interface FBURecipeContainerViewController ()

@property (strong, nonatomic) FBURecipeDishViewController *dishViewController;
@property (strong, nonatomic) FBURecipeIngredientViewController *ingredientViewController;
@property (strong, nonatomic) FBURecipeDirectionsViewController *directionsViewController;

@end

@implementation FBURecipeContainerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSegueWithIdentifier:@"dish" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:@"dish"]) {
        self.dishViewController = segue.destinationViewController;
        self.dishViewController.recipe= self.recipe;

        
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.dishViewController];
        } else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }

    }
    
    if ([segue.identifier isEqualToString:@"ingredients"]) {
        self.ingredientViewController = segue.destinationViewController;
        self.ingredientViewController.recipe = self.recipe;

        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.ingredientViewController];
        } else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }

    }
    
    if ([segue.identifier isEqualToString:@"directions"]) {
        self.directionsViewController = segue.destinationViewController;
        self.directionsViewController.recipe = self.recipe;

        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.directionsViewController];
        } else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionAutoreverse animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}






@end

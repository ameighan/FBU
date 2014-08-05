//
//  FBURecipeDishViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeDishViewController.h"
#import "FBURecipeContainerViewController.h"

@interface FBURecipeDishViewController ()

@end

@implementation FBURecipeDishViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageWithData:[self.recipe.image getData]];
    self.imageView.image = image;
    self.dishTitleLabel.text = self.recipe.title;

}

- (IBAction)userDidFeatureDish:(id)sender
{
    self.event.eventFeatureDish = self.recipe;
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving featured recipe to %@", self.event);
    }];
}


@end

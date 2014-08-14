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
    
    [self.recipe.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
        [self.activityIndicator stopAnimating];
    }];
    
    self.dishTitleLabel.text = self.recipe.title;

    self.featureDishButton.hidden = YES;
    self.featureDishButton.enabled = NO;
    [self.featureDishButton setTintColor:[UIColor colorWithRed:249.0/255.0 green:118.0/255.0 blue:87.0/255.0 alpha:0.75]];
    [self.dishTitleLabel setFont:[UIFont fontWithName:@"Avenir" size:30.0]];
}

- (IBAction)userDidFeatureDish:(id)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"favorite_selected"] forState:UIControlStateHighlighted];
    [sender setBackgroundImage:[UIImage imageNamed:@"favorite_selected"] forState:UIControlStateNormal];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", self.recipe.title];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    self.event.featureImage = imageFile;
    
    self.event.featureImageHeight = self.imageView.image.size.height/(self.imageView.image.size.height*0.005);
    
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving featured recipe to %@", self.event);
    }];
}


@end

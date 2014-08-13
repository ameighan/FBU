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

}

- (IBAction)userDidFeatureDish:(id)sender
{
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", self.recipe.title];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    self.event.featureImage = imageFile;
    
    self.event.featureImageHeight = self.imageView.bounds.size.height;
    
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving featured recipe to %@", self.event);
    }];
}


@end

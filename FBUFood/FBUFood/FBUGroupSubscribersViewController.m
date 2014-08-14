//
//  FBUGroupSubscribersViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/23/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroupSubscribersViewController.h"
#import <Parse/Parse.h>

@implementation FBUGroupSubscribersViewController


- (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"
                                                            forIndexPath:indexPath];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
    cell.imageView.clipsToBounds = YES;
    
    cell.imageView.layer.borderWidth = 2.5f;
    cell.imageView.layer.borderColor = [UIColor colorWithRed:248.0/255.0 green:194.0/255.0 blue:96.0/255.0 alpha:0.75].CGColor;
    
    PFUser *user = self.group.subscribersOfGroup[indexPath.row];
    [user fetchIfNeeded];
    cell.textLabel.text = user[@"name"];

    
    if (user[@"profileImage"]) {
        
        UIImage *image = [UIImage imageWithData:[user[@"profileImage"] getData]];
        cell.imageView.image = image;
        
    } else {
        UIImage *image = [UIImage imageNamed:@"profile_default.png"];
        cell.imageView.image = image;
    }
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.group.subscribersOfGroup count];
}



@end

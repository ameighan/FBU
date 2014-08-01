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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"
                                                            forIndexPath:indexPath];
    
    PFUser *user = self.group.subscribersOfGroup[indexPath.row];
    
    [user fetchIfNeeded];
    
    cell.textLabel.text = [user username];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.group.subscribersOfGroup count];
}

@end

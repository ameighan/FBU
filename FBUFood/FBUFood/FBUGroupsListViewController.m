//
//  FBUGroupsListViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroupsListViewController.h"
#import "FBUGroupsViewController.h"
#import "FBUGroupsDetailViewController.h"
#import <Parse/Parse.h>
#import "FBUGroup.h"

@implementation FBUGroupsListViewController

- (NSArray *)queryingForGroupsCurrentUserIsIn
{
    PFQuery *query = [FBUGroup query];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    return [query findObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"
                                                            forIndexPath:indexPath];
    
    FBUGroup *group = self.myGroupsArray[indexPath.row];
    
    cell.textLabel.text = [group groupName];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myGroupsArray count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.myGroupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"groupCell"];
    
    self.myGroupsTableView.delegate = self;
    self.myGroupsTableView.dataSource = self;
}
                           
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.myGroupsArray = [self queryingForGroupsCurrentUserIsIn];
    [self.myGroupsTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"groupCell" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupCell"]) {
        NSIndexPath *indexPath = [self.myGroupsTableView indexPathForSelectedRow];
        
        FBUGroup *selectedGroup = self.myGroupsArray[indexPath.row];
        
        FBUGroupsViewController *groupViewController = segue.destinationViewController;
        
        groupViewController.group = selectedGroup;
        NSLog(@"%@", selectedGroup.groupName);
        
    }
}




@end

//
//  FBUExploreViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroup.h"
#import <Parse/Parse.h>
#import "FBUGroupsViewController.h"
#import "FBUExploreViewController.h"

@implementation FBUExploreViewController

- (IBAction)userDidEnterCravings:(id)sender
{
    // Extracted input from textfield to implement search later
    NSString *craving = self.cravingTextField.text;
}

- (void)queryingForGroupsCurrentUserIsNotIn
{
    __weak FBUExploreViewController *blockSelf = self;
    PFQuery *query = [FBUGroup query];
    [query whereKey:@"subscribersOfGroup" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"cooksInGroup" notEqualTo:[PFUser currentUser]];
    [query includeKey:@"eventsInGroup"];
    [query includeKey:@"recipesInGroup"];
    [query includeKey:@"cooksInGroup"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.exploratoryGroups = objects;
        [blockSelf.groupsTable reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"
                                                            forIndexPath:indexPath];
    
    FBUGroup *group = self.exploratoryGroups[indexPath.row];
    
    cell.textLabel.text = [group groupName];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.exploratoryGroups count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.groupsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"groupCell"];
    
    self.groupsTable.delegate = self;
    self.groupsTable.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self queryingForGroupsCurrentUserIsNotIn];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"groupCell" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupCell"]) {
        NSIndexPath *indexPath = [self.groupsTable indexPathForSelectedRow];
        
        FBUGroup *selectedGroup = self.exploratoryGroups[indexPath.row];
        
        FBUGroupsViewController *groupViewController = segue.destinationViewController;
        
        groupViewController.group = selectedGroup;
        NSLog(@"%@", selectedGroup.groupName);
        
    }
}

@end

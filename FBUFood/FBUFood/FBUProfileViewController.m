//
//  FBUProfileViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUProfileViewController.h"
#import <Parse/Parse.h>
#import "FBUGroupsListViewController.h"
#import "FBUGroupsViewController.h"
#import "FBUGroupsDetailViewController.h"
#import "FBUGroup.h"
#import "FBUDashboardViewController.h"
#import "FBUEditProfileViewController.h"
#import "FBURecipesListViewController.h"


@implementation FBUProfileViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryForRecipes];
    
    if ([PFUser currentUser]){
        PFUser *user = [PFUser currentUser];
        
        self.nameLabel.text = user[@"name"];
        self.emailLabel.text = user[@"email"];
        self.phoneLabel.text = user[@"additional"];
        if(user[@"fbImage"]) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"fbImage"]]]];
            self.profileImage.image = img;

        } else {
            UIImage *image = [UIImage imageWithData:[user[@"profileImage"] getData]];
            self.profileImage.image = image;
        }
    }
}

-(void)viewDidLoad
{
    [self.myGroupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

}

-(void)queryForRecipes
{
    __weak FBUProfileViewController *blockSelf = self;
    PFQuery *getGroups = [FBUGroup query];
    [getGroups whereKey:@"cooksInGroup" equalTo:[PFUser currentUser]];
    [getGroups includeKey:@"recipesInGroup"];
    [getGroups includeKey:@"cooksInGroup"];
    [getGroups includeKey:@"eventsInGroup"];
    [getGroups findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.myGroupsArray = objects;
        [blockSelf.myGroupsTableView reloadData];
    }];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self queryForRecipes];
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

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)segue
{
    if([segue.identifier isEqualToString:@"saveToProfile"]){
        FBUEditProfileViewController *controller = segue.sourceViewController;
        [controller saveProfileData];
    }
}



@end
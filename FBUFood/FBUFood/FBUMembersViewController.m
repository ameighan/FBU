//
//  FBUMembersViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/25/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUMembersViewController.h"
#import "FBUGroup.h"


@implementation FBUMembersViewController

//- (void)findMembersOfGroup
//{
 //   self.membersArray = self.group.cooksInGroup;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"
                                                            forIndexPath:indexPath];
    
    
    PFUser *oneMember = self.membersArray[indexPath.row];
    
    cell.textLabel.text = [oneMember username];
    NSLog(@"%@", [oneMember username]);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.membersArray count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.membersTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"groupCell"];
    
    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self findMembersOfGroup];
    [self.membersTableView reloadData];
}

@end

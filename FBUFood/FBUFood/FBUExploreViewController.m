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
#import "FBUGroupCollectionViewCell.h"

@implementation FBUExploreViewController

- (IBAction)userSeesAllGroups:(id)sender
{
    self.displayedGroups = self.exploratoryGroups;
    
    [self.groupsCollection reloadData];
    //[self.groupsTable reloadData];
}

- (IBAction)userDidEnterCravings:(id)sender
{
    // Extracted input from textfield to implement search later
    NSString *craving = self.cravingTextField.text;
    if (craving != nil || ![craving isEqualToString:@""]) {
        craving = [craving stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSUInteger numberOfGroups = [self.exploratoryGroups count];
        self.specificGroups = [[NSMutableArray alloc] init];
        NSArray *listOfCravings = [craving componentsSeparatedByString:@" "];
        NSMutableArray *cravingList = [[NSMutableArray alloc] init];
        if ([listOfCravings count] >= 1) {
            NSInteger num = [listOfCravings count];
            for (int i = 0; i < num; i++) {
                if([listOfCravings[i] length] > 0 && [[listOfCravings[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    if ([listOfCravings[i] length] > 1) {
                        NSString *toBeAdded = [listOfCravings[i] substringFromIndex:1];
                        [cravingList addObject:toBeAdded];
                    }
                }
            }
        }
        NSUInteger numberOfCravings = [cravingList count];
        for (int i = 0; i < numberOfGroups; i++) {
            FBUGroup *group = self.exploratoryGroups[i];
            for (int j = 0; j < numberOfCravings; j++) {
                NSRange name = [group.groupName rangeOfString:cravingList[j] options:NSCaseInsensitiveSearch];
                NSRange description = [group.groupDescription rangeOfString:cravingList[j] options:NSCaseInsensitiveSearch];
                if (name.location != NSNotFound) {
                    if (![self.specificGroups containsObject:group]) {
                        [self.specificGroups addObject:group];
                        NSLog([group groupName]);
                    }
                } else if (description.location != NSNotFound) {
                    if (![self.specificGroups containsObject:group]) {
                        [self.specificGroups addObject:group];
                        NSLog([group groupName]);
                    }
                }
            }
        }
        self.displayedGroups = nil;
        self.displayedGroups = self.specificGroups;
        
        [self.groupsCollection reloadData];
        //[self.groupsTable reloadData];
        
        self.cravingTextField.text = @"";
    }
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
        blockSelf.displayedGroups = objects;
        
        [blockSelf.groupsCollection reloadData];
       // [blockSelf.groupsTable reloadData];
        
    }];
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"
                                                            forIndexPath:indexPath];
    
    FBUGroup *group = self.displayedGroups[indexPath.row];
    
    cell.textLabel.text = [group groupName];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.displayedGroups count];
}*/

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FBUGroupCollectionViewCell *cell = [self.groupsCollection dequeueReusableCellWithReuseIdentifier:@"GroupCell" forIndexPath:indexPath];
    FBUGroup *group = self.displayedGroups[indexPath.row];
    cell.backgroundColor = [UIColor greenColor];
    cell.groupLabel.backgroundColor = [UIColor brownColor];
    cell.groupLabel.text = @"Helooooo";
    NSLog(cell.groupLabel.text);
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.displayedGroups count];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.groupsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"groupCell"];
    [self.groupsCollection registerClass:[FBUGroupCollectionViewCell class] forCellWithReuseIdentifier:@"GroupCell"];
    
    //self.groupsTable.delegate = self;
    //self.groupsTable.dataSource = self;
    self.groupsCollection.delegate = self;
    self.groupsCollection.dataSource = self;
    
    self.cravingTextField.delegate = self;
    
    [self queryingForGroupsCurrentUserIsNotIn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"groupCell" sender:self];
    
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupCell"]) {
       // NSIndexPath *indexPath = [self.groupsTable indexPathForSelectedRow];
        
       // FBUGroup *selectedGroup = self.exploratoryGroups[indexPath.row];
        
       // FBUGroupsViewController *groupViewController = segue.destinationViewController;
        
       // groupViewController.group = selectedGroup;
        
    }
}

@end

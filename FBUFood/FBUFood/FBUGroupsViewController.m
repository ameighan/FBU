//
//  FBUGroupsViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEvent.h"
#import "FBUGroupsViewController.h"
#import "FBUGroupsListViewController.h"
#import "FBUGroupSubscribersViewController.h"
#import "FBURecipesListViewController.h"
#import "FBUEventDetailViewController.h"
#import "FBUAddRecipesViewController.h"
#import "FBUMembersViewController.h"
#import "FBUEventViewController.h"
#import "FBUGroupsRecipesViewController.h"

@implementation FBUGroupsViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"
                                                            forIndexPath:indexPath];
    FBUEvent *myEvent = self.group.eventsInGroup[indexPath.row];
    
    cell.textLabel.text = [myEvent eventName];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.group.eventsInGroup count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.eventsInGroupTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"groupCell"];
    
    self.eventsInGroupTableView.delegate = self;
    self.eventsInGroupTableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self.eventsInGroupTableView selector:@selector(reloadData) name:@"savedEvent" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.group checkIfUserIsInGroupArray:self.group.cooksInGroup]) {
        [self toggleCookView];
        NSLog(@"Toggling cook view");
        NSLog(@"Cooks: %@", self.group.cooksInGroup);
        NSLog(@"Subscribers: %@", self.group.subscribersOfGroup);
        
    } else if ([self.group checkIfUserIsInGroupArray:self.group.subscribersOfGroup]) {
        [self toggleSubscriberView];
        NSLog(@"Toggling subscriber view");
        NSLog(@"Subscribers: %@", self.group.subscribersOfGroup);
    }
    
    self.title = self.group.groupName;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    
    CGFloat eventWidth = 320;
    NSUInteger numberOfEvents = [self.group.eventsInGroup count];
    for (NSUInteger i = 0; i < numberOfEvents; i++) {
        UIImageView *eventFeatureDish = [[UIImageView alloc] initWithFrame: CGRectMake(eventWidth * i, 0, eventWidth, self.eventsScrollView.bounds.size.height)];
//        eventFeatureDish.image = ;
        [self.eventsScrollView addSubview:eventFeatureDish];
    }
    
    CGSize contentSize = CGSizeMake(eventWidth * numberOfEvents, self.eventsScrollView.bounds.size.height);
    self.eventsScrollView.contentSize = contentSize;
    
    [self.eventsInGroupTableView reloadData];
    
}


- (void)toggleCookView
{
    self.createEventInGroupButton.hidden = NO;
    self.addRecipeInGroupButton.hidden = NO;
    self.viewSubscribersInGroupButton.hidden = NO;
    
    
    //Disable and hide the old buttons
    self.joinGroupButton.hidden = YES;
    self.joinGroupButton.enabled = NO;
    self.subscribeGroupButton.hidden = YES;
    self.subscribeGroupButton.enabled = NO;
}

- (void)toggleSubscriberView
{
    self.joinGroupButton.hidden = YES;
    self.joinGroupButton.enabled = NO;
    self.subscribeGroupButton.hidden = YES;
    self.subscribeGroupButton.enabled = NO;
}


- (IBAction)addUserToGroupAsCook:(id)sender
{
    
    [self showAlertWithTitle:@"Success!" message:@"You have joined this group!"];
    
    [self.group addObject:[PFUser currentUser] forKey:@"cooksInGroup"];
    [self.group addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    [self.group saveInBackground];
    
    [self toggleCookView];
    
}


- (IBAction)addUserToGroupAsSubscriber:(id)sender
{
    
    [self showAlertWithTitle:@"Success!" message:@"You have subscribed to this group!"];
    
    [self.group addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    [self.group saveInBackground];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewSubscribers"]) {
        
        FBUGroupSubscribersViewController *groupSubscribersViewController = segue.destinationViewController;
        
        groupSubscribersViewController.group = self.group;
        NSLog(@"Accessing subscribers of %@", groupSubscribersViewController.group.groupName);
        
    } else if ([segue.identifier isEqualToString:@"groupRecipe"]) {
        
        FBUGroupsRecipesViewController *recipesViewController = segue.destinationViewController;
        recipesViewController.sourceVC = @"group";
        recipesViewController.group = self.group;
        recipesViewController.recipesArray = self.group.recipesInGroup;
        recipesViewController.title = @"Group Recipes";
        NSLog(@"Recipes in Group: %@", self.group.recipesInGroup);
        
    } else if ([segue.identifier isEqualToString:@"createEvent"]) {
        FBUEventDetailViewController *eventDetailViewController = segue.destinationViewController;
        eventDetailViewController.group = self.group;
        eventDetailViewController.title = @"Create New Event";
        
    } else if ([segue.identifier isEqualToString:@"viewCooks"]) {
        
        FBUMembersViewController *membersViewController = segue.destinationViewController;
        //membersViewController.group = self.group;
        membersViewController.membersArray = self.group.cooksInGroup;
        
    } else if ([segue.identifier isEqualToString:@"eventCell"]) {
        
        FBUEventViewController *eventViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.eventsInGroupTableView indexPathForSelectedRow];
        
        FBUEvent *selectedEvent= self.group.eventsInGroup[indexPath.row];
        //NSLog(@"Events in Group: %@", self.group.eventsInGroup);
        
        eventViewController.event = selectedEvent;
        
        //NSLog(@"%@ was selected.", selectedEvent.eventName);
    }
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)unwindToGroupViewController:(UIStoryboardSegue *)segue
{
    FBUEventDetailViewController *controller = segue.sourceViewController;
    [controller saveEventData];
}


@end

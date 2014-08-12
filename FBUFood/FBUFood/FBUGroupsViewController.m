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
#import "FBUEventCollectionViewCell.h"
#import "FBUUserCollectionViewCell.h"

@implementation FBUGroupsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventsCollectionView.backgroundColor = [UIColor clearColor];
    self.cooksCollectionView.backgroundColor = [UIColor clearColor];
    [self.joinGroupButton setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [self.subscribeGroupButton setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [self.createEventInGroupButton setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [self.viewSubscribersInGroupButton setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self.eventsCollectionView selector:@selector(reloadData) name:@"savedEvent" object:nil];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 586)];
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
    self.groupNameLabel.text = self.group.groupName;
    UIImage *groupImage = [UIImage imageWithData:[self.group.groupImage getData]];
    self.groupImageView.image = groupImage;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    
    
    [self.eventsCollectionView reloadData];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.eventsCollectionView];
}

- (void)toggleCookView
{
    self.createEventInGroupButton.hidden = NO;
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

# pragma mark - Collection View

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.eventsCollectionView) {
        FBUEventCollectionViewCell *cell = [self.eventsCollectionView dequeueReusableCellWithReuseIdentifier:@"event" forIndexPath:indexPath];
        
        FBUEvent *event = self.group.eventsInGroup[indexPath.row];
        
        
        [event.featureImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.eventImageView.image = [UIImage imageWithData:data];
        }];
        
        
    //    cell.eventImageView.image = eventFeatureDishImage;
       
        cell.eventNameLabel.text = event.eventName;
//        cell.eventTimeDateLabel.text = event.eventTimeDate;
        cell.eventLocationLabel.text = event.eventAddress;
        
        [cell.eventNameLabel setFont:[UIFont fontWithName:@"Avenir" size:19.0]];
        [cell.eventLocationLabel setFont:[UIFont fontWithName:@"Avenir" size:13.0]];
        [cell.monthLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
        [cell.dayLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
        
        
        return cell;
    }
    if (collectionView == self.cooksCollectionView) {
        
        FBUUserCollectionViewCell *cell = [self.cooksCollectionView dequeueReusableCellWithReuseIdentifier:@"user" forIndexPath:indexPath];
        
        PFUser *member = self.group.cooksInGroup[indexPath.row];
        [member fetchIfNeeded];
        
        if(member[@"fbImage"]) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:member[@"fbImage"]]]];
            cell.userProfileImage.image = [self getRoundedRectImageFromImage:img onReferenceView:cell.userProfileImage withCornerRadius: cell.userProfileImage.frame.size.width/2];
        } else {
            if (member[@"profileImage"]) {
                [member[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data scale:0.8];
                    cell.userProfileImage.image = [self getRoundedRectImageFromImage:image onReferenceView:cell.userProfileImage withCornerRadius: cell.userProfileImage.frame.size.width/2];
                }];
            } else {
                UIImage *image = [UIImage imageNamed:@"profile_default.png"];
                cell.userProfileImage.image = [self getRoundedRectImageFromImage:image onReferenceView:cell.userProfileImage withCornerRadius: cell.userProfileImage.frame.size.width/2];
            }
        }

        
        return cell;
    }
    return false;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.eventsCollectionView) {
        return [self.group.eventsInGroup count];
    }
    if (collectionView == self.cooksCollectionView) {
        return [self.group.cooksInGroup count];
    }
    return false;
}


# pragma mark - Actions

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
        
        NSIndexPath *indexPath = [self.eventsCollectionView indexPathForCell:sender];
        
        FBUEvent *selectedEvent= self.group.eventsInGroup[indexPath.row];
        
        eventViewController.event = selectedEvent;
    
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

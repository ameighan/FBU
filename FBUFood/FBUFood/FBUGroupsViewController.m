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
    
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:14.0];
    UIFont *headerFont = [UIFont fontWithName:@"Avenir" size:18.0];
    
    
    [self.cooksLabel setFont:headerFont];
    [self.eventsLabel setFont:headerFont];
    
    [self createButtonUI:self.joinGroupButton];
    [self createButtonUI:self.subscribeGroupButton];
    [self createButtonUI:self.unsubscribeButton];
    [self createButtonUI:self.leaveGroupButton];
    
    [self.groupNameLabel setFont:[UIFont fontWithName:@"Avenir" size:24.0]];
    self.groupDescriptionTextView.font = defaultFont;
    
    CGFloat height = 198.0 * [self.group.eventsInGroup count];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 375.0 + height)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(elongateScrollView) name:@"savedEvent" object:nil];
    
}

- (void)elongateScrollView {
    [self.eventsCollectionView reloadData];
    
    CGFloat height = 198.0 * [self.group.eventsInGroup count];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 375.0 + height)];

}

- (void)createButtonUI:(UIButton *)button
{
    [button setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [[button layer] setBorderWidth:1.5f];
    [[button layer] setBorderColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00].CGColor];
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    
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
        
    } else if ([self.group checkIfUserIsInGroupArray:self.group.subscribersOfGroup]) {
        [self toggleSubscriberView];
        NSLog(@"Toggling subscriber view");
    }
    
    self.title = self.group.groupName;
    self.groupNameLabel.text = self.group.groupName;
    self.groupDescriptionTextView.text = self.group.groupDescription;
    
    [self.eventsCollectionView reloadData];
    
    CGFloat width = 325.0;
    CGFloat height = 198.0 * [self.group.eventsInGroup count];
    
    self.eventsCollectionView.frame = CGRectMake(0, 360.0, width, 360.0 + height);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.eventsCollectionView];
}

- (void)toggleCookView
{
    //Disable and hide the old buttons
    self.joinGroupButton.hidden = YES;
    self.joinGroupButton.enabled = NO;
    self.subscribeGroupButton.hidden = YES;
    self.subscribeGroupButton.enabled = NO;
    
    self.leaveGroupButton.hidden = NO;
    self.leaveGroupButton.enabled = YES;
}

- (void)toggleSubscriberView
{
    self.joinGroupButton.hidden = YES;
    self.joinGroupButton.enabled = NO;
    self.subscribeGroupButton.hidden = YES;
    self.subscribeGroupButton.enabled = NO;
    
    self.unsubscribeButton.hidden = NO;
    self.unsubscribeButton.enabled = YES;
}

- (void)toggleNormalView
{
    self.joinGroupButton.hidden = NO;
    self.joinGroupButton.enabled = YES;
    self.subscribeGroupButton.hidden = NO;
    self.subscribeGroupButton.enabled = YES;
    
    self.leaveGroupButton.hidden = YES;
    self.leaveGroupButton.enabled = NO;
    self.unsubscribeButton.hidden = YES;
    self.unsubscribeButton.enabled = NO;
    
}


# pragma mark - Collection View

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.eventsCollectionView) {
        FBUEventCollectionViewCell *cell = [self.eventsCollectionView dequeueReusableCellWithReuseIdentifier:@"event" forIndexPath:indexPath];
        
        FBUEvent *event = self.group.eventsInGroup[indexPath.row];
        
        
        [event.featureImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.eventImageView.image = [UIImage imageWithData:data];
        }];
        
        cell.eventNameLabel.text = event.eventName;
        cell.eventLocationLabel.text = event.eventAddress;
        [cell.eventNameLabel setFont:[UIFont fontWithName:@"Avenir" size:19.0]];
        [cell.eventLocationLabel setFont:[UIFont fontWithName:@"Avenir" size:13.5]];
        [cell.monthLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
        [cell.dayLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *date = [dateFormatter stringFromDate:event.eventTimeDate];
        NSArray *eventTimeDateArray = [date componentsSeparatedByString:@" "];
        
        cell.monthLabel.text = eventTimeDateArray[0];
        NSMutableString *day = eventTimeDateArray[1];
        NSString *dayParsed = [day substringToIndex:[day length] - 1];
        cell.dayLabel.text = dayParsed;
        
        return cell;
    }
    if (collectionView == self.cooksCollectionView) {
        
        FBUUserCollectionViewCell *cell = [self.cooksCollectionView dequeueReusableCellWithReuseIdentifier:@"user" forIndexPath:indexPath];
        
        cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.size.width / 2;
        cell.userProfileImage.clipsToBounds = YES;
        
        cell.userProfileImage.layer.borderWidth = 0.5f;
        cell.userProfileImage.layer.borderColor = [UIColor blackColor].CGColor;
        
        PFUser *member = self.group.cooksInGroup[indexPath.row];
        [member fetchIfNeeded];
        
        if(member[@"fbImage"]) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:member[@"fbImage"]]]];
            cell.userProfileImage.image = img;
        } else {
            if (member[@"profileImage"]) {
                [member[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data scale:0.8];
                    cell.userProfileImage.image = image;
                }];
            } else {
                UIImage *image = [UIImage imageNamed:@"profile_default.png"];
                cell.userProfileImage.image = image;
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

# pragma mark - Action Sheet: More options
- (IBAction)moreOptions:(id)sender
{
    
    if ([self.group checkIfUserIsInGroupArray:self.group.cooksInGroup]) {
        UIActionSheet *popupMenu = [[UIActionSheet alloc] initWithTitle:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Edit Group",
                                                                        @"Create Event",
                                                                        @"View Recipes",
                                                                        @"View Subscribers",
                                                                        nil];
    popupMenu.tag = 0;
    [popupMenu showInView:self.view];
    } else {
        UIActionSheet *popupMenu = [[UIActionSheet alloc] initWithTitle:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"View Recipes",
                                                                        @"View Subscribers",
                                                                        nil];
        popupMenu.tag = 1;
        [popupMenu showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)popupMenu didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (popupMenu.tag) {
        case 0: {
            switch (buttonIndex) {
                case 0:
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"createEvent" sender:self];
                    break;
                case 2:
                    NSLog(@"Segue to group recipes");
                    [self performSegueWithIdentifier:@"groupRecipe" sender:self];
                    break;
                case 3:
                    NSLog(@"Segue to group's subscribers");
                    [self performSegueWithIdentifier:@"viewSubscribers" sender:self];
                    break;
                default:
                    break;
            }
            break;
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self performSegueWithIdentifier:@"groupRecipe" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"viewSubscribers" sender:self];
                    break;
                }
            }
        }
        default:
            break;
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00];
//            if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"Edit Group", nil)]) {
//                [button setTitleColor:[UIColor colorWithRed:167.0/255.0 green:204.0/255.0 blue:144.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//            }
//            if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"Create Event", nil)]) {
//                [button setTitleColor:[UIColor colorWithRed:167.0/255.0 green:204.0/255.0 blue:144.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//            }
        }
    }];
}


# pragma mark - Actions

- (IBAction)addUserToGroupAsCook:(id)sender
{
    
    [self showAlertWithTitle:@"Success!" message:@"You have joined this group!" confirmButton:@"OK" cancelButton:nil andTag:0];
    
    [self.group addObject:[PFUser currentUser] forKey:@"cooksInGroup"];
    [self.group addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving in the background...");
    }];
    
    [self toggleCookView];
    
}


- (IBAction)addUserToGroupAsSubscriber:(id)sender
{
    
    [self showAlertWithTitle:@"Success!" message:@"You have subscribed to this group!" confirmButton:@"OK" cancelButton:nil andTag:0];
    
    [self.group addObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
    [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving in the background...");
    }];
    
    [self toggleSubscriberView];
}

- (IBAction)userDidLeaveGroup:(id)sender
{
    [self showAlertWithTitle:@"Leaving Group" message:@"Are you sure you want to leave this group?" confirmButton:@"Yes" cancelButton:@"Cancel" andTag:1];
}

- (IBAction)userDidUnsubscribeToGroup:(id)sender
{
    [self showAlertWithTitle:@"Unsubscribing" message:@"Are you sure you want to unsubscribe?" confirmButton:@"Yes" cancelButton:@"Cancel" andTag:2];
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmButton:(NSString *)confirmMessage cancelButton:(NSString *)cancelMessage andTag:(NSInteger)tag
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:confirmMessage
                                          otherButtonTitles:cancelMessage, nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self.group removeObject:[PFUser currentUser] forKey:@"cooksInGroup"];
            [self.group removeObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
            [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Removing user from group and as a subscriber...");
            }];
            [self toggleNormalView];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self.group removeObject:[PFUser currentUser] forKey:@"subscribersOfGroup"];
            [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Removing user as a subscriber...");
            }];
            [self toggleNormalView];
        }
    }
}

# pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupRecipe"]) {
        
        FBUGroupsRecipesViewController *recipesViewController = segue.destinationViewController;
        recipesViewController.sourceVC = @"group";
        recipesViewController.group = self.group;
        recipesViewController.recipesArray = self.group.recipesInGroup;
        recipesViewController.title = @"Group Recipes";
        
    } else if ([segue.identifier isEqualToString:@"viewSubscribers"]) {
        
        FBUGroupSubscribersViewController *groupSubscribersViewController = segue.destinationViewController;
        
        groupSubscribersViewController.group = self.group;
        NSLog(@"Accessing subscribers of %@", groupSubscribersViewController.group.groupName);
        
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


- (IBAction)unwindToGroupViewController:(UIStoryboardSegue *)segue
{
    FBUEventDetailViewController *controller = segue.sourceViewController;
    [controller saveEventData];
}


@end

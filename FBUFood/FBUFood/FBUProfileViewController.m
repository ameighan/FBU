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
#import <QuartzCore/QuartzCore.h>

#define kCollectionCellBorderTop 10.0
#define kCollectionCellBorderBottom 17.0
#define kCollectionCellBorderLeft 17.0
#define kCollectionCellBorderRight 17.0


@implementation FBUProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryForUserData];
    
    if ([PFUser currentUser]){
        PFUser *user = [PFUser currentUser];
        if (!user[@"name"]) {
            self.nameLabel.text = @"My Name";
        } else {
            self.nameLabel.text = user[@"name"];
        }
        if(user[@"fbImage"]) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"fbImage"]]]];
            self.profileImage.image = [self getRoundedRectImageFromImage:img onReferenceView:self.profileImage withCornerRadius: self.profileImage.frame.size.width/2];

        } else {
            if(user[@"profileImage"]) {
                UIImage *image = [UIImage imageWithData:[user[@"profileImage"] getData]];
                self.profileImage.image = [self getRoundedRectImageFromImage:image onReferenceView:self.profileImage withCornerRadius: self.profileImage.frame.size.width/2];
            } else {
                UIImage *image = [UIImage imageNamed:@"profile_default.png"];
                self.profileImage.image = [self getRoundedRectImageFromImage:image onReferenceView:self.profileImage withCornerRadius: self.profileImage.frame.size.width/2];

            }

        }
    }
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 586)];
    FBUCollectionViewLayout *layout = [[FBUCollectionViewLayout alloc] init];
    layout.interitemSpacing = 10.0;
    layout.lineSpacing = 10.0;
}

-(void)queryForUserData
{
    __weak FBUProfileViewController *blockSelf = self;
    PFQuery *getGroups = [FBUGroup query];
    [getGroups whereKey:@"cooksInGroup" equalTo:[PFUser currentUser]];
    [getGroups includeKey:@"recipesInGroup"];
    [getGroups includeKey:@"cooksInGroup"];
    [getGroups includeKey:@"eventsInGroup"];
    [getGroups findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.myGroupsArray = objects;
        [blockSelf.activityIndicator stopAnimating];
        [blockSelf.myGroupsCollectionView reloadData];
    }];
    
    
}
- (IBAction)addGroupButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"addGroup" sender:sender];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //UIImage *myImage = [UIImage imageNamed:@"RecipeButton.png"];
    //[self.imageView setImage:myImage];
    [self queryForUserData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupCell"]) {
        NSIndexPath *ip = [self.myGroupsCollectionView indexPathForCell:sender];
        
        FBUGroup *selectedGroup = self.myGroupsArray[ip.row];
        
        FBUGroupsViewController *groupViewController = (FBUGroupsViewController *)segue.destinationViewController;
        
        groupViewController.group = selectedGroup;
        NSLog(@"%@ was selected", selectedGroup.groupName);
    } 
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)segue
{
    if([segue.identifier isEqualToString:@"saveToProfile"]){
        FBUEditProfileViewController *controller = segue.sourceViewController;
        [controller saveProfileData];
    }
}

#pragma mark - UICollectionViewDelegateJSPintLayout
- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return 155.0;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    FBUGroup *group = self.myGroupsArray[indexPath.row];
    if (!group.groupImage) {
        return 200;
    }
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[group.groupImage getData]]];
    CGSize rctSizeOriginal = imageView.bounds.size;
    double scale = (222  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    CGFloat height = imageView.bounds.size.height + 15.0;
    
    return height;
}


# pragma mark - Collection View Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBUGroup *group = self.myGroupsArray[indexPath.row];
    
    UICollectionViewCell *cell = [self.myGroupsCollectionView dequeueReusableCellWithReuseIdentifier:@"groupCell" forIndexPath:indexPath];
    
    CGRect rectReference = cell.bounds;
    FBUCollectionCellBackgroundView* backgroundView = [[FBUCollectionCellBackgroundView alloc] initWithFrame:rectReference];
    cell.backgroundView = backgroundView;
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:rectReference];
    selectedBackgroundView.backgroundColor = [UIColor clearColor];   // no indication of selection
    cell.selectedBackgroundView = selectedBackgroundView;
    
    // remove subviews from previous usage of this cell
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[group.groupImage getData]]];
    
    CGSize rctSizeOriginal = imageView.bounds.size;
    double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + 20,rctSizeFinal.width,rctSizeFinal.height);
    
    [cell.contentView addSubview:imageView];
    
    CGRect descriptionLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + rctSizeFinal.height + 15,rctSizeFinal.width,40);
    CGRect nameLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop, rctSizeFinal.width,15);
    
    UILabel* name = [[UILabel alloc] initWithFrame:nameLabel];
    name.numberOfLines = 0;
    name.font = [UIFont systemFontOfSize:12];
    
    UILabel* description = [[UILabel alloc] initWithFrame:descriptionLabel];
    description.numberOfLines = 2;
    description.font = [UIFont systemFontOfSize:12];
    
    name.text = [group groupName];
    description.text = [group groupDescription];
    
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:description];
    
    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.myGroupsArray count];
}



@end
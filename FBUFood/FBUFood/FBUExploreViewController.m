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

#define kCollectionCellBorderTop 5.0
#define kCollectionCellBorderBottom 5.0
#define kCollectionCellBorderLeft 10.0
#define kCollectionCellBorderRight 10.0

@implementation FBUExploreViewController

- (IBAction)userSeesAllGroups:(id)sender
{
    self.displayedGroups = self.exploratoryGroups;
    
    [self.groupsCollection reloadData];
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
    }];
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
    
    self.cravingTextField.delegate = self;
    
    [self queryingForGroupsCurrentUserIsNotIn];
    
    FBUCollectionViewLayout *layout = [[FBUCollectionViewLayout alloc] init];
    layout.interitemSpacing = 5.0;
    layout.lineSpacing = 5.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupCell"]) {
        FBUGroupsViewController *controller = (FBUGroupsViewController *)segue.destinationViewController;
        NSIndexPath *ip = [self.groupsCollection indexPathForCell:sender];
        controller.group = self.displayedGroups[ip.row];
        
    }
}

#pragma mark - UICollectionViewDelegateJSPintLayout
- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return 135.0;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    FBUGroup *group = self.displayedGroups[indexPath.row];
    if (!group.groupImage) {
        return 200;
    }
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[group.groupImage getData]]];
    CGSize rctSizeOriginal = imageView.bounds.size;
    double scale = (222  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    CGFloat height = imageView.bounds.size.height;
    
    return height;
}


# pragma mark - Collection View Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBUGroup *group = self.displayedGroups[indexPath.row];
    
    UICollectionViewCell *cell = [self.groupsCollection dequeueReusableCellWithReuseIdentifier:@"groupCell" forIndexPath:indexPath];
    
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
    return [self.displayedGroups count];
}

@end

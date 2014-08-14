//
//  FBUBucketListItemsViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListItemsViewController.h"
#import "FBUBucketListDetailViewController.h"
#import "FBUBucketListItem.h"
#import "FBUBucketListViewController.h"
#import <Parse/Parse.h>

@implementation FBUBucketListItemsViewController

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.tableView.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:NO];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}


- (void)createButtonUI:(UIButton *)button
{
    [button setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [[button layer] setBorderWidth:1.5f];
    [[button layer] setBorderColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00].CGColor];
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *myItems = [[NSMutableArray alloc]initWithArray:self.items];
        [myItems removeObject:self.items[indexPath.row]];
        [self.items[indexPath.row] deleteInBackground];
        self.items = myItems;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

- (NSArray *)queryingForBucketListItems
{
    PFQuery *query = [FBUBucketListItem query];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    return [query findObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BucketListCell"
                                                            forIndexPath:indexPath];
    FBUBucketListItem *bucketItem = self.items[indexPath.row];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];

    if (bucketItem.isCrossedOff) {
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[bucketItem itemName]];
        
        // making text property to strike text- NSStrikethroughStyleAttributeName
        [titleString addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [titleString length])];
        
        // using text on label
        [cell.textLabel setAttributedText: titleString];
    } else {
        cell.textLabel.text = [bucketItem itemName];
    }
    cell.imageView.image = [UIImage imageWithData:[bucketItem.picture getData]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    //[self performSegueWithIdentifier:@"BucketListCell" sender:self];
    
}

- (IBAction)doneWithTask:(id)sender {
    NSArray *selectedCells = [self.tableView indexPathsForSelectedRows];
    
    for (NSIndexPath *selectedCell in selectedCells){
        NSIndexPath *indexPath = selectedCell;
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BucketListCell"
                                                                forIndexPath:indexPath];
        FBUBucketListItem *selectedItem = self.items[indexPath.row];
        NSString* textToBeCut = selectedItem.itemName;
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:textToBeCut];
        
        // making text property to strike text- NSStrikethroughStyleAttributeName
        [titleString addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [titleString length])];
        
        // using text on label
        [cell.textLabel setAttributedText: titleString];
        selectedItem.isCrossedOff = true;
        [selectedItem saveInBackground];
        
        cell.imageView.image = [UIImage imageWithData:[selectedItem.picture getData]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BucketListCell"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FBUBucketListItem *myItem = self.items[indexPath.row];
        FBUBucketListViewController *itemsViewController = segue.destinationViewController;
        itemsViewController.item = myItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BucketListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.items = [self queryingForBucketListItems];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createButtonUI:self.editButton];
    [self createButtonUI:self.crossOffButton];
}

@end

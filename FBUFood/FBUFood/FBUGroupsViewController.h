//
//  FBUGroupsViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBUGroup;

@interface FBUGroupsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) FBUGroup *group;

@property (weak, nonatomic) IBOutlet UITextView *groupDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *recipesInGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *subscribeGroupButton;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cooksCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

//Buttons shown if you have joined the group
@property (weak, nonatomic) IBOutlet UIButton *createEventInGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *viewSubscribersInGroupButton;

@property (weak, nonatomic) NSArray *eventsByGroup;

@end


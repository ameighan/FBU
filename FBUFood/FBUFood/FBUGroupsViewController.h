//
//  FBUGroupsViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBUGroup;

@interface FBUGroupsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) FBUGroup *group;

@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *subscribeGroupButton;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cooksCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *groupDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *cooksLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventsLabel;

//Buttons shown if you have joined the group
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreOptionsBarButton;
@property (weak, nonatomic) IBOutlet UIButton *unsubscribeButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveGroupButton;

@property (weak, nonatomic) NSArray *eventsByGroup;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


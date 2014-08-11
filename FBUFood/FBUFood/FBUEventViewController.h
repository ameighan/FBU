//
//  FBUEventViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FBUEvent.h"

@interface FBUEventViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) FBUEvent *event;

@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeDateLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *eventRecipesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *eventMembersCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *eventJoinButton;
@property (weak, nonatomic) IBOutlet UILabel *eventMealsLabel;
@property (weak, nonatomic) IBOutlet MKMapView *eventMapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreOptionsButton;

@property (weak, nonatomic) NSArray *peopleGoing;

@end

//
//  FBUDashboardViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FBUCollectionViewLayout.h"
#import "FBUCollectionCellBackgroundView.h"

@interface FBUDashboardViewController : UIViewController <CLLocationManagerDelegate, UICollectionViewDelegateJSPintLayout, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *eventsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *dashboardCollectionView;


@end

//
//  FBUDashboardViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FBUDashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *eventsArray;
@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;

-(void)makeLoginAppear;

@end

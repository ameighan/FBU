//
//  FBUEvent.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "FBUGroceryList.h"
#import "FBUGroup.h"

@interface FBUEvent : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *eventTimeDate;
@property (strong, nonatomic) NSString *eventAddress;
//@property (strong, nonatomic) FBUGroup *eventParentGroup;
@property (nonatomic) PFGeoPoint *eventGeoPoint;
@property (strong, nonatomic) NSTimeZone *timeZoneOfEvent;
@property (nonatomic) int mealsLeftCounter;
@property (strong, nonatomic) NSMutableArray *recipesInEvent;
@property (strong, nonatomic) NSMutableArray *membersOfEvent;
@property (strong, nonatomic) FBUGroceryList *groceryList;


@end

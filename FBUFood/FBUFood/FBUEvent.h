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

@class FBUGroup;
@class FBURecipe;

@interface FBUEvent : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSDate *eventTimeDate;
@property (strong, nonatomic) NSString *eventAddress;
@property (strong, nonatomic) NSString *eventMeals;
@property (strong, nonatomic) FBUGroup *eventParentGroup;
@property (nonatomic) PFGeoPoint *eventGeoPoint;
@property (strong, nonatomic) PFUser *eventOwner;

@property (nonatomic) int mealsLeftCounter;
@property (strong, nonatomic) NSMutableArray *recipesInEvent;
@property (strong, nonatomic) NSMutableArray *membersOfEvent;
@property (strong, nonatomic) FBUGroceryList *eventGroceryList;
@property (strong, nonatomic) PFUser *creator;

@property(strong, nonatomic) PFFile *featureImage;
@property(nonatomic) CGFloat featureImageHeight;

- (BOOL)checkIfUserIsInEventArray:(NSMutableArray *)eventArray;

@end

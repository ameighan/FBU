//
//  FBUEvent.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FBUGroceryList.h"

@interface FBUEvent : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *eventTitle;
@property (nonatomic) int hourOfEvent;
@property (nonatomic) int minuteOfEvent;
@property (strong, nonatomic) NSTimeZone *timeZoneOfEvent;
@property (nonatomic) int mealsLeftCounter;
@property (strong, nonatomic) NSArray *recipesInEvent;
@property (strong, nonatomic) FBUGroceryList *groceryList;


@end

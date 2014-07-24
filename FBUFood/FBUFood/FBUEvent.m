//
//  FBUEvent.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEvent.h"
#import <Parse/PFObject+Subclass.h>


@implementation FBUEvent

+ (NSString *)parseClassName
{
    return @"FBUEvent";
}

@dynamic eventName;
@dynamic eventDescription;
@dynamic eventTimeDate;
@dynamic eventAddress;
//@dynamic eventParentGroup;
@dynamic eventGeoPoint;
@dynamic timeZoneOfEvent;
@dynamic mealsLeftCounter;
@dynamic recipesInEvent;
@dynamic membersOfEvent;
@dynamic groceryList;

@end

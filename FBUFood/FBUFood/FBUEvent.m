//
//  FBUEvent.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEvent.h"
#import "FBUGroup.h"
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
@dynamic eventMeals;
@dynamic eventParentGroup;
@dynamic eventOwner;
@dynamic eventFeatureDish;
@dynamic eventGeoPoint;
@dynamic mealsLeftCounter;
@dynamic recipesInEvent;
@dynamic membersOfEvent;
@dynamic groceryList;
@dynamic creator;
@dynamic featureImage;


- (BOOL)checkIfUserIsInEventArray:(NSMutableArray *)eventArray
{
    
    NSUInteger index = [eventArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        PFUser *user = obj;
        return [user.objectId isEqualToString:[PFUser currentUser].objectId];
    }];
    
    return index != NSNotFound;
    
}

@end

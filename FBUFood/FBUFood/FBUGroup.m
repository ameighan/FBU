//
//  FBUGroup.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroup.h"
#import <Parse/PFObject+Subclass.h>
#import "FBURecipe.h"
#import "FBUEvent.h"



@implementation FBUGroup

+ (NSString *)parseClassName
{
    return @"FBUGroup";
}

@dynamic groupName;
@dynamic groupDescription;
@dynamic generalMeetingTimes;
@dynamic owner;
@dynamic recipesInGroup;
@dynamic eventsInGroup;
@dynamic cooksInGroup;
@dynamic subscribersOfGroup;

@end

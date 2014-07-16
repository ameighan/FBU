//
//  FBUGroup.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/15/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FBURecipe.h"
#import "FBUEvent.h"

@interface FBUGroup : PFObject <PFSubclassing>

+ (NSString *)parseClassName;


@property (strong, nonatomic) NSString *groupTitle;
@property (strong, nonatomic) NSString *groupDescription;
@property (strong, nonatomic) NSString *generalMeetingTimes;

//NSArrays of Parse Objects (FBURecipe and FBUEvent respectively)
@property (strong, nonatomic) NSArray *recipesInGroup;
@property (strong, nonatomic) NSArray *eventsInGroup;

//NSArrays of users...
@property (strong, nonatomic) NSArray *cooksInGroup;
@property (strong, nonatomic) NSArray *subscribersOfGroup;

- (NSArray *)addObject:(id)object toGroup:(NSArray *)group;
- (void)addRecipeToGroup:(FBURecipe *)recipe;
- (void)addEventToGroup:(FBUEvent *)event;
- (void)addCookToGroup:(PFUser *)cook;
- (void)addSubScriberToGroup:(PFUser *)subscriber;



@end

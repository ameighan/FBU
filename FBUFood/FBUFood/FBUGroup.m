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

- (NSArray *)addObject:(id)object toGroup:(NSArray *)group
{
    NSMutableArray *mutableVersion = [group mutableCopy];
    [mutableVersion addObject:object];
    return [mutableVersion copy];
}

- (void)addRecipeToGroup:(FBURecipe *)recipe
{
    self.recipesInGroup = [self addObject:recipe
                                  toGroup:self.recipesInGroup];
}

- (void)addEventToGroup:(FBUEvent *)event
{
    self.eventsInGroup = [self addObject:event
                                 toGroup:self.eventsInGroup];
}

- (void)addCookToGroup:(PFUser *)cook
{
    self.cooksInGroup = [self addObject:cook
                                toGroup:self.cooksInGroup];
    
}

- (void)addSubScriberToGroup:(PFUser *)subscriber
{
    self.subscribersOfGroup = [self addObject:subscriber
                                      toGroup:self.subscribersOfGroup];
}

@end

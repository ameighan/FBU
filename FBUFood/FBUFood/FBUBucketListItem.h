
//  FBUBucketListItem.h
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FBUBucketListItem : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) PFFile *picture;
@property (strong, nonatomic) PFUser *owner;

@end

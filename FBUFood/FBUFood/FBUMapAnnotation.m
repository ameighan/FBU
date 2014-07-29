//
//  FBUMapAnnotation.m
//  FBUFood
//
//  Created by Amber Meighan on 7/29/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUMapAnnotation.h"


@implementation FBUMapAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate = coordinate;
        self.title = title;
    }
    return self;
}

@end

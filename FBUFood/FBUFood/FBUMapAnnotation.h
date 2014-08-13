//
//  FBUMapAnnotation.h
//  FBUFood
//
//  Created by Amber Meighan on 7/29/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FBUMapAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *imageName;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

@end

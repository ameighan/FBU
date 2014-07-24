//
//  FBUEventViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventViewController.h"
#import "FBUEvent.h"

@interface FBUEventViewController ()
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation FBUEventViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self convertAddressToCoordinates:self.event.eventAddress];
}

-(void)convertAddressToCoordinates:(NSString *)address{
    
    if(!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    [self.geocoder geocodeAddressString:address
                      completionHandler:^(NSArray* placemarks, NSError* error){
                          if ([placemarks count] > 0) {
                              CLPlacemark *placemark = [placemarks objectAtIndex:0];
                              self.event.eventGeoPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
                          }
                      }];
    
}
- (IBAction)userDidJoinEvent:(id)sender
{
    [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
    [self.event saveInBackground];
}

@end

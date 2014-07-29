//
//  FBUMapViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUMapViewController.h"
#import <Parse/Parse.h>
#import "FBUEvent.h"



@implementation FBUMapViewController

@synthesize coordinate;


-(void)zoomToLocation
{
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 10000, 10000);
    [self.mapView setRegion:region animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self zoomToLocation];
    [self queryForEvents];
}

-(void)queryForEvents
{
    CLLocation *myLocation = self.mapView.userLocation.location;
    
    // User's location
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLocation:myLocation];
    // Create a query for places
    PFQuery *eventQuery = [FBUEvent query];
    // Interested in locations near user.
    [eventQuery whereKey:@"eventGeoPoint" nearGeoPoint:userGeoPoint];
    // Limit what could be a lot of points.
    eventQuery.limit = 10;
    // Final list of objects
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(FBUEvent *event in objects) {

                CLLocationCoordinate2D annotationCoord;
                annotationCoord.latitude = event.eventGeoPoint.latitude;
                annotationCoord.longitude = event.eventGeoPoint.longitude;
                
                MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
                annotationPoint.coordinate = annotationCoord;
                annotationPoint.title = event.eventName;
                annotationPoint.subtitle = event.eventTimeDate;
                [self.mapView addAnnotation:annotationPoint];
                
            }

        }
    }];
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;

}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *GeoQueryAnnotationIdentifier = @"PurplePin";
    
    if (annotation == mapView.userLocation) {
        return nil;
    } else {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoQueryAnnotationIdentifier];

        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoQueryAnnotationIdentifier];
            annotationView.pinColor = MKPinAnnotationColorPurple;
            annotationView.canShowCallout = YES;
            annotationView.draggable = YES;
            annotationView.animatesDrop = YES;
        }

        return annotationView;
    }
    
}





@end

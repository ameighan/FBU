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
#import "FBUMapAnnotation.h"

@interface FBUMapViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation FBUMapViewController


-(void)zoomToLocation
{
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 10000, 10000);
    [self.mapView setRegion:region animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self zoomToLocation];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn On Location Services to find your location"
                                                        message:nil delegate:nil
                                              cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [alert show];

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.locationManager startUpdatingLocation];
    [self.mapView removeAnnotations:self.annotations];
    [self queryForEvents];

}

-(void)queryForEvents
{
    
    CLLocation *myLocation = [self.locationManager location];
    
    // User's location
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLocation:myLocation];
    // Create a query for places
    PFQuery *eventQuery = [FBUEvent query];
    // Interested in locations near user.
    [eventQuery whereKey:@"eventGeoPoint" nearGeoPoint:userGeoPoint withinMiles:1000];
    // Limit what could be a lot of points.
    eventQuery.limit = 20;
    // Final list of objects
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(FBUEvent *event in objects) {
                if ([event.membersOfEvent containsObject:[PFUser currentUser]]) {
                    FBUMapAnnotation *annotationPoint = [[FBUMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(event.eventGeoPoint.latitude, event.eventGeoPoint.longitude) title:event.eventName];
                    annotationPoint.color = @"green";
                    [self.annotations addObject:annotationPoint];
                    [self.mapView addAnnotation:annotationPoint];
                } else {
                    FBUMapAnnotation *annotationPoint = [[FBUMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(event.eventGeoPoint.latitude, event.eventGeoPoint.longitude) title:event.eventName];
                    annotationPoint.color = @"purple";
                    [self.annotations addObject:annotationPoint];
                    
                    [self.mapView addAnnotation:annotationPoint];

                }
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
    static NSString *GeoQueryMyAnnotationIdentifier = @"GreenPin";
    static NSString *GeoQueryNearAnnotationIdentifier = @"PurplePin";
    
    if (annotation == mapView.userLocation) {
        // Doe snot give the user's locatino a pin
        return nil;
        
         // Makes sure the annotations are of the correct class
    } else if ([annotation isKindOfClass:[FBUMapAnnotation class]]) {
        
       // Casts an annotation as an instance of FBUMapAnnotation
        FBUMapAnnotation *annotations = (FBUMapAnnotation *)annotation;
        if ([annotations.color isEqualToString:@"green"]) {
            MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoQueryMyAnnotationIdentifier];
            if (!annotationView) {
                annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotations reuseIdentifier:GeoQueryMyAnnotationIdentifier];
                annotationView.pinColor = MKPinAnnotationColorGreen;
                annotationView.canShowCallout = YES;
                annotationView.draggable = YES;
                annotationView.animatesDrop = YES;
            }
            
            return annotationView;
            
        } else if ([annotations.color isEqualToString:@"purple"]) {
            MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoQueryNearAnnotationIdentifier];
            
            if (!annotationView) {
                annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotations reuseIdentifier:GeoQueryNearAnnotationIdentifier];
                annotationView.pinColor = MKPinAnnotationColorPurple;
                annotationView.canShowCallout = YES;
                annotationView.draggable = YES;
                annotationView.animatesDrop = YES;
            }
            
            return annotationView;
        }
    }

    return nil;
}

@end
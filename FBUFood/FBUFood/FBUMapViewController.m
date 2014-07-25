//
//  FBUMapViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUMapViewController.h"

@interface FBUMapViewController ()

@end

@implementation FBUMapViewController

-(void)zoomToLocation
{
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 5000, 5000);
    [_mapView setRegion:region animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.delegate = self;
    [self zoomToLocation];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
}

@end

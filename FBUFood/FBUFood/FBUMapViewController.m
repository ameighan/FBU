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
#import "FBUEventViewController.h"

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
    
    [[UIButton appearance] setTintColor:[UIColor colorWithRed:250.0/255.0 green:205.0/255.0 blue:115.0/255.0 alpha:1.00]];

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
    [eventQuery whereKey:@"membersOfEvent" equalTo:[PFUser currentUser]];
    // Limit what could be a lot of points.
    eventQuery.limit = 20;
    // Final list of objects
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(FBUEvent *event in objects) {
                    FBUMapAnnotation *annotationPoint = [[FBUMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(event.eventGeoPoint.latitude, event.eventGeoPoint.longitude) title:event.eventName];
                    annotationPoint.imageName = @"pin.png";
                    [self.annotations addObject:annotationPoint];
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
    static NSString *GeoQueryMyAnnotationIdentifier = @"Pin";
//    static NSString *GeoQueryNearAnnotationIdentifier = @"PurplePin";
    
    if (annotation == mapView.userLocation) {
        // Doe snot give the user's locatino a pin
        return nil;
        
         // Makes sure the annotations are of the correct class
    } else if ([annotation isKindOfClass:[FBUMapAnnotation class]]) {
        
       // Casts an annotation as an instance of FBUMapAnnotation
        FBUMapAnnotation *ann = (FBUMapAnnotation *)annotation;
        if ([ann.imageName isEqualToString:@"pin.png"]) {
            MKAnnotationView *forkAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoQueryMyAnnotationIdentifier];
        
            if (!forkAnnotationView) {
                MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:GeoQueryMyAnnotationIdentifier];
                annotationView.canShowCallout = YES;
                UIImage *fork = [UIImage imageNamed:ann.imageName];
                
                // size the flag down to the appropriate size
                CGRect resizeRect;
                resizeRect.size = fork.size;
                CGSize maxSize = CGRectInset(self.view.bounds,
                                             [FBUMapViewController annotationPadding],
                                             [FBUMapViewController annotationPadding]).size;
                maxSize.height -= self.navigationController.navigationBar.frame.size.height + [FBUMapViewController calloutHeight];
                if (resizeRect.size.width > maxSize.width)
                    resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
                if (resizeRect.size.height > maxSize.height)
                    resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [fork drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                annotationView.image = resizedImage;
                annotationView.opaque = NO;
                
                annotationView.draggable = YES;
                annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                
                 annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2 );
                  return annotationView;
            } else {
                forkAnnotationView.annotation = annotation;
            }
            
            return forkAnnotationView;
          
        }
    }

    return nil;
}

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    PFQuery *eventQuery = [FBUEvent query];
    // Interested in locations near user.
    [eventQuery whereKey:@"eventName" matchesRegex:view.annotation.title];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        FBUEventViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"event"];
        controller.event = [objects objectAtIndex:0];
        [self.navigationController pushViewController:controller animated:YES];

    }];
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

@end
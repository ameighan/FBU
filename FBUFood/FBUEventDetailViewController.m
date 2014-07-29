//
//  FBUEventDetailViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventDetailViewController.h"
#import "FBUEvent.h"
#import <CoreLocation/CoreLocation.h>
#import "FBUGroup.h"

@interface FBUEventDetailViewController ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation FBUEventDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.event) {
        self.eventAddressTextField.text = self.event.eventAddress;
        self.eventDescriptionTextView.text = self.event.eventDescription;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)saveEventData
{
    // Gathering geopoint info
    [self convertAddressToCoordinates:self.eventAddressTextField.text];
    
}

- (IBAction)datePickerTouched:(id)sender
{
    // Resave the date only if it has been touched
    [self saveTheDate];
}

-(void)saveTheDate
{
    if (self.event) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy 'at' h:mm a"];
        self.event.eventTimeDate = [dateFormatter stringFromDate:self.eventDatePicker.date];
        [self.event save];
    }
}

-(void)convertAddressToCoordinates:(NSString *)address
{
    if(!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    if (self.group.eventsInGroup == nil) {
        self.group.eventsInGroup = [[NSMutableArray alloc] init];
    }
    
    [self.geocoder geocodeAddressString:address
                      completionHandler:^(NSArray* placemarks, NSError* error){
<<<<<<< HEAD
                          for (CLPlacemark* aPlacemark in placemarks)
                          {
                              self.eventLocation = aPlacemark.location;
                          }

                          FBUEvent *newEvent = [FBUEvent object];
                          newEvent.eventName = self.eventNameTextField.text;
                          newEvent.eventDescription = self.eventDescriptionTextView.text;
                          newEvent.eventAddress = self.eventAddressTextField.text;

                          [self.group.eventsInGroup addObject:newEvent];

                          CLLocationCoordinate2D coordinate = [self.eventLocation coordinate];
                          PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                          newEvent.eventGeoPoint = geoPoint;
                          
                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                          [dateFormatter setDateFormat:@"MM-dd-yyyy 'at' h:mm a"];
                          newEvent.eventTimeDate = [dateFormatter stringFromDate:self.eventDatePicker.date];
                          
                          [newEvent saveInBackground];
                          [self.group saveInBackground];
                          NSLog(@"Events in group: %@", self.group.eventsInGroup);
=======
                          CLLocation *eventLocation = [((CLPlacemark *)[placemarks firstObject])location];
                          
                          if (self.event) {
                              //Resaves an event is it is being edited
                              self.event.eventName = self.eventNameTextField.text;
                              
                              self.event.creator = [PFUser currentUser];
                              
                              self.event.eventDescription =self.eventDescriptionTextView.text;
                              self.event.eventAddress = self.eventAddressTextField.text;
                              
                              PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:eventLocation];
                              self.event.eventGeoPoint = geoPoint;
                              
                              [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  NSLog(@"Resaving the event");
                              }];
                              
                          } else {
                          //Saves the data to Parse as a FBUGroup (subclass of PFObject)
                              FBUEvent *newEvent = [FBUEvent object];
                              newEvent.eventName = self.eventNameTextField.text;
                              newEvent.eventDescription = self.eventDescriptionTextView.text;
                              newEvent.eventAddress = self.eventAddressTextField.text;
                              newEvent.creator = [PFUser currentUser];
>>>>>>> master
                          
                              PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:eventLocation];
                              newEvent.eventGeoPoint = geoPoint;
                              
                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                              [dateFormatter setDateFormat:@"MM-dd-yyyy 'at' h:mm a"];
                              newEvent.eventTimeDate = [dateFormatter stringFromDate:self.eventDatePicker.date];
                              
                              [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  NSLog(@"Saving new event");
                              }];
                          }
                      }];
            
}


-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)backgroundPressed:(id)sender
{
    [self.view endEditing:YES];
}



@end

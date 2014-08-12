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
#import "AFHTTPRequestOperationManager.h"

@interface FBUEventDetailViewController ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation FBUEventDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.eventDatePicker addTarget:self
                   action:@selector(saveEventData)
         forControlEvents:UIControlEventValueChanged];
    if (self.event) {
        self.eventAddressTextField.text = self.event.eventAddress;
        self.eventDescriptionTextView.text = self.event.eventDescription;
        self.eventMealsTextField.text = self.event.eventMeals;
        self.eventNameTextField.text = self.event.eventName;
        
        NSString *dateStr = self.event.eventTimeDate;
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyy 'at' h:mm a"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        [self.eventDatePicker setDate:date animated:YES];
    }
    
    self.eventDatePicker.minimumDate = [NSDate date];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)dateChanged:(id)sender
{
    if(self.event) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy 'at' h:mm a"];
        self.event.eventTimeDate = [dateFormatter stringFromDate:self.eventDatePicker.date];
        [self.event saveInBackground];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"1MLHKB8J5A4HP8jUG0NbtlNxslsQmYUDsuIf5luJ" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"8GUVe3SYFhRbgGx0M4JH58iQWZtH8g4nOrzPfhb9" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSDictionary *whereDict = @{@"channels": [self.eventNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]};
        
        NSDictionary *dataDict = @{@"alert": [self.eventNameTextField.text stringByAppendingString:@" is today!"]};
        
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:00'Z'"];
        [dateFormatter stringFromDate:self.eventDatePicker.date];
        
        NSDictionary *dic2 = @{@"where": whereDict, @"push_time":[dateFormatter stringFromDate:self.eventDatePicker.date], @"data":dataDict};
        
        [manager POST:@"https://api.parse.com/1/push" parameters: dic2
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"POST data JSON returned: %@", responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }
         ];
        
    }
}


-(void)saveEventData
{
    // Gathering geopoint info and saving the event
    [self convertAddressToCoordinates:self.eventAddressTextField.text];

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
                          CLLocation *eventLocation = [((CLPlacemark *)[placemarks firstObject])location];
                          if (self.event) {
                              //Resaves an event if it is being edited
                              self.event.eventName = self.eventNameTextField.text;
                              
                              self.event.creator = [PFUser currentUser];
                              [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
                              
                              self.event.eventDescription = self.eventDescriptionTextView.text;
                              self.event.eventAddress = self.eventAddressTextField.text;
                              self.event.eventMeals = self.eventMealsTextField.text;
                              
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
                              newEvent.eventMeals = self.eventMealsTextField.text;
                              newEvent.creator = [PFUser currentUser];
                              [newEvent addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
                              
                              PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:eventLocation];
                              newEvent.eventGeoPoint = geoPoint;
                              
                              [self.group addObject:newEvent forKey:@"eventsInGroup"];
                              
                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                              [dateFormatter setDateFormat:@"MM-dd-yyyy 'at' h:mm a"];
                              newEvent.eventTimeDate = [dateFormatter stringFromDate:self.eventDatePicker.date];
                              
                              [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  NSLog(@"Saving new event");
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"savedEvent" object:self];
                        
                              }];
                              
                              [self.group saveInBackground];
                              
                              AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                              
                              manager.requestSerializer = [AFJSONRequestSerializer serializer];
                              
                              [manager.requestSerializer setValue:@"1MLHKB8J5A4HP8jUG0NbtlNxslsQmYUDsuIf5luJ" forHTTPHeaderField:@"X-Parse-Application-Id"];
                              [manager.requestSerializer setValue:@"8GUVe3SYFhRbgGx0M4JH58iQWZtH8g4nOrzPfhb9" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
                              [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                              manager.securityPolicy.allowInvalidCertificates = YES;
                              
                              NSDictionary *whereDict = @{@"channels": [self.eventNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]};
                              
                              NSDictionary *dataDict = @{@"alert": [self.eventNameTextField.text stringByAppendingString:@" is today!"]};
                              
                              [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                              [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:00'Z'"];
                              [dateFormatter stringFromDate:self.eventDatePicker.date];
                              
                              NSDictionary *dic2 = @{@"where": whereDict, @"push_time":[dateFormatter stringFromDate:self.eventDatePicker.date], @"data":dataDict};
                              
                              [manager POST:@"https://api.parse.com/1/push" parameters: dic2
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSLog(@"POST data JSON returned: %@", responseObject);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error: %@", error);
                                    }
                               ];
                          }
                          
                          
                      }];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


- (IBAction)backgroundPressed:(id)sender
{
    [self.view endEditing:YES];
}






@end

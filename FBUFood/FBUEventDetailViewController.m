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
@property (nonatomic) BOOL dateChanged;

@end

@implementation FBUEventDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dateChanged = NO;
    
    if (self.event) {
        self.eventAddressTextView.text = self.event.eventAddress;
        self.eventDescriptionTextView.text = self.event.eventDescription;
        self.eventMealsTextField.text = self.event.eventMeals;
        self.eventNameTextField.text = self.event.eventName;
        
        [self.eventDatePicker setDate:self.event.eventTimeDate animated:YES];
       
    }
    
    self.eventDatePicker.minimumDate = [NSDate date];
    
    self.eventDescriptionTextView.text = @"#noodle #beef #nom";
    self.eventDescriptionTextView.textColor = [UIColor lightGrayColor];
    
    self.eventAddressTextView.text = @"enter the address of this event";
    self.eventAddressTextView.textColor = [UIColor lightGrayColor];
    
    [self.eventNameTextField becomeFirstResponder];
    self.eventAddressTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.eventAddressTextView.layer.borderWidth = 0.5;
    self.eventAddressTextView.layer.cornerRadius = 8;
    
    self.eventDescriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.eventDescriptionTextView.layer.borderWidth = 0.5;
    self.eventDescriptionTextView.layer.cornerRadius = 8;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"#noodle #beef #nom"] | [textView.text isEqualToString:@"enter the address of this event"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        if(textView == self.eventDescriptionTextView){
            textView.text = @"#noodle #beef #nom";
            textView.textColor = [UIColor lightGrayColor]; //optional
        } else {
        textView.text = @"enter the address of this event";
        textView.textColor = [UIColor lightGrayColor]; //optional
        }
    }
    [textView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)dateChanged:(id)sender
{
    self.dateChanged = YES;
}


-(void)saveEventData
{
    // Gathering geopoint info and saving the event
    [self convertAddressToCoordinates:self.eventAddressTextView.text];

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
                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                          [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

                          if (self.event) {
                              //Resaves an event if it is being edited
                              self.event.eventName = self.eventNameTextField.text;
                              
                              self.event.creator = [PFUser currentUser];
                              
                              self.event.eventDescription = self.eventDescriptionTextView.text;
                              self.event.eventAddress = self.eventAddressTextView.text;
                              self.event.eventMeals = self.eventMealsTextField.text;
                              
                              PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:eventLocation];
                              self.event.eventGeoPoint = geoPoint;
                              
                             
                              
                              if(self.dateChanged) {
                                  self.event.eventTimeDate = self.eventDatePicker.date;
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
                                  [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                      NSLog(@"Resaving the event");
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"savedEvent" object:self];
                                  }];
                                  
                              
                              
                          } else {
                              //Saves the data to Parse as a FBUGroup (subclass of PFObject)
                              FBUEvent *newEvent = [FBUEvent object];
                              newEvent.eventName = self.eventNameTextField.text;
                              newEvent.eventDescription = self.eventDescriptionTextView.text;
                              newEvent.eventAddress = self.eventAddressTextView.text;
                              newEvent.eventMeals = self.eventMealsTextField.text;
                              newEvent.creator = [PFUser currentUser];
                              [newEvent addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
                              
                              PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:eventLocation];
                              newEvent.eventGeoPoint = geoPoint;
                              
                              [self.group addObject:newEvent forKey:@"eventsInGroup"];
                              
                              NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventTimeDate" ascending:YES];
                              self.group.eventsInGroup = [self.group.eventsInGroup sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                              
                              newEvent.eventTimeDate = self.eventDatePicker.date;
                              
                              [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  NSLog(@"Saving new event");
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"savedEvent" object:self];
                                  
                              }];
                              
                              
                              [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  NSLog(@"Hi");
                              }];
                              
                              PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                              [currentInstallation addUniqueObject:[self.eventNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"channels"];
                              [currentInstallation saveInBackground];
                              
                              
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

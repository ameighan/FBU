//
//  FBUEventDetailViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <CoreLocation/CoreLocation.h>

@class  FBUGroup;
@class FBUEvent;

@interface FBUEventDetailViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) FBUGroup *group;

@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventAddressTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *eventMealsTextField;

@property (strong, nonatomic) FBUEvent *event;

-(void)saveEventData;

@end

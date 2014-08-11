//
//  FBUGroupsDetailViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/16/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBUGroupsDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameOfGroupTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfGroupTextView;
@property (weak, nonatomic) IBOutlet UIButton *addRecipesToGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *addCooksToGroupButton;

-(void)saveGroup;

@end

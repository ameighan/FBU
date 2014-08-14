//
//  FBUAppDelegate.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUAppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBUGroup.h"
#import "FBUBucketListItem.h"
#import "FBUEvent.h"
#import "FBURecipe.h"
#import "FBUGroceryList.h"

@implementation FBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBUGroup registerSubclass];
    [FBUEvent registerSubclass];
    [FBURecipe registerSubclass];
    [FBUGroceryList registerSubclass];
    [FBUBucketListItem registerSubclass];
    
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    [Parse setApplicationId:@"1MLHKB8J5A4HP8jUG0NbtlNxslsQmYUDsuIf5luJ"
                  clientKey:@"t51Gjc5rnNTNlX4npEHowiYolcGc6h755Xjbbsil"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    [self createUI];
    return YES;
}

- (void)createUI
{
    self.window.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:215.0/255.0 blue:213.0/255.0 alpha:1.0];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:15.0]
       }
     forState:UIControlStateNormal];
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Avenir" size:15.0]];
    [[[UIButton appearance] titleLabel] setFont:[UIFont fontWithName:@"Avenir" size:15.0]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:249.0/255.0 green:118.0/255.0 blue:87.0/255.0 alpha:0.75]];    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];

    //Setting selected and unselected items
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    [tabBar setTintColor:[UIColor whiteColor]];
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    tabBarItem1.image = [[UIImage imageNamed:@"dashboardUnselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [UIImage imageNamed:@"dashboardSelected.png"];
    
    tabBarItem2.image = [[UIImage imageNamed:@"exploreUnselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"exploreSelected.png"];
    
    tabBarItem3.image = [[UIImage imageNamed:@"profileUnselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"profileSelected.png"];
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:249.0/255.0 green:118.0/255.0 blue:87.0/255.0 alpha:0.75]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Avenir" size:17.0], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

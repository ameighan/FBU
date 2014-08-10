//
//  FBURecipesYummylyViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 8/9/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBURecipesYummylyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;
@property (nonatomic, strong) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *yummlyRecipes;

@end

//
//  FBUExploreViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUCollectionViewLayout.h"
#import "FBUCollectionCellBackgroundView.h"

@interface FBUExploreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateJSPintLayout, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *groupsCollection;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *exploratoryGroups;
@property (strong, nonatomic) NSArray *displayedGroups;
@property (strong, nonatomic) NSMutableArray *specificGroups;


@end

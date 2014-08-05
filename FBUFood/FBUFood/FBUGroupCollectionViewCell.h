//
//  FBUGroupCollectionViewCell.h
//  FBUFood
//
//  Created by Uma Girkar on 8/5/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBUGroup;

@interface FBUGroupCollectionViewCell : UICollectionViewCell

//@property (strong, nonatomic) FBUGroup *group;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;


@end

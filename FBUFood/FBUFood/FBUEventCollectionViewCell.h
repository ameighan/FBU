//
//  FBUEventCollectionViewCell.h
//  FBUFood
//
//  Created by Jennifer Zhang on 8/5/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBUEventCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;

@end

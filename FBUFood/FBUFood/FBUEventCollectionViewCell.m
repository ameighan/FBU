//
//  FBUEventCollectionViewCell.m
//  FBUFood
//
//  Created by Jennifer Zhang on 8/5/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventCollectionViewCell.h"

@implementation FBUEventCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [_calendarImage setTintColor:[UIColor whiteColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

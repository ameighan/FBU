//
//  FBUCollectionCellBackgroundView.m
//  FBUFood
//
//  Created by Amber Meighan on 8/5/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUCollectionCellBackgroundView.h"

@implementation FBUCollectionCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor* color235Gray = [UIColor colorWithRed:249.0/255.0
                                            green:231.0/255.0
                                             blue:230.0/255.0
                                            alpha:0.5];
    CGColorRef cgColor235Gray = color235Gray.CGColor;
    
    //Get the CGContext from this view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0];
    [bezierPath addClip];
    [[UIColor colorWithRed:249.0/255.0
                     green:231.0/255.0
                      blue:230.0/255.0
                     alpha:0.5] setFill];
    [bezierPath fill];
    bezierPath.lineWidth = 3.0;
    CGContextSetStrokeColorWithColor(context, cgColor235Gray);
    [bezierPath stroke];
    
}


@end

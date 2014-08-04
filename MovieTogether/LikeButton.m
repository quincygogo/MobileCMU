//
//  LikeButton.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/4/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "LikeButton.h"

@implementation LikeButton
@synthesize time;
@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"likeBtn"];
        [self setBackgroundImage:img forState:UIControlStateNormal];
    }
    return self;
}

- (void) setLabel
{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self setTitle:time forState:UIControlStateNormal];
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

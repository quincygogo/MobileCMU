//
//  LikedTableCell.m
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/28/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "LikedTableCell.h"

@implementation LikedTableCell
@synthesize movieName = _movieName;
@synthesize dateLabel = _dateLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
//
//  LikedTableCell.h
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/28/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikedTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *moviename;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *theater;

@end

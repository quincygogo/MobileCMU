//
//  SentTableCell.h
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SentTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *toUserName;
@property (strong, nonatomic) IBOutlet UIImageView *toUserImg;
@property (strong, nonatomic) IBOutlet UILabel *moviename;
@property (strong, nonatomic) IBOutlet UILabel *theater;

@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *status;

@end

//
//  ReceivedTableCell.h
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *fromUserImg;
@property (strong, nonatomic) IBOutlet UILabel *fromUserName;
@property (strong, nonatomic) IBOutlet UILabel *moviename;
@property (strong, nonatomic) IBOutlet UILabel *location;
- (IBAction)decline:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *time;
- (IBAction)accept:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;
@property (strong, nonatomic) IBOutlet UILabel *status;
@end

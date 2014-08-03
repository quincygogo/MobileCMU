//
//  ReceivedTableCell.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "ReceivedTableCell.h"
#import <Parse/Parse.h>

@implementation ReceivedTableCell

@synthesize messageId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)accept:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:messageId block:^(PFObject *message, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        message[@"status"] = @"Accepted";
        [message saveInBackground];
        
    }];
}

- (IBAction)decline:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:messageId block:^(PFObject *message, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        message[@"status"] = @"Declined";
        [message saveInBackground];
    }];
}

@end

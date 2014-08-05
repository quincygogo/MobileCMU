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
@synthesize fromUserName;
@synthesize acceptButton;
@synthesize declineButton;
@synthesize status;

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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:[@"You have just accpeted the invitation from " stringByAppendingString:fromUserName.text]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    status.hidden = NO;
    status.text = @"Accepted";
    [status setTextColor:[UIColor colorWithRed: 88.0/255.0 green: 191.0/255.0 blue:98/255.0 alpha: 0.8]];
    acceptButton.hidden = YES;
    declineButton.hidden = YES;
    
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:[@"You have just declined the invitation from " stringByAppendingString:fromUserName.text]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    status.hidden = NO;
    status.text = @"Declined";
    [status setTextColor:[UIColor colorWithRed: 246.0/255.0 green: 37.0/255.0 blue:86.0/255.0 alpha: 0.8]];
    acceptButton.hidden = YES;
    declineButton.hidden = YES;
    
}

@end

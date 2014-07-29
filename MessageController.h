//
//  MessageController.h
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/29/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SentMessageTable.h"
#import "ReceivedMessageTable.h"

@interface MessageController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *sentMessageView;
@property (strong, nonatomic) IBOutlet UIView *receivedMessageView;
@property (strong, nonatomic) IBOutlet UITableView *sentMessage;
@property (strong, nonatomic) IBOutlet UITableView *receivedMessage;

@property (strong, nonatomic) SentMessageTable *sentDelegate;
@property (strong, nonatomic) ReceivedMessageTable *receivedDelegate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *controller;
- (IBAction)selectSegment:(UISegmentedControl *)sender;

@end

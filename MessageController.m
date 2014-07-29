//
//  MessageController.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/29/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "MessageController.h"
#import "SentMessageTable.h"
#import "ReceivedMessageTable.h"
@interface MessageController ()

@end

@implementation MessageController
@synthesize sentMessage;
@synthesize sentMessageView;
@synthesize receivedMessageView;
@synthesize controller;
@synthesize sentDelegate;
@synthesize receivedDelegate;
@synthesize receivedMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sentDelegate = [[SentMessageTable alloc] init];
    [self.sentMessage setDelegate:sentDelegate];
    [self.sentMessage setDataSource:sentDelegate];
    
    self.receivedDelegate = [[ReceivedMessageTable alloc] init];
    [self.receivedMessage setDelegate:receivedDelegate];
    [self.receivedMessage setDataSource:receivedDelegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectSegment:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.sentMessageView.hidden = NO;
            self.receivedMessageView.hidden = YES;
            break;
         
        case 1:
            self.sentMessageView.hidden = YES;
            self.receivedMessageView.hidden = NO;
            break;
            
        default:
            break;
    }
}
@end

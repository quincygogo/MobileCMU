//
//  UserDetailController.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "UserDetailController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface UserDetailController ()

@end

@implementation UserDetailController
{
    AppDelegate *global;
}

@synthesize userName;
@synthesize gender;
@synthesize userImg;
@synthesize theater;
@synthesize date;
@synthesize movieName;

@synthesize userNameContent;
@synthesize genderContent;
@synthesize userImgContent;
@synthesize theaterContent;
@synthesize dateContent;
@synthesize movieNameContent;

@synthesize spinner;
@synthesize likelist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        global = [[UIApplication sharedApplication] delegate];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    global = [[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view.
//    userName.text = user.name;
    userName.text = userNameContent;
    gender.text = genderContent;
    theater.text = theaterContent;
    date.text = dateContent;
    movieName.text = movieNameContent;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImgContent]];
    userImg.image = [UIImage imageWithData:data];
    likelist.hidden = YES;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    [self getLikeList];
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

- (void) getLikeList
{
    PFQuery *query = [PFQuery queryWithClassName:@"LikedList"];
    [query whereKey:@"username" equalTo:userNameContent];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            UITextView * text = [[UITextView alloc] initWithFrame:CGRectMake(0,0,likelist.frame.size.width,likelist.frame.size.height)];
            [text setEditable:NO];
            text.font = [UIFont systemFontOfSize:17.0f];
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                text.text = [text.text stringByAppendingString:[object objectForKey:@"moviename"]];
                text.text = [text.text stringByAppendingString:@"\n"];
            }
            [likelist addSubview:text];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [spinner stopAnimating];
        likelist.hidden = NO;
    }];
}

- (IBAction)invite:(id)sender {
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    NSString *name = global.userName;
    if (name == nil)
    {
        userName = @"Quincy Yip";
    }
    
    message[@"fromuser"] = name;
    message[@"moviename"] = movieNameContent;
    message[@"status"] = @"Pending";
    message[@"time"] = dateContent;
//    message[@"theater"] = 
    [message saveInBackground];
}
@end

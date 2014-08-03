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
    [self checkLogin];
    
}

- (void) sendInvitation
{
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    NSString *name = global.userName;
    // if (name == nil)
    //{
    //  name = @"Quincy Yip";
    //}
    
    message[@"fromuser"] = name;
    message[@"moviename"] = movieNameContent;
    message[@"status"] = @"Pending";
    message[@"time"] = dateContent;
    message[@"theater"] = theaterContent;
    message[@"touser"] = userNameContent;
    [message saveInBackground];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                    message:@"Your invitation has been sent!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) checkLogin
{
    if (([PFUser currentUser] && // Check if a user is cached
         [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])) // Check if user is linked to Facebook
    {
        NSLog(@"user exists");
        if (global.userName == NULL)
        {
            [self getUserInfor];
            NSLog(@"Setting global user");
        }
        else
        {
            [self sendInvitation];
        }
    }
    // Login PFUser using Facebook
    else {
        [self loginFacebook];
    }
}

- (void) getUserInfor
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *gender = userData[@"gender"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            PFUser *user = [PFUser currentUser];
            if (![[user objectForKey:@"set"] boolValue])
            {
                user[@"set"] = @YES;
                user[@"name"] = name;
                user[@"gender"] = gender;
                user[@"pic"] = [pictureURL absoluteString];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error)
                    {
                        NSLog(@"Saved!");
                    }
                    else
                    {
                        NSLog(error);
                    }
                }];
            }
            NSLog(@"Done setting global user");
            global.userName = name;
            global.gender = gender;
            global.picture = [pictureURL absoluteString];
            [self sendInvitation];
        }
        else
        {
            NSLog(error);
        }
    }];
}

- (void) loginFacebook
{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else {
            [self getUserInfor];
        }
    }];
}
@end

//
//  TheatreDetail.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/31/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "TheatreDetail.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface TheatreDetail ()

@end

@implementation TheatreDetail {
    AppDelegate *global;
}

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
    global = [[UIApplication sharedApplication] delegate];
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

- (IBAction)like:(id)sender {
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        
//        [controller setInitialText:@"First post from my iPhone app"];
//        [self presentViewController:controller animated:YES completion:Nil];
//    }
//    else
//    {
////        [self showMessage:@"You're now logged out" withTitle:@""];   
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook account set up"
//                                                        message:@"You must set up your Facebook account to use this feature."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
////        [alert ];
//    }
   
    
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
            [self addLike];
        }
    }
    // Login PFUser using Facebook
    else {
        [self loginFacebook];
    }
}


- (void) addLike
{
    NSLog(@"%@, %@", global.userName, @"like");
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

//            NSString *location = userData[@"location"][@"name"];
//            NSString *birthday = userData[@"birthday"];
//            NSString *relationship = userData[@"relationship_status"];
//            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            PFUser *user = [PFUser currentUser];
            if (![user objectForKey:@"pic"])
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
            //here
            NSLog([@"hehe" stringByAppendingString:global.userName]);
            [self addLike];
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

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
#import <math.h>
#import "AppDelegate.h"

@interface TheatreDetail ()

@end

@implementation TheatreDetail {
    AppDelegate *global;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *address;
    MKUserLocation *curLoc;
    double latitude;
    double longtitude;
}

@synthesize mapView;

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
    
    self.mapView.delegate = self;
    
    geocoder = [[CLGeocoder alloc] init];
    [self getCurrentLoc];
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:NULL];
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



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLoc {
    curLoc = userLoc;
    
    // reverse geocoding
    NSLog(@"resolving the address");
    [geocoder reverseGeocodeLocation:curLoc.location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            address = [NSString stringWithFormat:@"%@ %@",
                       placemark.subThoroughfare, placemark.thoroughfare];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}


- (void)getCurrentLoc {
    // AMC address
    latitude= 40.401;
    longtitude = -79.918;
    
    MKCoordinateRegion region;
    region.center.latitude = (self.mapView.userLocation.coordinate.latitude + latitude)/2;
    region.center.longitude = (self.mapView.userLocation.coordinate.longitude + longtitude)/2;
    region.span.latitudeDelta = ([[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:latitude longitude:longtitude]])* 1.3 / 111319.5;
    region.span.longitudeDelta = 0.0;
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    // add annotation
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    NSLog(@"log get cur loc");

    [self.mapView addAnnotation:pin];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([self.mapView showsUserLocation]) {
        [self getCurrentLoc];
        // and of course you can use here old and new location values
    }
}


@end

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
#import "Theater.h"
#import "AppDelegate.h"
#import "Showtime.h"
#import "LikeButton.h"

@interface TheatreDetail ()

@end

@implementation TheatreDetail {
    AppDelegate *global;
    double latitude;
    double longtitude;
    
    //mine
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *address;
    MKUserLocation *currentLocation;
    Theater *theaterInfo;
    
    NSMutableArray *twoD;
    NSMutableArray *threeD;
    
    NSString *timeVal;
}

@synthesize mapView;
@synthesize theater;
@synthesize time;
@synthesize date;
@synthesize theaterAddress;
@synthesize phone;
@synthesize type;
@synthesize movieName;
@synthesize theaterName;
@synthesize showTimeList;
@synthesize timeDetail;

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
    
    theaterInfo = [[Theater alloc] init];
    [self view].hidden = YES;
    [self getTheater];
    
    twoD = [[NSMutableArray alloc] init];
    threeD = [[NSMutableArray alloc] init];
    for (NSObject *object in showTimeList)
    {
        Showtime *showtime = (Showtime *) object;
        if ([showtime.type isEqualToString: @"2D"])
        {
            [twoD addObject:showtime];
        }
        else if ([showtime.type isEqualToString:@"3D"])
        {
            [threeD addObject:showtime];
        }
    }
    
    NSInteger width = 60;
    NSInteger height = 20;
    [timeDetail setScrollEnabled:YES];
    int numberPerLine = 4;
    timeDetail.contentSize = CGSizeMake(271, 500);
    CGRect labelFrame = CGRectMake(0.0f, 0.0f, 60.0f, 20.0f);
    UILabel *threeDLabel = [[UILabel alloc] initWithFrame:labelFrame];
    threeDLabel.text = @"3D";
    [timeDetail addSubview:threeDLabel];
    int count = 1;
    CGRect frame = CGRectMake(0.0f, 25.0f, 60.0f, 20.0f);
    for (int i = 0; i < [threeD count]; i++)
    {
        Showtime *showtime = (Showtime *)[threeD objectAtIndex:i];
        LikeButton *btn = [[LikeButton alloc] initWithFrame:frame];
        btn.time = showtime.time;
        btn.date = date;
        [btn setLabel];
        [btn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [timeDetail addSubview:btn];
        frame = CGRectMake(frame.origin.x + width + 10.0f , frame.origin.y, 60.0f, 20.0f);
        if (count == numberPerLine)
        {
            frame = CGRectMake(0 , frame.origin.y + height + 10.0f, 60.0f, 20.0f);
            count = 0;
        }
        count++;
    }
    
    labelFrame = CGRectMake(0, frame.origin.y + height + 10.0f, 60.0f, 20.0f);
    UILabel *twoDLabel = [[UILabel alloc] initWithFrame:labelFrame];
    twoDLabel.text = @"2D";
    [timeDetail addSubview:twoDLabel];
    
    frame = CGRectMake(0.0f, labelFrame.origin.y + 25.0f, 60.0f, 20.0f);
    count = 1;
    for (int i = 0; i < [twoD count]; i++)
    {
        Showtime *showtime = (Showtime *)[twoD objectAtIndex:i];
        LikeButton *btn = [[LikeButton alloc] initWithFrame:frame];
        btn.time = showtime.time;
        btn.date = date;
        [btn setLabel];
        [btn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [timeDetail addSubview:btn];
        frame = CGRectMake(frame.origin.x + width + 10.0f , frame.origin.y, 60.0f, 20.0f);
        if (count == numberPerLine)
        {
            frame = CGRectMake(0 , frame.origin.y + height + 10.0f, 60.0f, 20.0f);
            count = 0;
        }
        count++;
    }

    
    mapView.delegate = self;
    
    geocoder = [[CLGeocoder alloc] init];
    address = @"";
    
//    [self getCurrentLoc];
//    [self.mapView.userLocation addObserver:self
//                                forKeyPath:@"location"
//                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
//                                    context:NULL];
    movieName = global.movieName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) like:(id)sender {
    LikeButton *btn = (LikeButton *)sender;
    timeVal = btn.time;
    //do as you please with buttonClicked.argOne
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
    PFObject *like = [PFObject objectWithClassName:@"LikedList"];
    like[@"moviename"] = movieName;
    NSString *dateTime = [date stringByAppendingString:@" "];
    dateTime = [dateTime stringByAppendingString:timeVal];
    like[@"showtime"] = dateTime;
    like[@"theater"] = theater.text;
    like[@"username"] = global.userName;
    like[@"gender"] = global.gender;
    [like saveInBackground];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                    message:@"You have added the movie to your wish list!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
            [self addLike];
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentLocation = userLocation;
    __block CLLocationDegrees lat;
    __block CLLocationDegrees lon;
    __block CLLocationCoordinate2D coordinate;
    [geocoder geocodeAddressString:theaterInfo.address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *pin = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         lat = topResult.location.coordinate.latitude;
                         lon = topResult.location.coordinate.longitude;
                         MKCoordinateSpan locationSpan;
                         CLLocationDegrees uppderLat, lowerLat, uppderLon, lowerLon;
                         if (lat > currentLocation.coordinate.latitude)
                         {
                             uppderLat = lat;
                             lowerLat = currentLocation.coordinate.latitude;
                         } else {
                             uppderLat = currentLocation.coordinate.latitude;
                             lowerLat = lat;
                         }
                         
                         if (lon > currentLocation.coordinate.longitude)
                         {
                             uppderLon = lon;
                             lowerLon = currentLocation.coordinate.longitude;
                         } else {
                             uppderLon = currentLocation.coordinate.longitude;
                             lowerLon = lon;
                         }
                         
                         
                         coordinate.latitude = (uppderLat + uppderLat) / 2;
                         coordinate.longitude = (uppderLon + lowerLon) / 2;
    
                         locationSpan.latitudeDelta = (uppderLat - lowerLat) * 2.5;
                         locationSpan.longitudeDelta = (uppderLon - lowerLon) * 2.5;
                         
                         MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, locationSpan);
                         [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
                         
                         
                         [self.mapView addAnnotation:pin];
                     }
                 }
     ];
}

- (void) getTheater
{
    PFQuery *query = [PFQuery queryWithClassName:@"Theater"];
    [query whereKey:@"name" equalTo:theaterName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects)
        {
            theaterInfo.name = [object objectForKey:@"name"];
            theaterInfo.phone = [object objectForKey:@"tel"];
            theaterInfo.address = [object objectForKey:@"address"];
        }
        
        phone.text = theaterInfo.phone;
        theater.text = theaterInfo.name;
        theaterAddress.text = theaterInfo.address;
        
        self.view.hidden = NO;
    }];
}

@end

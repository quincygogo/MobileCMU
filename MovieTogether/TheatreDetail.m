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
    
    
    mapView.delegate = self;
    
    NSLog(@"%d", [showTimeList count]);
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


- (IBAction)like:(id)sender {
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
    like[@"showtime"] = time.text;
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
    [self locate];
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentLocation = userLocation;
/*
    // Add an annotation
    [geocoder reverseGeocodeLocation:currentLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            address = [NSString stringWithFormat:@"%@ %@",
                       placemark.thoroughfare, placemark.subThoroughfare];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
 */
    
    [geocoder geocodeAddressString:theaterInfo.address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *pin = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
//                         region.center = pin.region.center;
//                         region.span.longitudeDelta /= 6.0;
//                         region.span.latitudeDelta /= 6.0;

                         MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(pin.coordinate, 2000, 2000);
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:pin];
                     }
                 }
     ];
    
    [self locate];
    
    CLLocationCoordinate2D coordinates = [self getLocationFromAddressString:address];
}


-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
    
}


- (void) locate
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = currentLocation.coordinate;
    point.title = address;
    
    [self.mapView addAnnotation:point];
    
    
//    MKMapRect zoomRect = MKMapRectNull;
//    for (id <MKAnnotation> annotation in mapView.annotations)
//    {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//        zoomRect = MKMapRectUnion(zoomRect, pointRect);
//    }
//    double inset = -zoomRect.size.width * 0.1;
//    [mapView setVisibleMapRect:MKMapRectInset(zoomRect, inset, inset) animated:YES];
}

//
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLoc {
//    curLoc = userLoc;
//    
//    // reverse geocoding
//    NSLog(@"resolving the address");
//    [geocoder reverseGeocodeLocation:curLoc.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"found placemarks: %@, error: %@", placemarks, error);
//        if (error == nil && [placemarks count] > 0) {
//            placemark = [placemarks lastObject];
//            address = [NSString stringWithFormat:@"%@ %@",
//                       placemark.subThoroughfare, placemark.thoroughfare];
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    }];
//}

//
//- (void)getCurrentLoc {
//    // AMC address
//    latitude= 40.401;
//    longtitude = -79.918;
//    
//    MKCoordinateRegion region;
//    region.center.latitude = (self.mapView.userLocation.coordinate.latitude + latitude)/2;
//    region.center.longitude = (self.mapView.userLocation.coordinate.longitude + longtitude)/2;
//    region.span.latitudeDelta = ([[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:latitude longitude:longtitude]])* 1.3 / 111319.5;
//    region.span.longitudeDelta = 0.0;
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    // add annotation
//    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
//    pin.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
//    NSLog(@"log get cur loc");
//
//    [self.mapView addAnnotation:pin];
//    
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([self.mapView showsUserLocation]) {
//        [self getCurrentLoc];
//        // and of course you can use here old and new location values
//    }
//}

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

//
//  TheatreDetail.h
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/31/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TheatreDetail : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *theater;

@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UITextView *theaterAddress;
@property (strong, nonatomic) IBOutlet UISegmentedControl *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSString *theaterName;
- (IBAction)like:(id)sender;
@end

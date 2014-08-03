//
//  UserDetailController.h
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Liked.h"

@interface UserDetailController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *gender;
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *movieName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *theater;

@property (strong, nonatomic) NSString *userNameContent;
@property (strong, nonatomic) NSString *genderContent;
@property (strong, nonatomic) NSString *userImgContent;
@property (strong, nonatomic) NSString *movieNameContent;
@property (strong, nonatomic) NSString *dateContent;
@property (strong, nonatomic) NSString *theaterContent;
@property (strong, nonatomic) IBOutlet UIScrollView *likelist;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)invite:(id)sender;

@end

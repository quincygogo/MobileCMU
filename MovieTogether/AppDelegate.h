//
//  AppDelegate.h
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *picHeader;
@property (strong, nonatomic) NSMutableDictionary *userList;
@property (strong, nonatomic) NSMutableArray *likeList;
@property (strong, nonatomic) NSMutableDictionary *movieList;
@property (strong, nonatomic) NSMutableDictionary *theaterList;


@end

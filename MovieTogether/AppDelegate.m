//
//  AppDelegate.m
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Liked.h"

@implementation AppDelegate

@synthesize userName;
@synthesize gender;
@synthesize picture;
@synthesize picHeader;
@synthesize userList;
@synthesize likeList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    picHeader = @"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1";
    [Parse setApplicationId:@"7bOL0GhPNKROKCpeP0PFSkPcNn8fxFXzYOWd8Ucz"
                  clientKey:@"jyQTuEisaIh7nQp6gW8FFGL4hvZOc6WWuE26vk0V"];
    [FBSettings setDefaultAppID: @"1439364956345872"];
    [PFFacebookUtils initializeFacebook];
    [self getInfo];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void) getInfo
{
    userList = [[NSMutableDictionary alloc] init];
    likeList = [[NSMutableArray alloc] init];
    
    PFQuery *query1 = [PFUser query];
    [query1 whereKey:@"set" equalTo:@YES];
    NSArray* objects = [query1 findObjects];
    for (PFObject *object in objects) {
        
        User *user = [[User alloc] init];
        user.name =[object objectForKey:@"name"];
        user.gender =[object objectForKey:@"gender"];
        user.pic =[object objectForKey:@"pic"];
        [userList setObject:user forKey:user.name];
    }
    PFQuery *query2 = [PFQuery queryWithClassName:@"LikedList"];
    [query2 selectKeys:@[@"moviename", @"showtime", @"theater", @"username"]];
    objects = [query2 findObjects];
    for (PFObject *object in objects) {
        Liked *like = [[Liked alloc] init];
        like.movieName =[object objectForKey:@"moviename"];
        like.showTime =[object objectForKey:@"showtime"];
        like.theater = [object objectForKey:@"theater"];
        like.userName = [object objectForKey:@"username"];
        [likeList addObject:like];
    }
    
//    for (NSObject *object in [userList objectEnumerator])
//    {
//        User *user = (User *)object;
//        NSLog(@"%@" "%@", user.name, user.pic);
//    }
}
@end

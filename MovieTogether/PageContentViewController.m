//
//  PageContentViewController.m
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "PageContentViewController.h"
#import "FirstViewController.h"
#import "UserTableViewCell.h"
#import "MovieDetailViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "User.h"
#import "Liked.h"
#import "UserDetailController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController {
    NSMutableArray *movies;
    NSMutableArray *imgList;
    NSMutableArray *userList;
    NSMutableArray *genderList;
    NSMutableArray *dateList;
    NSMutableArray *theatreList;
    AppDelegate *global;
}

@synthesize userTableView;
@synthesize movieLabel;
@synthesize btnImg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (global.userName == nil)
    {
        [self checkLogin];
    }
    // Do any additional setup after loading the view.
    global = [[UIApplication sharedApplication] delegate];
    userList = [[NSMutableArray alloc]init];
    movies = [[NSMutableArray alloc] init];
    
    userTableView.hidden = YES;
    [self updateLikeList];

        movieLabel.text = self.movieName;
    global.movieName = movieLabel.text;
  

    [btnImg setBackgroundImage:[UIImage imageNamed:self.imgFile] forState:UIControlStateNormal];
    
    
       NSEnumerator * value = [global.userList objectEnumerator];
    for (NSObject *object in value) {
        [userList addObject:object];
   //     NSLog(object);
    }
    
    // Assign our own backgroud for the view
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    userTableView.backgroundColor = [UIColor clearColor];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// inform how many rows - need to implement if has UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [movies count];
}

// called every time when a table row is displayed - need to implement if has UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"UserTableViewCell";
    UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Liked *like = (Liked *)[movies objectAtIndex:indexPath.row];
    User *user = (User *)[global.userList objectForKey:like.userName];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://scontent-b.xx.fbcdn.net/hphotos-xpa1/t1.0-9/1425657_1441170366110528_269769878_n.jpg"]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.pic]];
    cell.userImg.image = [UIImage imageWithData:data];
    cell.userName.text = user.name;
    cell.gender.text = user.gender;
    cell.dateLabel.text = like.showTime;
    cell.theatre.text = like.theater;
    
    // to corner angle
    cell.userImg.layer.masksToBounds = YES;
    cell.userImg.layer.cornerRadius = 5.0;
    cell.userImg.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.userImg.layer.shouldRasterize = YES;
    cell.userImg.clipsToBounds = YES;
    
    
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self userTableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMovieDetail"]) {
//        NSIndexPath *indexPath = [self.userTableView indexPathForSelectedRow];
//        MovieDetailViewController *movieDetailVC = segue.destinationViewController;
        //       movieDetailVC.movieName = [movies]
    }

   else if ([segue.identifier isEqualToString:@"likeDetail"])
    {
        NSIndexPath *indexPath = [self.userTableView indexPathForSelectedRow];
        UserTableViewCell *cell =(UserTableViewCell *)[self.userTableView cellForRowAtIndexPath:indexPath];
//        NSLog([@"abc" stringByAppendingString:liked.movieName]);
        
        UserDetailController *view = segue.destinationViewController;
        User *user = (User *)[global.userList objectForKey:cell.userName.text];
        Liked *like = (Liked *)[movies objectAtIndex:indexPath.row];
        
        view.userNameContent = user.name;
        view.genderContent = user.gender;
        view.userImgContent = user.pic;
        
        view.movieNameContent = like.movieName;
        view.dateContent = like.showTime;
        view.theaterContent = like.theater;
        
    }
}

- (void) updateLikeList
{
    PFQuery *query = [PFQuery queryWithClassName:@"LikedList"];
    [query selectKeys:@[@"moviename", @"showtime", @"theater", @"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            Liked *like = [[Liked alloc] init];
            like.movieName =[object objectForKey:@"moviename"];
            like.showTime =[object objectForKey:@"showtime"];
            like.theater = [object objectForKey:@"theater"];
            like.userName = [object objectForKey:@"username"];
            [global.likeList addObject:like];
        }
        for (NSObject *object in global.likeList)
        {
            Liked *liked = (Liked *) object;
            
            if ([liked.movieName isEqualToString:movieLabel.text])
            {
                [movies addObject:liked];
            }
        }
        [userTableView reloadData];
        userTableView.hidden = NO;
    }];
    
}
- (IBAction)button:(id)sender {
    global.movieName = movieLabel.text;
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
            NSString *userGender = userData[@"gender"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            PFUser *user = [PFUser currentUser];
            if (![[user objectForKey:@"set"] boolValue])
            {
                user[@"set"] = @YES;
                user[@"name"] = name;
                user[@"gender"] = userGender;
                user[@"pic"] = [pictureURL absoluteString];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error)
                    {
                        NSLog(@"Saved!");
                    }
                 }];
            }
            NSLog(@"Done setting global user");
            global.userName = name;
            global.gender = userGender;
            global.picture = [pictureURL absoluteString];
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

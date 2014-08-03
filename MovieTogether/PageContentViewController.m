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
    NSMutableArray *tomorrow;
    NSMutableArray *transformer;

    AppDelegate *global;
}

@synthesize userTableView;
@synthesize spinner;
@synthesize movieLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    global = [[UIApplication sharedApplication] delegate];
    tomorrow = [[NSMutableArray alloc] init];
    transformer = [[NSMutableArray alloc] init];
    
    userList = [[NSMutableArray alloc]init];
    movies = [[NSMutableArray alloc] init];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    
    userTableView.hidden = YES;
    [self updateLikeList];
    
    // ---revised-------
    self.movieImg.image = [UIImage imageNamed:self.imgFile];
    movieLabel.text = self.movieName;
    
    
//    imgList = [NSMutableArray arrayWithObjects:@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png", nil];
  //  userList = [NSMutableArray arrayWithObjects:@"Transformer", @"Tomorrow", @"Lucy", @"Ape", @"Transformer", @"The", @"Lucy", @"Transformer", @"Edge", @"Lucy", nil];
//    genderList = [NSMutableArray arrayWithObjects:@"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", nil];
//    dateList = [NSMutableArray arrayWithObjects:@"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 2923", @"Jul 27", nil];
//    theatreList = [NSMutableArray arrayWithObjects:@"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"sdf", nil];
//    
    NSEnumerator * value = [global.userList objectEnumerator];
    for (NSObject *object in value) {
        [userList addObject:object];
   //     NSLog(object);
    }
    for (NSObject *object in global.likeList)
    {
        Liked *liked = (Liked *) object;
        if ([liked.movieName isEqualToString:@"Tomorrow"])
        {
            [tomorrow addObject :liked];
        }
        else if ([liked.movieName isEqualToString:@"Transformer"])
        {
            [transformer addObject:liked];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// inform how many rows - need to implement if has UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", [movies count]);
    
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
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMovieDetail"]) {
        NSIndexPath *indexPath = [self.userTableView indexPathForSelectedRow];
        MovieDetailViewController *movieDetailVC = segue.destinationViewController;
        //       movieDetailVC.movieName = [movies]
        NSLog(@"%d", indexPath.row);
    }

   else if ([segue.identifier isEqualToString:@"likeDetail"])
    {
        NSIndexPath *indexPath = [self.userTableView indexPathForSelectedRow];
        UserTableViewCell *cell =(UserTableViewCell *)[self.userTableView cellForRowAtIndexPath:indexPath];
        
        UserDetailController *view = segue.destinationViewController;
        User *user = (User *)[global.userList objectForKey:cell.userName.text];
        Liked *like = (Liked *)[tomorrow objectAtIndex:indexPath.row];
        
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
        [spinner stopAnimating];
        spinner.hidden = YES;
        [userTableView reloadData];
        userTableView.hidden = NO;
    }];
    
}
@end

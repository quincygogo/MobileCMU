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
//    NSMutableArray *user
    AppDelegate *global;
}

@synthesize userTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    global = [[UIApplication sharedApplication] delegate];
    tomorrow = [[NSMutableArray alloc] init];
    transformer = [[NSMutableArray alloc] init];
//    [self addToList];
    
    userList = [[NSMutableArray alloc]init];
//    for (id objcet in global.userList)
//    {
//        NSLog(((User *)objcet).name);
//    }
    // ---revised-------
    self.movieImg.image = [UIImage imageNamed:self.imgFile];
    self.movieLabel.text = self.movieName;
    
    
    imgList = [NSMutableArray arrayWithObjects:@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png", nil];
  //  userList = [NSMutableArray arrayWithObjects:@"Transformer", @"Tomorrow", @"Lucy", @"Ape", @"Transformer", @"The", @"Lucy", @"Transformer", @"Edge", @"Lucy", nil];
    genderList = [NSMutableArray arrayWithObjects:@"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", nil];
    dateList = [NSMutableArray arrayWithObjects:@"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 2923", @"Jul 27", nil];
    theatreList = [NSMutableArray arrayWithObjects:@"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"sdf", nil];
    
    NSEnumerator * value = [global.userList objectEnumerator];
    for (NSObject *object in value) {
        [userList addObject:object];
   //     NSLog(object);
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
 //   NSLog(@"%d", [userList count]);
    return [global.userList count];
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
    
    User *user = (User *)[userList objectAtIndex:indexPath.row];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://scontent-b.xx.fbcdn.net/hphotos-xpa1/t1.0-9/1425657_1441170366110528_269769878_n.jpg"]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.pic]];
    cell.userImg.image = [UIImage imageWithData:data];
    cell.userName.text = user.name;
    cell.gender.text = user.gender;
    cell.dateLabel.text = [dateList objectAtIndex:indexPath.row];
    cell.theatre.text = [theatreList objectAtIndex:indexPath.row];
    
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
}

//- (void) addToList
//{
//    for (User *user in global.userList)
//    {
//        if (user.)
//    }
//}
@end

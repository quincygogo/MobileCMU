//
//  FirstViewController.m
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "FirstViewController.h"
#import "UserTableViewCell.h"
#import "MovieDetailViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    NSMutableArray *movies;
    
    NSMutableArray *imgList;
    NSMutableArray *userList;
    NSMutableArray *genderList;
    NSMutableArray *dateList;
    NSMutableArray *theatreList;
}

@synthesize userTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    imgList = [NSMutableArray arrayWithObjects:@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png",@"u1.png", @"u2.png", nil];
    userList = [NSMutableArray arrayWithObjects:@"Transformer", @"Tomorrow", @"Lucy", @"Ape", @"Transformer", @"The", @"Lucy", @"Transformer", @"Edge", @"Lucy", nil];
    genderList = [NSMutableArray arrayWithObjects:@"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", nil];
    dateList = [NSMutableArray arrayWithObjects:@"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 2923", @"Jul 27", nil];
    theatreList = [NSMutableArray arrayWithObjects:@"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"sdf", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// inform how many rows - need to implement if has UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userList count];
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
    
    cell.userImg.image = [UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
    cell.userName.text = [userList objectAtIndex:indexPath.row];
    cell.gender.text = [genderList objectAtIndex:indexPath.row];
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


@end

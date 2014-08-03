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
#import "PageContentViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {

 //   NSMutableArray *movies;
    
//    NSMutableArray *imgList;
    NSMutableArray *userList;
    NSMutableArray *genderList;
    NSMutableArray *dateList;
    NSMutableArray *theatreList;
}

//@synthesize userTableView;

// -----revised------
@synthesize pageImages;
@synthesize pageTitles;
@synthesize pageViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //-----revised
    pageImages = [NSMutableArray arrayWithObjects:@"movie.png", @"u2.png",@"u1.png", @"u4.jpg", nil];
    pageTitles = [NSMutableArray arrayWithObjects:@"The Edge of Tomorrow", @"Lucy", @"Ape", @"Transformer", nil];
    
    // -----origin---
    genderList = [NSMutableArray arrayWithObjects:@"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", @"Female", @"Male", nil];
    dateList = [NSMutableArray arrayWithObjects:@"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 29", @"Jul 27", @"Jul 28", @"Jul 2923", @"Jul 27", nil];
    theatreList = [NSMutableArray arrayWithObjects:@"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"WaterFront", @"EMC", @"CMU", @"sdf", nil];
    
    
    // ------revised-----
    // create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];      // create the PageViewController instance.
    // specify the data source(itself)
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingVC];
    // assign to the page view controller for display
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//--------revised--------
// when user back to previous screen
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

// what to display for the next screen
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // The ID is used as reference for creating the view controller instance. To instantiate a view controller in storyboard, you can use the instantiateViewControllerWithIdentifier: method with a specific storyboard ID.
    PageContentViewController *pageContentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    // create a new view controller and pass suitable data
    pageContentVC.imgFile = self.pageImages[index];
    pageContentVC.movieName = self.pageTitles[index];
    pageContentVC.pageIndex = index;
    
    return pageContentVC;
    
}

// tell ios the number of pages
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

// which page be selected at the begining
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


/*
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
 */

@end

//
//  FirstViewController.h
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIPageViewControllerDataSource/*UITableViewDelegate, UITableViewDataSource, */>

//@property (strong, nonatomic) IBOutlet UITableView *userTableView;

// ----revision-----
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) UITableView *pageTable;




@end

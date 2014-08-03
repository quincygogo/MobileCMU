//
//  PageContentViewController.h
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// ----revised-----
@property (strong, nonatomic) IBOutlet UITableView *userTableView;  // firstVC.h
@property (strong, nonatomic) IBOutlet UIImageView *movieImg;
@property (strong, nonatomic) IBOutlet UILabel *movieLabel;
@property (strong, nonatomic) IBOutlet UIButton *movieBtn;

@property NSUInteger pageIndex;
@property NSString *movieName;
@property NSString *imgFile;


// ???? tableview   ？？？？？？？？？？？？？？？？？？？？？？？


@end


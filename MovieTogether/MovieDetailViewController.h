//
//  MovieDetailViewController.h
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/28/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) IBOutlet UILabel *director;
@property (strong, nonatomic) IBOutlet UILabel *releaseDate;
@property (strong, nonatomic) IBOutlet UITextView *summary;
@property (strong, nonatomic) IBOutlet UITableView *showTimeTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *dateControl;
- (IBAction)pickDate:(UISegmentedControl *)sender;

@end

//
//  MovieDetailViewController.h
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/28/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) IBOutlet UILabel *director;
@property (strong, nonatomic) IBOutlet UILabel *releaseDate;
@property (strong, nonatomic) IBOutlet UITextView *summary;

@end

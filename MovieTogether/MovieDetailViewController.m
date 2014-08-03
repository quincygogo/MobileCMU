//
//  MovieDetailViewController.m
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/28/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "AppDelegate.h"
#import "Movie.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController
{
    AppDelegate *global;
}
@synthesize movieName;
@synthesize summary;
@synthesize releaseDate;
@synthesize director;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        global = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    global = [[UIApplication sharedApplication] delegate];
    NSLog(global.movieName);
    Movie *movie = (Movie *)[global.movieList objectForKey:global.movieName];
  //  NSLog(global);
    director.text = movie.director;
    releaseDate.text = movie.releaseDate;
    summary.text = movie.summary;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

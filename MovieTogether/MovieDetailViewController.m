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
#import "MovieDetailCell.h"
#import <Parse/Parse.h>
#import "TheatreDetail.h"
#import "Showtime.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController
{
    AppDelegate *global;
    // theater -> tiem & date
    NSMutableDictionary *showTime;
    // theater names;
    NSMutableArray *theaters;
    NSString *today;
    NSDate *todayDate;
    NSDateFormatter *dateFormatter;
    NSString *dateVal;
}

@synthesize movieName;
@synthesize summary;
@synthesize releaseDate;
@synthesize director;
@synthesize showTimeTable;
@synthesize dateControl;

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
    global = [[UIApplication sharedApplication] delegate];
    
    //get today's date
    todayDate =  [NSDate date];
    dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    today = [dateFormatter stringFromDate:todayDate];
    dateVal = today;
    [self getShowTime:today];
    [self initDateControl];
    
    // Do any additional setup after loading the view.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [theaters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"MovieDetailCell";
    MovieDetailCell *cell = (MovieDetailCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *theaterName = [theaters objectAtIndex:indexPath.row];
    NSMutableArray *timeList = (NSMutableArray *)[showTime objectForKey:theaterName];
    
    cell.theater.text = theaterName;
    cell.timeList.text = @"";
    for (NSObject *object in timeList)
    {
        Showtime *show = (Showtime *) object;
        cell.timeList.text = [cell.timeList.text stringByAppendingString:show.time];
        cell.timeList.text = [cell.timeList.text stringByAppendingString:@" "];
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"theaterDetail"])
    {
        NSIndexPath *indexPath = [self.showTimeTable indexPathForSelectedRow];
        MovieDetailCell *cell =(MovieDetailCell *)[self.showTimeTable cellForRowAtIndexPath:indexPath];
        
        TheatreDetail *view = segue.destinationViewController;
        view.theaterName = cell.theater.text;
        view.showTimeList = [[NSMutableArray alloc] init];
        view.showTimeList = (NSMutableArray *)[showTime objectForKey:(cell.theater.text)];
        view.date = dateVal;
    }
    
}


- (void) getShowTime: (NSString*) date
{
    showTimeTable.hidden = YES;
    showTime = [[NSMutableDictionary alloc] init];
    theaters = [[NSMutableArray alloc] init];
    __block NSString *last = @"%";
    __block NSMutableArray *timeList = [[NSMutableArray alloc] init];
 
    PFQuery *query = [PFQuery queryWithClassName:@"Showtime"];
    [query whereKey:@"moviename" equalTo:global.movieName];
    [query whereKey:@"date" equalTo:date];
    
    [query addAscendingOrder:@"theatrename"];
    [query addAscendingOrder:@"time"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            NSString *theaterName = [object objectForKey:@"theatrename"];
            Showtime *show = [[Showtime alloc] init];
            show.theaterName = theaterName;
            show.movieName = global.movieName;
            show.date = date;
            show.time = [object objectForKey:@"time"];
            show.type = [object objectForKey:@"type"];
            if (![theaterName isEqualToString:last] && (![last isEqualToString:@"%"]))
            {
                [showTime setObject:timeList forKey:last];
                [theaters addObject:last];
                timeList = [[NSMutableArray alloc] init];
              
            }
            last = theaterName;
            [timeList addObject:show];
        }
        if (![last isEqualToString:@"%"])
        {
        [showTime setObject:timeList forKey:last];
        [theaters addObject:last];
        }
        [showTimeTable reloadData];
        showTimeTable.hidden = NO;
    }];
}

- (void) initDateControl
{
    
    NSDate *date = todayDate;
    for(int i = 0; i < dateControl.numberOfSegments; i++)
    {
        NSString *toSet = [dateFormatter stringFromDate:date];
        [dateControl setTitle:toSet forSegmentAtIndex:i];
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        date = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
    }
}

- (IBAction)pickDate:(UISegmentedControl *)sender {
    dateVal = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    [self getShowTime:dateVal];
}


@end

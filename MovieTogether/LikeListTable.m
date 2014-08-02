//
//  LikeListTable.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/1/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "LikeListTable.h"
#import <Parse/Parse.h>
#import "LikedTableCell.h"
#import "AppDelegate.h"

@interface LikeListTable ()

@end

@implementation LikeListTable
{
    AppDelegate *global;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.parseClassName = @"LikedList";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Todos";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;

    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        // The className to query on
        self.parseClassName = @"LikedList";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Todos";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.parseClassName = @"LikedList";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Todos";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;

        global = [[UIApplication sharedApplication] delegate];
        
    }
    return  self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.parseClassName = @"LikedList";
        // Whether the built-in pull-to-refresh is enabled
        self.title = @"Favorite Movie List";
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
        
        global = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    CGRect movieFrame = CGRectMake(0.0f, 0.0f, 300.0f, 28.0f);
    
    UILabel *movie = [[UILabel alloc] initWithFrame:movieFrame];
    movie.text = @"Favorite List";
    [movie setFont:[UIFont systemFontOfSize:26.0f]];
    movie.textAlignment = NSTextAlignmentCenter;
    [self.tableView setTableHeaderView:movie];
    UIColor *myColor = [UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0];
    [self.tableView.tableHeaderView setBackgroundColor:myColor];
    global = [[UIApplication sharedApplication] delegate];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    if (!self.parseClassName)
    {
        self.parseClassName = @"LikedList";
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    if (global.userName == nil)
    {
        NSLog(@"YOYO");
        NSString *name = @"Quincy Yip";
        global.userName = name;
        NSLog([@"hehe" stringByAppendingString:global.userName]);
    
    }
    [query whereKey:@"username" equalTo:@"Quincy Yip"];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"LikeCell";
    
    LikedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LikedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    NSString *moviename = [object objectForKey:@"moviename"];
    NSString *time = [object objectForKey:@"showtime"];
    NSString *theater = [object objectForKey:@"theater"];
    
    cell.moviename.text = moviename;
    cell.date.text = time;
    cell.theater.text = theater;
    return cell;
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

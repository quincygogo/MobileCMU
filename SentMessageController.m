//
//  SentMessageController.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "SentMessageController.h"
#import "SentTableCell.h"
#import "AppDelegate.h"
#import "User.h"

@interface SentMessageController ()

@end

@implementation SentMessageController
{
    AppDelegate *global;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        // The className to query on
        self.parseClassName = @"Message";
        
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
        self.parseClassName = @"Message";
        
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
        self.parseClassName = @"Message";
        // Whether the built-in pull-to-refresh is enabled
        self.title = @"Sent Message";
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
    self.parseClassName = @"Message";
    // Do any additional setup after loading the view.
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    CGRect movieFrame = CGRectMake(0.0f, 0.0f, 300.0f, 28.0f);
    
    UILabel *header = [[UILabel alloc] initWithFrame:movieFrame];
    header.text = @"My invitation";
    [header setFont:[UIFont systemFontOfSize:26.0f]];
    header.textAlignment = NSTextAlignmentCenter;
    [self.tableView setTableHeaderView:header];
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
        self.parseClassName = @"Message";
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
        NSString *name = @"Quincy Yip";
        global.userName = name;
        
    }
    [query whereKey:@"fromuser" equalTo:global.userName];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"SentCell";
    
    SentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.moviename.text = [object objectForKey:@"moviename"];
    cell.time.text = [object objectForKey:@"time"];
    cell.toUserName.text = [object objectForKey:@"touser"];
    cell.theater.text = [object objectForKey:@"theater"];
    
    User *user = (User*)[global.userList objectForKey:[object objectForKey:@"touser"]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.pic]];
    cell.toUserImg.image =  [UIImage imageWithData:data];

    cell.status.text = [object objectForKey:@"status"];
    if ([cell.status.text isEqualToString:@"pending"])
    {
        UIColor *color = [UIColor redColor];
        [cell.status setTextColor:color];
    }
    else
    {
        UIColor *color = [UIColor greenColor];
        [cell.status setTextColor:color];
        
    }
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  180.0f;
}

@end
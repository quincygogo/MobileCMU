//
//  ReceivedMessageController.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/2/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "ReceivedMessageController.h"
#import "ReceivedTableCell.h"
#import "AppDelegate.h"
#import "User.h"

@interface ReceivedMessageController ()

@end

@implementation ReceivedMessageController
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
        self.title = @"Received Message";
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
    UIEdgeInsets inset = UIEdgeInsetsMake(25, 0, 0, 0);
    self.tableView.contentInset = inset;
    CGRect movieFrame = CGRectMake(15.0f, 0.0f, 300.0f, 28.0f);
    
    UILabel *header = [[UILabel alloc] initWithFrame:movieFrame];
    header.text = @"Received Invitation";
    [header setFont:[UIFont systemFontOfSize:24.0f]];
    header.textAlignment = NSTextAlignmentCenter;
    [self.tableView setTableHeaderView:header];
    
    global = [[UIApplication sharedApplication] delegate];
    
    // Assign our own backgroud for the view
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
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
    [query whereKey:@"touser" equalTo:global.userName];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ReceivedCell";
    
    ReceivedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ReceivedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.moviename.text = [object objectForKey:@"moviename"];
    cell.time.text = [object objectForKey:@"time"];
    cell.fromUserName.text = [object objectForKey:@"fromuser"];
    cell.location.text = [object objectForKey:@"theater"];
    
    User *user = (User*)([global.userList objectForKey:[object objectForKey:@"fromuser"]]);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.pic]];
    cell.fromUserImg.image =  [UIImage imageWithData:data];
    
    // to corner angle
    cell.fromUserImg.layer.masksToBounds = YES;
    cell.fromUserImg.layer.cornerRadius = 5.0;
    cell.fromUserImg.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.fromUserImg.layer.shouldRasterize = YES;
    cell.fromUserImg.clipsToBounds = YES;
    
    cell.messageId = object.objectId;
    if ([[object objectForKey:@"status"] isEqualToString:@"Pending"])
    {
        cell.status.hidden = YES;
        cell.acceptButton.hidden = NO;
        cell.declineButton.hidden = NO;
    }
    else if ([[object objectForKey:@"status"] isEqualToString:@"Declined"])
    {
        cell.status.hidden = NO;
        cell.status.text = @"Declined";
        [cell.status setTextColor:[UIColor colorWithRed: 246.0/255.0 green: 37.0/255.0 blue:86.0/255.0 alpha: 0.8]];
        cell.acceptButton.hidden = YES;
        cell.declineButton.hidden = YES;
        
    }
    else
    {
        cell.status.hidden = NO;
        cell.status.text = @"Accepted";
        [cell.status setTextColor:[UIColor colorWithRed: 88.0/255.0 green: 191.0/255.0 blue:98/255.0 alpha: 0.8]];
        cell.acceptButton.hidden = YES;
        cell.declineButton.hidden = YES;
        
    }
    
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    

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
    return  93.0f;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}


@end

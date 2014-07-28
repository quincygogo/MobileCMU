//
//  SecondViewController.m
//  MovieTogether
//
//  Created by Xiaoyan Cai on 7/27/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    NSMutableArray *list;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    list = [NSMutableArray arrayWithObjects:@"Transformer", @"The Edge of Tomorrow", @"Lucy", @"Ape", @"Transformer", @"The Edge of Tomorrow", @"Lucy", @"Transformer", @"The Edge of Tomorrow", @"Lucy", @"Ape", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// inform how many rows - need to implement if has UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

// called every time when a table row is displayed - need to implement if has UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    return cell;
}

@end

//
//  ReceivedMessageTable.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/29/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "ReceivedMessageTable.h"

@implementation ReceivedMessageTable {
    NSArray *list;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        list = [NSArray arrayWithObjects:@"Received: hehe1", @"Received: hehe2", nil];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple = @"Simple";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simple];
    }
    
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    return cell;
}

@end

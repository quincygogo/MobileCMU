//
//  ReceivedMessageTable.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/29/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "SentMessageTable.h"
#define originalHeight 25.0f
#define newHeight 100.0f
#define isOpen @"100.0f"

@implementation SentMessageTable {
    NSMutableDictionary *dicClicked;
    NSInteger count;
    CGFloat mHeight;
    NSInteger sectionIndex;}

- (id) init
{
    self = [super init];
    if (self)
    {
        count = 0;
        mHeight = originalHeight;
        sectionIndex = 0;
        dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentIndentifer = @"Container";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIndentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIndentifer];
        }
        NSString *statisticsContent = [[NSString alloc] initWithString:@"rlf:岁月流芳，花开几度，走在岁月里，醉在流香里，总在时光里辗转徘徊。花开几许，落花几度，岁月寒香，飘进谁的诗行，一抹幽香，掺入几许愁伤，流年似花，春来秋往，睁开迷离的双眼，回首张望，随风的尘烟荡漾着迷忙，昨日的光阴已逝去."];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = statisticsContent;
        cell.textLabel.textColor = [UIColor brownColor];
        cell.textLabel.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        cell.textLabel.numberOfLines = 20;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Status: Pending";
    cell.textLabel.font = [UIFont systemFontOfSize:10.0f];
    cell.textLabel.textColor = [UIColor redColor];
    count++;
    return cell;
}

- (void) accept
{
    NSLog(@"accept");
}

- (void) ignore
{
    NSLog(@"ignore");
}


//Section的标题栏高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return 46;
//    else
//        return 30.0f;
//}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGRect headerFrame = CGRectMake(0, 0, 300, 30);
//    CGFloat y = 2;
//    if (section == 0) {
//        headerFrame = CGRectMake(0, 0, 300, 100);
//        y = 18;
//    }
//    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
//    UILabel *dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, y, 240, 24)];//日期标签
//    dateLabel.font=[UIFont boldSystemFontOfSize:16.0f];
//    dateLabel.textColor = [UIColor darkGrayColor];
//    dateLabel.backgroundColor=[UIColor clearColor];
//    UILabel *ageLabel=[[UILabel alloc] initWithFrame:CGRectMake(216, y, 88, 24)];//年龄标签
//    ageLabel.font=[UIFont systemFontOfSize:14.0];
//    ageLabel.textAlignment=UITextAlignmentRight;
//    ageLabel.textColor = [UIColor darkGrayColor];
//    ageLabel.backgroundColor=[UIColor clearColor];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"MM dd,yyyy";
//    dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
//    ageLabel.text = @"1岁 2天";
//
//    [headerView addSubview:dateLabel];
//    [headerView addSubview:ageLabel];
//    return headerView;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        if (targetCell.frame.size.height == originalHeight){
            [dicClicked setObject:isOpen forKey:indexPath];
        }
        else{
            [dicClicked removeObjectForKey:indexPath];
        }
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    NSLog(@"indexPath=%@",indexPath);
    NSLog(@"dicClicked=%@",dicClicked);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([[dicClicked objectForKey:indexPath] isEqualToString: isOpen])
            return [[dicClicked objectForKey:indexPath] floatValue];
        else
            return originalHeight;
    }
    else {
        return 25.0f;
    }
}

@end

//
//  ReceivedMessageTable.m
//  MovieTogether
//
//  Created by Jessica Zhuang on 7/29/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import "ReceivedMessageTable.h"
#define originalHeight 25.0f
#define newHeight 88.0f
#define isOpen @"88.0f"

@implementation ReceivedMessageTable {
    NSMutableDictionary *dicClicked;
    NSInteger count;
    CGFloat mHeight;
    NSInteger sectionIndex;
    NSInteger *check;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        count = 0;
        mHeight = originalHeight;
        sectionIndex = 0;
        dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
//        firstTime = [NSMutableArray arrayWithCapacity:20];
        check = 0;
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
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentIndentifer = @"Container";
    float FONT_SIZE = 12.0f;
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIndentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIndentifer];
            CGRect nameFrame = CGRectMake(0.0f, 2.0f, 60.0f, 20.0f);
            UILabel *name = [[UILabel alloc] initWithFrame:nameFrame];
            name.text = @"From";
            [name setLineBreakMode:NSLineBreakByWordWrapping];
            [name setMinimumScaleFactor:FONT_SIZE];
            [name setNumberOfLines:0];
            [name setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [name setTag:0];
            
            CGRect movieFrame = CGRectMake(0.0f, 22.0f, 60.0f, 20.0f);
            UILabel *movie = [[UILabel alloc] initWithFrame:movieFrame];
            movie.text = @"Transformer";
            [movie setLineBreakMode:NSLineBreakByWordWrapping];
            [movie setMinimumScaleFactor:FONT_SIZE];
            [movie setNumberOfLines:0];
            [movie setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [movie setTag:1];

            [[cell contentView] addSubview:name];
            [[cell contentView] addSubview:movie];
//            if ([firstTime count] >= indexPath.section && [[firstTime objectAtIndex:indexPath.section] isEqualToString: @"done"])
//            {
//                [cell viewWithTag:1].hidden = YES;
//                NSLog(@"hehe");
//                [firstTime replaceObjectAtIndex:indexPath.section withObject:@"done"];
//            }
//            else
//            {
//                [cell viewWithTag:1].hidden = NO;
//            }
            if (check <= indexPath.section) {
                [cell viewWithTag:1].hidden = YES;
                check = indexPath.section;
            } else {
                [cell viewWithTag:1].hidden = NO;
            }
        }

//        NSString *statisticsContent = [[NSString alloc] initWithString:@"From:"];
//        
//        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
//        cell.textLabel.text = statisticsContent;
//        cell.textLabel.textColor = [UIColor brownColor];
//        cell.textLabel.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
//        cell.textLabel.numberOfLines = 10;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    acceptButton.frame = CGRectMake(0.0f, 2.0f, 60.0f, 32.0f);
    [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    acceptButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [acceptButton addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchDown];
    acceptButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    
    UIButton *ignoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ignoreButton.frame = CGRectMake(220.0f, 2.0f, 60.0f, 32.0f);
    [ignoreButton setTitle:@"Ignore" forState:UIControlStateNormal];
    ignoreButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [ignoreButton addTarget:self action:@selector(ignore) forControlEvents:UIControlEventTouchDown];
    ignoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [cell addSubview:acceptButton];
    [cell addSubview:ignoreButton];
    
    
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
//    NSLog(@"indexPath=%@",indexPath);
//    NSLog(@"dicClicked=%@",dicClicked);
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
        return 48.0f;
    }
}

@end

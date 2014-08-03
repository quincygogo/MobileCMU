//
//  Movie.h
//  MovieTogether
//
//  Created by Jessica Zhuang on 8/3/14.
//  Copyright (c) 2014 yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *director;
@property (strong, nonatomic) NSString *releaseDate;
@property (strong, nonatomic) NSString *summary;

@end

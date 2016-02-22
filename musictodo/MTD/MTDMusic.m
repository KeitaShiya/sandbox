//
//  MTDMusic.m
//  MTD
//
//  Created by shiya keita on 2014/09/16.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import "MTDMusic.h"

@implementation MTDMusic

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_artist forKey:@"artist"];
}

@end

//
//  Task.h
//  MTD
//
//  Created by shiya keita on 2014/09/16.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSData * musics;

@end

//
//  MTDCoreDataManager.h
//  MTD
//
//  Created by shiya keita on 2014/09/14.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface MTDCoreDataManager : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;
- (Task *)newTask;

@end

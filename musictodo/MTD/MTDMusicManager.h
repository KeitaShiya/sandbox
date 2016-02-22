//
//  MTDMusicManager.h
//  MTD
//
//  Created by shiya keita on 2014/09/20.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPMediaItemCollection;
@interface MTDMusicManager : NSObject

@property (nonatomic, strong, readonly) NSArray *songIDs;

+ (instancetype)sharedManager;
- (void)setCollectionAndPlay:(MPMediaItemCollection *)collection;

@end

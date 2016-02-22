//
//  MTDMusicManager.m
//  MTD
//
//  Created by shiya keita on 2014/09/20.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import "MTDMusicManager.h"
@import MediaPlayer;
@import AVFoundation;

@interface MTDMusicManager ()

@property (nonatomic, strong) AVQueuePlayer *player;

@end

@implementation MTDMusicManager

static MTDMusicManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MTDMusicManager alloc] init];
    });
    return sharedManager;
}

- (void)setCollectionAndPlay:(MPMediaItemCollection *)collection
{
    NSMutableArray *musics = [@[] mutableCopy];
    for (id concreteItem in [collection items]) {
        NSURL *URL = [concreteItem valueForProperty:MPMediaItemPropertyAssetURL];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
        [musics addObject:item];
    }
    self.player = [AVQueuePlayer queuePlayerWithItems:musics];
    [self.player play];
}

@end

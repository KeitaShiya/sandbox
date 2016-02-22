//
//  MTDTaskTableViewCell.m
//  MTD
//
//  Created by SHIYA Keita on 2014/09/16.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import "MTDTaskTableViewCell.h"
#import "Task.h"
#import "MTDCoreDataManager.h"
#import "MTDMusicManager.h"
#import "MTDMusic.h"
@import MediaPlayer;

@interface MTDTaskTableViewCell ()

@property (nonatomic, strong) MPMediaItemCollection *collection;

@end

@implementation MTDTaskTableViewCell

- (void)awakeFromNib
{
    self.separatorInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    [self.checkBox addTarget:self action:@selector(checkBoxDidChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setTask:(id)task
{
    _task = task;
    Task *taskObject = (Task *)task;
    self.taskNameLabel.text = taskObject.taskName;
    self.checkBox.checked = [taskObject.isComplete boolValue];
    self.collection = [NSKeyedUnarchiver unarchiveObjectWithData:taskObject.musics];
}

#pragma mark - accessor

- (Task *)taskObject
{
    return (Task *)self.task;
}

#pragma mark - action

- (void)checkBoxDidChanged:(id)sender
{
    CTCheckbox *checkBox = (CTCheckbox *)sender;
    if ([self.taskObject.isComplete boolValue] == checkBox.checked) {
        return;
    }
    
    self.taskObject.isComplete = @(checkBox.checked);
    [[MTDCoreDataManager sharedManager].managedObjectContext save:nil];
}
- (IBAction)playSongs:(id)sender {
    if (!self.collection) {
        return;
    }
    [[MTDMusicManager sharedManager] setCollectionAndPlay:self.collection];
}

@end

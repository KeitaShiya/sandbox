//
//  MTDTaskTableViewCell.h
//  MTD
//
//  Created by SHIYA Keita on 2014/09/16.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTCheckBox.h"

@interface MTDTaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CTCheckbox *checkBox;
@property (nonatomic, strong) id task;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;

@end

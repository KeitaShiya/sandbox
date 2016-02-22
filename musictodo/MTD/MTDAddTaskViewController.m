//
//  MTDAddTaskViewController.m
//  MTD
//
//  Created by shiya keita on 2014/09/15.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import "MTDAddTaskViewController.h"
#import "MTDCoreDataManager.h"
@import MediaPlayer;
#import "MTDMusic.h"

@interface MTDAddTaskViewController () <UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mutableMusics;
@property (nonatomic, strong) MPMediaItemCollection *collection;

@end

@implementation MTDAddTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textfield.text = self.task.taskName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MPMediaItemCollection *collection = [NSKeyedUnarchiver unarchiveObjectWithData:self.task.musics];
    [self setMediaItemCollection:collection];
}

#pragma mark -

- (IBAction)add:(id)sender
{
    self.task.taskName = self.textfield.text;
    self.task.musics = [NSKeyedArchiver archivedDataWithRootObject:self.collection];
    [[MTDCoreDataManager sharedManager].managedObjectContext save:nil];
    [self close];
}
- (IBAction)cancel:(id)sender
{
    [self close];
}

- (IBAction)addMusic:(id)sender
{
    MPMediaPickerController *mediaPickerController = [[MPMediaPickerController alloc] init];
    mediaPickerController.delegate = self;
    mediaPickerController.allowsPickingMultipleItems = YES;
    [self presentViewController:mediaPickerController animated:YES completion:nil];
}

#pragma mark - 

- (void)setMediaItemCollection:(MPMediaItemCollection *)collection
{
    if (!collection) {
        self.mutableMusics = [@[] mutableCopy];
        return;
    }
    [self.mutableMusics removeAllObjects];
    for (MPMediaItem *item in [collection items]) {
        MTDMusic *music = [[MTDMusic alloc] init];
        music.title = [item valueForProperty:MPMediaItemPropertyTitle];
        music.artist = [item valueForProperty:MPMediaItemPropertyArtist];
        [self.mutableMusics addObject:music];
    }
}

#pragma mark - media picker delegate

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    self.collection = mediaItemCollection;
    [self setMediaItemCollection:mediaItemCollection];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];        
    }];
}

#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mutableMusics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    MTDMusic *musicObject = (MTDMusic *)self.mutableMusics[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", musicObject.title, musicObject.artist];
    [cell.textLabel sizeToFit];
    return cell;
}

#pragma mark - 

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  MTDTasksTableViewController.m
//  MTD
//
//  Created by shiya keita on 2014/09/14.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import "MTDTasksTableViewController.h"
#import "MTDCoreDataManager.h"
@import CoreData;
#import "MTDAddTaskViewController.h"
#import "MTDTaskTableViewCell.h"

@interface MTDTasksTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end

@implementation MTDTasksTableViewController

#pragma mark - accessor

- (NSFetchedResultsController *)fetchedResultController
{
    if (_fetchedResultController) {
        return _fetchedResultController;
    }
    
    MTDCoreDataManager *manager = [MTDCoreDataManager sharedManager];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:manager.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:20];
   
    NSSortDescriptor *sortDescripter1 = [[NSSortDescriptor alloc] initWithKey:@"isComplete" ascending:YES];
    NSSortDescriptor *sortDescripter2 = [[NSSortDescriptor alloc] initWithKey:@"taskName" ascending:YES];
    NSArray *sortDescripters = @[sortDescripter1, sortDescripter2];
    [request setSortDescriptors:sortDescripters];
    
    NSFetchedResultsController *fetchedResultConroller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:manager.managedObjectContext sectionNameKeyPath:nil cacheName:@"Tasks"];
    fetchedResultConroller.delegate = self;
    _fetchedResultController = fetchedResultConroller;
    
    NSError *error = nil;
    if (![self.fetchedResultController performFetch:&error]) {
        NSLog(@"%@ : %@", error, error.userInfo);
        abort();
    }
    return _fetchedResultController;
}

#pragma mark - fetched result controller 

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultController objectAtIndexPath:indexPath];
    MTDTaskTableViewCell *checkBoxCell = (MTDTaskTableViewCell *)cell;
    [checkBoxCell setTask:object];
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addTask"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        MTDAddTaskViewController *addTaskViewController = (MTDAddTaskViewController *)navigationController.topViewController;
        
        Task *newTask = [[MTDCoreDataManager sharedManager] newTask];
        addTaskViewController.task = newTask;
    } else if ([segue.identifier isEqualToString:@"editTask"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        MTDAddTaskViewController *addTaskViewController = (MTDAddTaskViewController *)navigationController.topViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task *task = [self.fetchedResultController objectAtIndexPath:indexPath];
        addTaskViewController.task = task;
    }
}

@end

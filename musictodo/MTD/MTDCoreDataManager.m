//
//  MTDCoreDataManager.m
//  MTD
//
//  Created by shiya keita on 2014/09/14.
//  Copyright (c) 2014年 shiya keita. All rights reserved.
//

#import "MTDCoreDataManager.h"
@import CoreData;

@interface MTDCoreDataManager ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCordinator;

@end

@implementation MTDCoreDataManager

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCordinator = _persistentStoreCordinator;
@synthesize managedObjectContext = _managedObjectContext;

static MTDCoreDataManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MTDCoreDataManager alloc] init];
    });
    return sharedManager;
}

- (Task *)newTask
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    Task *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
    
    return newManagedObject;
}

#pragma mark - core data stacks

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCordinator
{
    if (_persistentStoreCordinator) {
        return _persistentStoreCordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MTD.splite"];
    
    NSError *error = nil;
    _persistentStoreCordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"%@ ; %@", error, error.userInfo);
        abort();
    }
    return _persistentStoreCordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *persistantStoreCordinator = [self persistentStoreCordinator];
    if (persistantStoreCordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:persistantStoreCordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
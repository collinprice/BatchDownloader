//
//  AppDelegate.m
//  BatchDownloader
//
//  Created by Collin on 2013-08-08.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import "AppDelegate.h"
#import "OSMTileDownloader.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.batchDownloader = [[BatchDownloader alloc] init];
    self.batchDownloader.delegate = self;
    
    [OSMTileDownloader downloadTilesWithQueue:self.batchDownloader withLatitude:43.08 withLongitude:-79.07 withRadius:10];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [self.batchDownloader archiveOperations];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
    
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (self.batchDownloader) {
        [self.batchDownloader restoreOperations];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self.batchDownloader archiveOperations];
}

-(void)downloadItemComplete:(DownloadItem *)downloadItem {
    
    NSLog(@"Complete: %@", downloadItem.url);
}

-(void)downloadItemDuplicate:(DownloadItem *)downloadItem {
    
    NSLog(@"Duplicate: %@", downloadItem.url);
}

-(void)downloadItemFailed:(DownloadItem *)downloadItem {
    
    NSLog(@"Failed: %@", downloadItem.url);
}

-(void)queueComplete:(NSOperationQueue *)queue {
    NSLog(@"complete");
}

-(void)queueResumed:(NSOperationQueue *)queue {
    NSLog(@"resumed");
}

-(void)queueSuspended:(NSOperationQueue *)queue {
    NSLog(@"suspended");
}

@end

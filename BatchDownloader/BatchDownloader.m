//
//  BatchDownloader.m
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import "BatchDownloader.h"

static NSString* kRemainingDownloadItems = @"remainingDownloadItems";

@implementation BatchDownloader {
    
    NSOperationQueue* _operationQueue;
}

-(id)init {
    
    self = [super init];
    if (self) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 4;
        self.shouldOverwritePath = NO;
    }
    return self;
}

-(void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount {
    _operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
    self.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

-(void)addItem:(DownloadItem*)item {
    
    item.delegate = self.downloadItemDelegate;
    [_operationQueue addOperation:item];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(BOOL)archiveOperations {
    
    NSLog(@"Archiving operations.");
    if ([_operationQueue operationCount] > 0) {
        [_operationQueue setSuspended:YES];
        NSArray* operations = [_operationQueue operations];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:operations];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kRemainingDownloadItems];
        
        [_operationQueue cancelAllOperations];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)restoreOperations {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kRemainingDownloadItems];
    if (data != nil) {
        NSLog(@"Restoring operations.");
        NSArray *operations = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_operationQueue addOperations:operations waitUntilFinished:NO];
        [_operationQueue setSuspended:NO];
        return YES;
    } else {
        return NO;
    }
}

-(void)waitUntilFinished {
    [_operationQueue waitUntilAllOperationsAreFinished];
}

-(NSInteger)remainingItems {
    
    return [_operationQueue operationCount];
}

#pragma InternalDownloadItem Delegate

-(void)downloadItemComplete:(DownloadItem *)downloadItem {
    
    if ([_operationQueue operationCount] <= 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end

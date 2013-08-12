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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadItemCompleteNotification:) name:kDownloadItemComplete object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadItemFailedNotification:) name:kDownloadItemFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadItemDuplicateNotification:) name:kDownloadItemDuplicate object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDownloadItemFinishedNotification:) name:kDownloadItemFinished object:nil];
    }
    return self;
}

-(void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount {
    _operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
    self.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

-(void)addItem:(DownloadItem*)item {
    
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

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma DownloadItem Observers

-(void)receiveDownloadItemCompleteNotification:(NSNotification*)notification {
    
    if ([self.delegate respondsToSelector:@selector(downloadItemComplete:)]) {
        [self.delegate downloadItemComplete:(DownloadItem*)notification.object];
    }
}

-(void)receiveDownloadItemFailedNotification:(NSNotification*)notification {
    
    if ([self.delegate respondsToSelector:@selector(downloadItemFailed:)]) {
        [self.delegate downloadItemFailed:(DownloadItem*)notification.object];
    }
}

-(void)receiveDownloadItemDuplicateNotification:(NSNotification*)notification {
    
    if ([self.delegate respondsToSelector:@selector(downloadItemDuplicate:)]) {
        [self.delegate downloadItemDuplicate:(DownloadItem*)notification.object];
    }
}

-(void)receiveDownloadItemFinishedNotification:(NSNotification*)notification {
    
    if ([_operationQueue operationCount] <= 1) {
        if ([self.delegate respondsToSelector:@selector(queueComplete)]) {
            [self.delegate queueComplete];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end

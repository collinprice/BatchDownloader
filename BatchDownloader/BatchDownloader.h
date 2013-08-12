//
//  BatchDownloader.h
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadItem.h"

@protocol BatchDownloaderDelegate <NSObject>

@optional
-(void)downloadItemComplete:(DownloadItem*)downloadItem;
-(void)downloadItemFailed:(DownloadItem*)downloadItem;
-(void)downloadItemDuplicate:(DownloadItem*)downloadItem;
-(void)queueComplete;

@end


@interface BatchDownloader : NSObject

@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;
@property (nonatomic, strong) id<BatchDownloaderDelegate> delegate;
@property (nonatomic, assign) BOOL shouldOverwritePath;

-(void)addItem:(DownloadItem*)item;
-(BOOL)archiveOperations;
-(BOOL)restoreOperations;
-(void)waitUntilFinished;
-(NSInteger)remainingItems;

@end

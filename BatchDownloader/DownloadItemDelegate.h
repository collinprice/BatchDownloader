//
//  DownloadItemDelegate.h
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadItem;

@protocol DownloadItemDelegate <NSObject>

@optional
-(void)downloadItemDidFinish:(DownloadItem*)downloadItem;
-(void)downloadItemDownloadFailed:(DownloadItem*)downloadItem;
-(void)downloadItemDiskWriteFailed:(DownloadItem*)downloadItem;
-(void)downloadItemDuplicatePath:(DownloadItem*)downloadItem;

@end

//
//  DownloadItem.h
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* kDownloadItemComplete = @"DownloadItemComplete";
static NSString* kDownloadItemFailed = @"DownloadItemFailed";
static NSString* kDownloadItemDuplicate = @"DownloadItemDuplicate";
static NSString* kDownloadItemFinished = @"DownloadItemFinished";

@interface DownloadItem : NSOperation <NSCoding>

@property (nonatomic, assign) BOOL shouldOverwritePath;

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* path;

@end

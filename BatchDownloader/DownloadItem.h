//
//  DownloadItem.h
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadItemDelegate.h"

@protocol InternalDownloadItemDelegate <NSObject>

-(void)downloadItemComplete:(DownloadItem*)downloadItem;

@end

@interface DownloadItem : NSOperation <NSCoding>

@property (nonatomic, strong) id<DownloadItemDelegate> delegate;
@property (nonatomic, strong) id<InternalDownloadItemDelegate> internalDelegate;
@property (nonatomic, assign) BOOL shouldOverwritePath;

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* path;

@end

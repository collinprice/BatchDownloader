//
//  OSMTileDownloader.h
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatchDownloader.h"

@interface OSMTileDownloader : NSObject

+(void)downloadTilesWithQueue:(BatchDownloader*)queue withLatitude:(float)latitude withLongitude:(float)longitude withRadius:(float)radius;

@end

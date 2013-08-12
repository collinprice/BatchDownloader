//
//  AppDelegate.h
//  BatchDownloader
//
//  Created by Collin on 2013-08-08.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatchDownloader.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BatchDownloaderDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BatchDownloader* batchDownloader;

@end

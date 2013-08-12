//
//  DownloadItem.m
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import "DownloadItem.h"

@implementation DownloadItem

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeBool:self.shouldOverwritePath forKey:@"override"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.shouldOverwritePath = [aDecoder decodeBoolForKey:@"override"];
    }
    return self;
}

-(void)main {
    [super main];
    
    if ([self isCancelled]) return;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.path];
    
    if (fileExists) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadItemDuplicate object:self];
    }
    
    if ( !fileExists || self.shouldOverwritePath) {

        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
        if (data == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadItemFailed object:self];
        } else {
            [data writeToFile:self.path atomically:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadItemComplete object:self];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadItemFinished object:self];
}

@end

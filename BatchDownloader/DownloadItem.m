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
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
    }
    return self;
}

-(void)main {
    [super main];
    
    if ([self isCancelled]) return;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.path];
    
    if (fileExists) {
        if ([self.delegate respondsToSelector:@selector(downloadItemDuplicatePath:)]) {
            [self.delegate downloadItemDuplicatePath:self];
        }
    }
    
    if ( !fileExists || self.shouldOverwritePath) {

        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
        if (data == nil) {
            if ([self.delegate respondsToSelector:@selector(downloadItemDownloadFailed:)]) {
                [self.delegate downloadItemDownloadFailed:self];
            }
        } else {
            BOOL writeStatus = [data writeToFile:self.path atomically:NO];
            
            if (!writeStatus) {
                if ([self.delegate respondsToSelector:@selector(downloadItemDiskWriteFailed:)]) {
                    [self.delegate downloadItemDiskWriteFailed:self];
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(downloadItemDidFinish:)]) {
                [self.delegate downloadItemDidFinish:self];
            }
        }
        
    }
    
    [self.internalDelegate downloadItemComplete:self];
}

@end

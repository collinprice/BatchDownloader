//
//  OSMTileDownloader.m
//  QueueTest
//
//  Created by Collin on 2013-08-07.
//  Copyright (c) 2013 Collin Price. All rights reserved.
//

#import "OSMTileDownloader.h"
#import "DownloadItem.h"
#include <math.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation OSMTileDownloader

+(void)downloadTilesWithQueue:(BatchDownloader*)queue withLatitude:(float)latitude withLongitude:(float)longitude withRadius:(float)radius {
    
    float min_longitude = [((NSNumber*)[self getNewLatitudeLongitudeFrom:latitude withLongitude:longitude withDistance:radius withBearing:270][@"longitude"]) floatValue];
    float max_longitude = [((NSNumber*)[self getNewLatitudeLongitudeFrom:latitude withLongitude:longitude withDistance:radius withBearing:90][@"longitude"]) floatValue];
    
    float min_latitude = [((NSNumber*)[self getNewLatitudeLongitudeFrom:latitude withLongitude:longitude withDistance:radius withBearing:0][@"latitude"]) floatValue];
    float max_latitude = [((NSNumber*)[self getNewLatitudeLongitudeFrom:latitude withLongitude:longitude withDistance:radius withBearing:180][@"latitude"]) floatValue];
    
    NSInteger counter = 0;
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for (NSInteger zoom = 0; zoom <= 16; ++zoom) {
        
        NSInteger min_x = [self getX:min_longitude withZoom:zoom];
        NSInteger max_x = [self getX:max_longitude withZoom:zoom];
        
        NSInteger min_y = [self getY:min_latitude withZoom:zoom];
        NSInteger max_y = [self getY:max_latitude withZoom:zoom];
        
        for (NSInteger x = min_x; x <= max_x; ++x) {
            for (NSInteger y = min_y; y <= max_y; ++y) {
                
                NSString* url = [NSString stringWithFormat:@"http://a.tile.openstreetmap.org/%d/%d/%d.png", zoom, x, y];
                __block NSString* filename = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_%d_%d.png", zoom, x, y]];
                
                DownloadItem* item = [[DownloadItem alloc] init];
                item.url = url;
                item.path = filename;
                [queue addItem:item];
                
                ++counter;
            }
        }
    }
    
    NSLog(@"final count = %d", counter);
}

+(NSInteger)getX:(float)longitude withZoom:(NSInteger)zoom {
    return floor( ((longitude + 180) / 360) * pow(2, zoom) );
}

+(NSInteger)getY:(float)latitude withZoom:(NSInteger)zoom {
    return floor((1 - log(tan(DEGREES_TO_RADIANS(latitude)) + 1 / cos(DEGREES_TO_RADIANS(latitude))) / M_PI) /2 * pow(2, zoom));
}

+(NSDictionary*)getNewLatitudeLongitudeFrom:(float)latitude withLongitude:(float)longitude withDistance:(float)distance withBearing:(float)bearing {
    
    bearing = DEGREES_TO_RADIANS(bearing);
	float EARTH_RADIUS_M = 6378.137;
	float d_R = distance / EARTH_RADIUS_M;
    
	float initial_latitude = DEGREES_TO_RADIANS(latitude);
	float initial_longitude = DEGREES_TO_RADIANS(longitude);
    
	NSNumber* new_latitude = [NSNumber numberWithFloat:asin( sin(initial_latitude) * cos(d_R) + cos(initial_latitude) * sin(d_R) * cos(bearing) )];
	NSNumber* new_longitude = [NSNumber numberWithFloat:initial_longitude + atan2( sin(bearing) * sin(d_R) * cos(initial_latitude), cos(d_R) - sin(initial_latitude) * sin([new_latitude floatValue]))];
    
    return @{
             @"latitude" : [NSNumber numberWithFloat:RADIANS_TO_DEGREES([new_latitude floatValue])],
             @"longitude" : [NSNumber numberWithFloat:RADIANS_TO_DEGREES([new_longitude floatValue])],
             };
}

+(void)saveData:(NSData*)data toPath:(NSString*)path {
    
    [data writeToFile:path atomically:YES];
//    NSLog(@"status = %@", status ? @"YES" : @"NO");
}

+(NSData*) getDataFromURL:(NSString *)fileURL {
    
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
}


@end

//
//  DivvyStation.m
//  CodeChallenge3
//
//  Created by Leandro Pessini on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "DivvyStation.h"

@implementation DivvyStation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.stationName = dictionary[@"stationName"];
        self.availableBikes = dictionary[@"availableBikes"];
        self.stationID = dictionary[@"id"];
        self.latitude = dictionary[@"latitude"];
        self.longitude = dictionary[@"longitude"];

        double lat = [dictionary[@"latitude"] doubleValue];
        double lon;

        if ([dictionary[@"longitude"] doubleValue] > 0)
        {
            lon = -[dictionary[@"longitude"] doubleValue];
        }
        else {
            lon = [dictionary[@"longitude"]doubleValue];
        }
        self.coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
    return self;
}

+(NSMutableArray *)divvyStationsArray
{
    NSMutableArray *pinArray = [NSMutableArray new];
    NSString *string = [NSString stringWithFormat:@"http://www.divvybikes.com/stations/json/"];
    NSURL *url = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data)
    {
        return nil;
    }
    NSDictionary *mapDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *mapArray = mapDict[@"stationBeanList"];
    for (NSDictionary *stations in mapArray) {
        DivvyStation *divvyStation = [[DivvyStation alloc] initWithDictionary:stations];
        [pinArray addObject:divvyStation];
    }
    return pinArray;
}

@end

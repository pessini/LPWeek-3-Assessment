//
//  DivvyStation.h
//  CodeChallenge3
//
//  Created by Leandro Pessini on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DivvyStation : MKPointAnnotation

@property NSString *stationID;
@property NSString *stationName;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *stationAddress;
@property NSString *availableBikes;
@property NSString *statusValue;



@property MKPointAnnotation *annotation;
@property NSMutableArray *pinArray;

@property NSString *direction;
@property NSString *intermodal;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)divvyStationsArray;

@end

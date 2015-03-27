//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.divvyStation.stationName;
    [self.mapView addAnnotation:self.divvyStation.annotation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - MapKit

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    self.divvyStation.annotation = annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    self.divvyStation.annotation.title = self.divvyStation.stationName;
    pin.image = [UIImage imageNamed:@"bikeImage"];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // alert with the route

    /*
    CLLocationCoordinate2D pin = view.annotation.coordinate;
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pin addressDictionary:nil];
    MKMapItem *destItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    request.destination = destItem;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.destinationRoute = response.routes.lastObject;
            [self.mapView addOverlay:self.destinationRoute.polyline level:MKOverlayLevelAboveRoads];
        }
    }];
     
     */
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *rendered = [[MKPolylineRenderer alloc] initWithPolyline:route];
        rendered.strokeColor = [UIColor colorWithRed:0.99 green:0.55 blue:0.31 alpha:1.00];
        rendered.lineWidth = 5.0;
        return rendered;
    }
    else
    {
        return nil;
    }
}

@end

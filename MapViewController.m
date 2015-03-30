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
@property MKRoute *destinationRoute;
@property CLPlacemark *destinationPlacemark;
@property NSTimeInterval timeToLocation;
@property NSMutableString *directionSting;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.divvyStation.stationName;
    [self.mapView addAnnotation:self.divvyStation.annotation];
    self.mapView.showsUserLocation = YES;
    [self scaleMapToASpanFromLatitudade:.05 andLongitude:.05];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - MapKit

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    self.divvyStation.annotation = annotation;

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    self.divvyStation.annotation.title = self.divvyStation.stationName;
    pin.image = [UIImage imageNamed:@"bikeImage"];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void)scaleMapToASpanFromLatitudade:(CLLocationDegrees)latidude andLongitude:(CLLocationDegrees)longitude
{
    CLLocationCoordinate2D centerCoordinate = self.divvyStation.annotation.coordinate;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = latidude;
    coordinateSpan.longitudeDelta = longitude;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    CLLocationCoordinate2D pin = view.annotation.coordinate;
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pin addressDictionary:nil];
    MKMapItem *destItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    request.destination = destItem;

    [self getDirectionsTo:destItem];

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else
        {
            self.destinationRoute = response.routes.lastObject;
            [self.mapView addOverlay:self.destinationRoute.polyline level:MKOverlayLevelAboveRoads];
        }
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *rendered = [[MKPolylineRenderer alloc] initWithPolyline:route];
        rendered.strokeColor = [UIColor redColor];
        rendered.lineWidth = 5.0;
        return rendered;
    }
    else
    {
        return nil;
    }
}

- (void)getDirectionsTo:(MKMapItem *)destinationItem
{
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destinationItem;
    request.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
        MKRoute *route = response.routes.firstObject;
        NSMutableString *directionString = [NSMutableString new];
        int counter = 1;
        for (MKRouteStep *step in route.steps)
        {
            [directionString appendFormat:@"%d: %@\n", counter, step.instructions];
            counter++;
        }
        // Show Alert with Instructions
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Route Instructions"
                                                        message:directionString
                                                       delegate:self
                                              cancelButtonTitle:@"Thanks"
                                              otherButtonTitles:nil];
        [self scaleMapToASpanFromLatitudade:.02 andLongitude:.02];
        [alert show];
    }];
    
}

@end

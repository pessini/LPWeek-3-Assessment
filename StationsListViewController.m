//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "DivvyStation.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface StationsListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *stationsArray;
@property NSMutableArray *searchStationNames;
@property DivvyStation *stations;
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;

@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // CLLocationManager
    [self loadUserLocation];

    // Search Bar
    self.searchBar.delegate = self;

    // initialize DivvyStation class
    self.stations = [DivvyStation new];
    self.stationsArray = [NSMutableArray new];
    
    // get data from DivvyStation Class and put in stationsArray
    // and searchStationNames
    self.stationsArray = [DivvyStation divvyStationsArray];
    self.searchStationNames = [[NSMutableArray alloc] initWithArray:self.stationsArray];
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stationsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    DivvyStation *station = [self.stationsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = station.stationName;

    if (station.stationDistance)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Available bikes: %@ - %.2f m", station.availableBikes, station.stationDistance];
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Available bikes: %@", station.availableBikes];
    }
    return cell;
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 0)
    {
        [self.stationsArray removeAllObjects];

        for (DivvyStation *stations in self.searchStationNames)
        {
            if ([[stations.stationName uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound)
            {
                [self.stationsArray addObject:stations];

            }
        }

        [self.tableView reloadData];
    }
    else
    {
        self.stationsArray = [NSMutableArray arrayWithArray:self.searchStationNames];
        [self.tableView reloadData];
    }
}

#pragma mark - LocationManager

- (void)loadUserLocation
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Please check yoru settings to make sure you enabled sharing your location"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000)
        {
            // Location Found
            self.userLocation = location;
            [self findStationDistanceFromUser];
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}

-(void)findStationDistanceFromUser
{
    for (DivvyStation *station in self.stationsArray)
    {
        station.stationDistance = [station.stationLocation distanceFromLocation:self.userLocation];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"stationDistance" ascending:YES];
    NSArray *sorted = [self.stationsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.stationsArray = [NSMutableArray arrayWithArray:sorted];
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"ToMapSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MapViewController *mapVC = segue.destinationViewController;
        DivvyStation *station = [self.stationsArray objectAtIndex:indexPath.row];

        mapVC.divvyStation = station;
    }
}

@end

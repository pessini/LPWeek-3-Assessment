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

@interface StationsListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *stationsArray;
@property NSMutableArray *searchStationNames;
@property DivvyStation *stations;

@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Search Bar
    self.searchBar.delegate = self;

    // get data from DivvyStation Class
    self.stationsArray = [DivvyStation divvyStationsArray];
    self.stations = [DivvyStation new];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Available bikes: %@", station.availableBikes];
    return cell;
}

#pragma mark - Search Bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 0)
    {
        [self.stations searchWithKeyword:searchText withCompletionHandler:^(NSMutableArray *searchArray) {
            self.stationsArray = searchArray;
            [self.tableView reloadData];
        }];
    }
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

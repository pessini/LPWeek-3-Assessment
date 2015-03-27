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

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *stationsArray;

@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // get data from DivvyStation Class
    self.stationsArray = [DivvyStation divvyStationsArray];

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

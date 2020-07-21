//
//  SearchViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/14/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "SearchViewController.h"
#import "TripViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationCell.h"
#import "APIUtility.h"
#import "AlertUtility.h"
#import "Location.h"
#import "Key.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapViewParent;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) GMSMapView *mapView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.locationsTableView.delegate = self;
    self.locationsTableView.dataSource = self;
    
    // get location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager startUpdatingLocation];
    
    // add Map
    [self loadMapView];
}

- (void)loadMapView {
    // add map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 37.0902
                                                            longitude: -95.7129
                                                                 zoom: 5.0];
    CGRect parentFrame = self.mapViewParent.frame;
    CGRect frame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);
    self.mapView = [GMSMapView mapWithFrame:frame camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.mapViewParent addSubview:self.mapView];
}

- (void)getRequest {
    [APIUtility getPlaces:self.searchTerm withCompletion: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *unfiltered = [dataDictionary valueForKeyPath:@"results"];
            // filter locations that are not operational
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"business_status == [c] %@", @"OPERATIONAL"];
            self.locations = [unfiltered filteredArrayUsingPredicate:pred];
            [self.locationsTableView reloadData];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status != kCLAuthorizationStatusDenied) {
        [self.locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    GMSCameraUpdate *newCamera = [GMSCameraUpdate setCamera:[GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:16.0]];
    [self.mapView moveCamera:newCamera];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Getting Location" action:@"Cancel" message:error.localizedDescription];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [self.locationsTableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    Location *place = [[Location alloc] initWithPlace: self.locations[indexPath.row]];
    cell = [cell setCell:place];
    return cell;
}

// set search term when value changes
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        self.searchTerm = searchText;
    }
    
}

// show cancel button on type
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// removed text and hide keyboard on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

// fetch results when search button is clicked
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getRequest];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"creationSegue"]) {
        TripViewController *destinationViewController = [segue destinationViewController];
        LocationCell *tappedCell = sender;
        // get location of tapped cell
        destinationViewController.place = tappedCell.place;
    }
}

@end

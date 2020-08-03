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
#import "ReviewsTableViewUtility.h"
#import "LocationCell.h"
#import "APIUtility.h"
#import "AlertUtility.h"
#import "Location.h"
#import "Key.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapViewParent;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) GMSMapView *mapView;
@property (nonatomic, strong) Location *selectedPlace;
@property (nonatomic, strong) ReviewsTableViewUtility *reviewsUtility;
@property (nonatomic, strong) CLLocation *location;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.locationsTableView.delegate = self;
    self.locationsTableView.dataSource = self;
    self.locationsTableView.alpha = 0.0;
    
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
    self.mapView.delegate = self;
    [self.mapViewParent insertSubview:self.mapView atIndex:0];
}

- (void)getRequest {
    [APIUtility getPlaces:self.searchTerm withCompletion: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Retrieving Search" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
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

// respond when user allows/denies location access
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status != kCLAuthorizationStatusDenied) {
        [self.locationManager requestLocation];
    }
}

// move camera when user's location is updated
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.location = [locations lastObject];
    CLLocationDegrees latitude = self.location.coordinate.latitude;
    CLLocationDegrees longitude = self.location.coordinate.longitude;
    GMSCameraUpdate *newCamera = [GMSCameraUpdate setCamera:[GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:16.0]];
    [self.mapView moveCamera:newCamera];
    [self.locationManager stopUpdatingLocation];
}

// show alert if location manager fails
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Getting Location" action:@"Cancel" message:error.localizedDescription];
    [self presentViewController:alert animated:YES completion:nil];
}

// get POI details and allow user to create trip when POI is tapped
- (void)mapView:(GMSMapView *)mapView didTapPOIWithPlaceID:(NSString *)placeID name:(NSString *)name location:(CLLocationCoordinate2D)location {
    // get place details
    [APIUtility getPlaceDetails:placeID fields:@"name,rating,formatted_address,photos,place_id,price_level,reviews" withCompletion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Retrieving Details" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *details = [dataDictionary valueForKeyPath:@"result"];
            self.selectedPlace = [[Location alloc] initWithPlace:details location:location];
            [self showDetails:self.selectedPlace];
        }
    }];
}

// show view with location details at the bottom of the screen
- (void)showDetails:(Location *)place {
    // animate show view
    if (self.detailView.hidden) {
        [self.detailView setHidden:NO];
        self.detailView.frame = CGRectMake(0, self.mapViewParent.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
        [UIView animateWithDuration:0.25 animations:^{
            self.detailView.frame = CGRectMake(0, self.mapViewParent.frame.size.height - 300, self.detailView.frame.size.width, self.detailView.frame.size.height);
        }];
    }
    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address;
    self.ratingLabel.text = place.rating;
    self.priceLabel.text = [@"" stringByPaddingToLength:place.priceLevel withString:@"$" startingAtIndex:0];
    self.reviewsUtility = [[ReviewsTableViewUtility alloc] initWithReviews:place.reviews];
    self.reviewsTableView.delegate = self.reviewsUtility;
    self.reviewsTableView.dataSource = self.reviewsUtility;
    [self.reviewsTableView reloadData];
}

// open selected POI in maps
- (IBAction)onOpenMap:(id)sender {
    // try Google Maps
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *queryString = [NSString stringWithFormat:@"comgooglemaps://?daddr=%@&zoom=15&q=%@",self.selectedPlace.address,self.selectedPlace.name];
        NSString *urlString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
            if(success == NO) {
                UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error opening map" action:@"Cancel" message:@"There was an unexpected error while trying to open Google Maps"];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    // try Apple maps
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]) {
        NSString *queryString = [NSString stringWithFormat:@"http://maps.apple.com/?address=%@&q=%@",self.selectedPlace.address,self.selectedPlace.name];
        NSString *urlString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
            if(success == NO) {
                UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error opening map" action:@"Cancel" message:@"There was an unexpected error while trying to open Maps"];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    // no maps available
    else {
        UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Map unavailable" action:@"Cancel" message:@"Can't access maps"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// segue to creation view controller
- (IBAction)onCreateTrip:(id)sender {
    [APIUtility getPhoto:self.selectedPlace.photosArray[0][@"photo_reference"] withCompletion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Creating Trip" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];;
        }
        else {
            self.selectedPlace.photoData = data;
            [self performSegueWithIdentifier:@"mapSegue" sender:self.selectedPlace];
        }
    }];
}

// hide details view
- (IBAction)onClose:(id)sender {
    [self.detailView setHidden:YES];
}

// add an info window marker to the POI
- (void)createMarker:(Location *)place {
    // Declare a GMSMarker instance at the class level.
    GMSMarker *infoMarker;
    infoMarker = [GMSMarker markerWithPosition:place.location];
    infoMarker.snippet = place.placeId;
    infoMarker.title = place.name;
    infoMarker.opacity = 0;
    CGPoint pos = infoMarker.infoWindowAnchor;
    pos.y = 1;
    infoMarker.infoWindowAnchor = pos;
    infoMarker.map = self.mapView;
    self.mapView.selectedMarker = infoMarker;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [self.locationsTableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    NSDictionary *locationData = self.locations[indexPath.row];
    NSNumber *latitude = locationData[@"geometry"][@"location"][@"lat"];
    NSNumber *longitude = locationData[@"geometry"][@"location"][@"lng"];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    Location *place = [[Location alloc] initWithPlace: locationData location:location];
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
    [self.mapViewParent setHidden:YES];

    // show table view with list of recommended places
    // get nearby places from api
    [APIUtility getRecommendations:self.location.coordinate.latitude longitude:self.location.coordinate.longitude withCompletion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error == nil) {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *unfiltered = [dataDictionary valueForKeyPath:@"results"];
            // filter locations that are not operational
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"business_status == [c] %@", @"OPERATIONAL"];
            self.locations = [unfiltered filteredArrayUsingPredicate:pred];
            [self.locationsTableView reloadData];
            self.locationsTableView.alpha = 1.0;
        }
        else {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Loading Places" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

// removed text and hide keyboard on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.mapViewParent setHidden:NO];
    self.locationsTableView.alpha = 0.0;
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
    else if([segue.identifier isEqualToString:@"mapSegue"]) {
        TripViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.place = sender;
    }
}

@end

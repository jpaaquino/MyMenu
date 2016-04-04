//
//  mapViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-02.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "mapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>



@interface mapViewController () <MKMapViewDelegate, CLLocationManagerDelegate,theDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL didZoom;
@property NSMutableArray *restaurantArray;


@end
@implementation mapViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(self.restaurantArray.count == 0){
    self.restaurantArray = @[].mutableCopy;
    }
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation=YES;
    
    [self setupLocationManager];
    
    // [self geocodeAnAddress];
    NSURL *url = [NSURL URLWithString:@"https://api.yelp.com/v2/search?term=german+food&location=Hayes&cll=43.644645043,-79.3949990"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // The completion handler is code that will run when the request is completed
        if (!error) {
            
            NSError *jsonError;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *restaurantsArray = jsonObject[@"id"];//create an array with json objects that should be converted to obj-c objects
            //NSLog(@"%@",restaurantsArray);
            if (!jsonError) {
                // NSMutableArray *titlesArray = [NSMutableArray array];
                for (NSDictionary *movieDict in restaurantsArray) {//iterate thru moviesArray
                    Restaurants *restaurant = [[Restaurants alloc] init];
                    
                    restaurant.name = movieDict[@"name"];
                    //[self.theArray addObject:movie];
                }
                
                
                // tell table to reload in main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    //[self.collectionView reloadData];
                });
                
            }
            
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
        
    }];
    
    // Call resume on the task to start it
    [dataTask resume];

}
-(IBAction)dropPinAction:(id)sender{
    
    [self addCurrentLocationAnnotation];

    }


- (void)setupLocationManager {
    // Create it and set it's delegate to our self.
    // The location manager uses the delegate extensively to relay location
    // information to it.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Generally here you'll want to configure your location manager more.
    // Remember to keep things efficient to optimize batter life. Here are some examples:
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //self.locationManager.distanceFilter = 50;
    
    // Location services requires user permission.
    // Remember to add the appropriate keys/values to your Info.plist:
    // NSLocationWhenInUseUsageDescription and/or NSLocationAlwaysUsageDescription
    // The value for those keys is a String explaning why you want those capabilities
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}
#pragma mark- CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // This gets called when the user provides location services permission.
    
    // If they give permission, start tracking the user's location
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // This gets called when the location manager determines the the user's location has changed.
    // The `locations` array holds at least one location object. If there are multiple they are
    // ordered in oldest to newest.
    
    // We use this flag to only zoom to the user's location the first time,
    // not every time their location changes.
    if (self.didZoom) {
        return;
    }
    //NSError *error = nil;
    
    // Get the latest location, create a map region and zoom the map view to show it.
    CLLocation *location = [locations lastObject];
    //NSLog(@"latitude: %f - longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            // handle error
        } else {
               }
        
    }];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
   
    
    [self.mapView setRegion:region animated:YES];
    
    // We could stop tracking the user's location now if wanted
    //    [self.locationManager stopUpdatingLocation];
    
    // Don't zoom to their location after this.
    self.didZoom = YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
       if ([[segue identifier] isEqualToString:@"toDetail"]) {
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        controller.delegate = self;
    }
    
}


- (void)addCurrentLocationAnnotation {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
   // CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(43.644645043,-79.3949990);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    annotation.coordinate = coordinate;
    annotation.title = @"The current Location";
       [self.mapView addAnnotation:annotation];

   }
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = infoButton;
    
    return annotationView;
}
- (void)createNewEntry:(Restaurants *)restaurant{
    [self.restaurantArray addObject:restaurant]; //add the restaurant object we are receiving to the array
    NSLog(@"Restaurants array:%lu entries",(unsigned long)self.restaurantArray.count);//logs num
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"toDetail" sender:self];

}

@end

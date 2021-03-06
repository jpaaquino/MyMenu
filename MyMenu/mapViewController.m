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
@property NSArray *restaurantArray;

@property (nonatomic) Restaurants *selectedRestaurant;


@end
@implementation mapViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    if(self.restaurantArray.count == 0){
    self.restaurantArray = @[].mutableCopy;
       // self.restaurantArray = [[NSMutableArray alloc]init];

    }
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation=YES;
    
    [self setupLocationManager];
   // [self addRestaurantsToView];


    
    // [self geocodeAnAddress];
  
}
-(void)calculateAvgStars{

   }
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = YES;

    //NSLog(@"VDA RA:%lu entries",(unsigned long)self.restaurantArray.count);//logs num
    [self addRestaurantsToView];

}
-(IBAction)dropPinAction:(id)sender{
    

    [self addCurrentLocationAnnotation];

    }

//- (IBAction)deleteRestaurant:(id)sender {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    [context deleteObject:self.selectedRestaurant];
//    
//    NSError * error = nil;
//    if (![context save:&error])
//    {
//        NSLog(@"Error ! %@", error);
//    }
//    
//    [self addRestaurantsToView];
// 
//}

-(void)addRestaurantsToView{
    
    for (id <MKAnnotation>  myAnnot in [self.mapView annotations])
    {
        if (![myAnnot isKindOfClass:[MKUserLocation class]])
        {
            [self.mapView removeAnnotation:myAnnot];
        }
        
    }

    // Loop over our stations array to create, configure and add the annotation to the map view
    AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Restaurants"];//gets all data from Entity

    self.restaurantArray = [del.managedObjectContext executeFetchRequest:req error:nil];
    
    
    for (Restaurants *restaurant in self.restaurantArray) {
        int nVisits = (int)restaurant.toVisits.count;
        //NSLog(@"%@ %i",restaurant.name, nVisits);
        float totalStars = 0;
        for (Visits *aVisit in restaurant.toVisits){
            totalStars = totalStars + aVisit.stars.floatValue;
            
        }
        restaurant.avgStars = @(totalStars/nVisits);
        
        NSError * error = nil;
        if (![del.managedObjectContext save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
    }

    //NSLog(@"%lu",(unsigned long)self.restaurantArray.count);
    [self.mapView addAnnotations:self.restaurantArray];
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
   // CLLocationCoordinate2D bullseyeCoordinate = self.mapView.centerCoordinate;
   // UIImageView *bullseyeImageView = [[UIImageView alloc]init];
    UIImageView *bullseyeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullseye.png"]];
    CGSize size = self.mapView.frame.size;
   // [bullseyeImageView setCenter:CGPointMake(size.width/2, size.height/2)];
    [bullseyeImageView setFrame:CGRectMake(size.width/2-7.5, size.height/2+8, 15, 15)];
    [self.mapView addSubview:bullseyeImageView];






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
    //CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;

    //MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03,0.03);

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
        controller.pinLatitude = self.currentPinLat;
        controller.pinLongitude = self.currentPinLong;
       }
    if ([[segue identifier] isEqualToString:@"toTableView"]) {
          PreviousVisitsViewController *controller = (PreviousVisitsViewController *)[segue destinationViewController];
        //Restaurants *restaurantTapped =  view.annotation;
        
        if (controller) {
            controller.restaurant = self.selectedRestaurant;
        }

        //controller.delegate = self;

    }

}


- (void)addCurrentLocationAnnotation {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
    
    
    annotation.coordinate = coordinate;

    self.currentPinLat = [NSNumber numberWithDouble:annotation.coordinate.latitude];
    self.currentPinLong = [NSNumber numberWithDouble:annotation.coordinate.longitude];
    
    if(annotation.title == nil){
        annotation.title = @"Click to add restaurant";
    }
    [self addRestaurantsToView];

    [self.mapView addAnnotation:annotation];
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    //annotationView.draggable = YES;
    annotationView.canShowCallout = YES;
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    annotationView.rightCalloutAccessoryView = infoButton;
    
    

    return annotationView;
}
- (void)createNewEntry:(Restaurants *)restaurant{
    //[self.restaurantArray addObject:restaurant]; //add the restaurant object we are receiving to the array
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Restaurants"];//gets all data from Entity
    self.restaurantArray = [del.managedObjectContext executeFetchRequest:req error:nil];

    if ([view.annotation isKindOfClass:[MKPointAnnotation class]]) {
        [self performSegueWithIdentifier:@"toDetail" sender:self];
    } else {
        //self.currentRestaurant =  view.annotation;

        self.selectedRestaurant = (Restaurants *) view.annotation;
        [self performSegueWithIdentifier:@"toTableView" sender:self];
        
     
        

        
//        if(self.selectedRestaurant.toVisits.count == 0){
//            [self performSegueWithIdentifier:@"toDetail" sender:self];
//        }else{
//
//        [self performSegueWithIdentifier:@"toTableView" sender:self];
//        }
        
    }
}

@end

//
//  Restaurants.m
//  
//
//  Created by Joao Paulo Aquino on 2016-04-05.
//
//

#import "Restaurants.h"
#import "Visits.h"

@implementation Restaurants

// Insert code here to add functionality to your managed object subclass

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title {
    return self.name;
}

@end

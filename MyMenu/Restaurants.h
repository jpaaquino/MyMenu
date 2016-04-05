//
//  Restaurants.h
//  
//
//  Created by Joao Paulo Aquino on 2016-04-05.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class Visits;

NS_ASSUME_NONNULL_BEGIN

@interface Restaurants : NSManagedObject <MKAnnotation>

- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Restaurants+CoreDataProperties.h"

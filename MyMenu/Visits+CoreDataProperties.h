//
//  Visits+CoreDataProperties.h
//  
//
//  Created by Joao Paulo Aquino on 2016-04-05.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Visits.h"

NS_ASSUME_NONNULL_BEGIN

@interface Visits (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *theDescription;
@property (nullable, nonatomic, retain) NSNumber *stars;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) Restaurants *toRestaurant;

@end

NS_ASSUME_NONNULL_END

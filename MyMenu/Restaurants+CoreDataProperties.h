//
//  Restaurants+CoreDataProperties.h
//  
//
//  Created by Joao Paulo Aquino on 2016-04-05.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Restaurants.h"

NS_ASSUME_NONNULL_BEGIN

@interface Restaurants (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *avgStars;
@property (nullable, nonatomic, retain) NSSet<Visits *> *toVisits;

@end

@interface Restaurants (CoreDataGeneratedAccessors)

- (void)addToVisitsObject:(Visits *)value;
- (void)removeToVisitsObject:(Visits *)value;
- (void)addToVisits:(NSSet<Visits *> *)values;
- (void)removeToVisits:(NSSet<Visits *> *)values;

@end

NS_ASSUME_NONNULL_END

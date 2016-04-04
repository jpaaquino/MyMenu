//
//  DetailViewController.h
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-03.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurants.h"
#import "AXRatingView.h"
#import "Visits.h"


@protocol theDelegate <NSObject>
- (void)createNewEntry:(Restaurants *)restaurant;
@end


@interface DetailViewController : UIViewController

- (IBAction)saveAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *restaurantTextField;

@property int numberOfRatings;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) id<theDelegate> delegate;

@property (strong, nonatomic) NSNumber *pinLongitude;
@property (strong, nonatomic) NSNumber *pinLatitude;
@property (weak, nonatomic) IBOutlet UIDatePicker *theDatePicker;


- (IBAction)HideKeyboard:(id)sender;


@end

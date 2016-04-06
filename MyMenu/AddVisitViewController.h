//
//  AddVisitViewController.h
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-06.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurants.h"
#import "BTRatingView.h"


@interface AddVisitViewController : UIViewController

@property (nonatomic, retain) Restaurants *currentRestaurant;

@property (weak, nonatomic) IBOutlet UITextField *restaurantTextField;

@property (weak, nonatomic) IBOutlet BTRatingView *ratingView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)saveAction:(id)sender;
- (IBAction)HideKeyboard:(id)sender;

@end

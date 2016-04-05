//
//  mapViewController.h
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-02.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurants.h"
#import "DetailViewController.h"
#import "ViewController.h"



@interface mapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *theSearchBar;

@property (strong, nonatomic) NSNumber *currentPinLat;
@property (strong, nonatomic) NSNumber *currentPinLong;
//@property (nonatomic, retain) Restaurants *currentRestaurant;


-(IBAction)dropPinAction:(id)sender;

@end

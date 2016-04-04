//
//  DetailViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-03.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
    Restaurants *newRestaurant = [[Restaurants alloc]init];
    newRestaurant.name = self.restaurantTextField.text;
    newRestaurant.theDescription = self.descriptionTextView.text;
    newRestaurant.longitude = self.pinLongitude;
    newRestaurant.latitude = self.pinLatitude;
    [self.delegate createNewEntry:newRestaurant];
    [self.navigationController popViewControllerAnimated:YES];


}

- (IBAction)HideKeyboard:(id)sender {
    [sender resignFirstResponder];
    
}


@end

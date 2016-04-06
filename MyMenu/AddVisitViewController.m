//
//  AddVisitViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-06.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "AddVisitViewController.h"
#import "AppDelegate.h"

@interface AddVisitViewController ()<BTRatingViewDelegate>

@end

@implementation AddVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addStarsView];
    self.restaurantTextField.text = [NSString stringWithFormat:@"%@",self.currentRestaurant.name];
}
-(void)addStarsView{
    self.ratingView.delegate = self;
    self.ratingView.emptyStarImage = [UIImage imageNamed:@"staroff.png"];
    self.ratingView.fullStarImage = [UIImage imageNamed:@"shinystar.png"];
    self.ratingView.editable = YES;
    self.ratingView.maxRating = 5;
    self.ratingView.rating = 5;
    
}
- (void)ratingView:(BTRatingView *)ratingView ratingDidChange:(float)rating
{
    NSLog(@"RatingDidChange: %f",rating);
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
    NSManagedObjectContext* context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]). managedObjectContext;
    
    
    NSManagedObject *newVisit = [NSEntityDescription insertNewObjectForEntityForName:@"Visits" inManagedObjectContext:context];
    
    [newVisit setValue:self.datePicker.date forKey:@"date"];
    [newVisit setValue:@(self.ratingView.rating) forKey:@"stars"];
    [newVisit setValue:self.descriptionTextView.text forKey:@"theDescription"];
    [newVisit setValue:self.restaurantTextField.text forKey:@"name"];
    
    
    [self.currentRestaurant setValue:[NSSet setWithObject:newVisit] forKey:@"toVisits"];
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)HideKeyboard:(id)sender {
    [sender resignFirstResponder];
    
}

@end

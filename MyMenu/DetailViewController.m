//
//  DetailViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-03.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "DetailViewController.h"
#import "BTRatingView.h"


@interface DetailViewController ()<BTRatingViewDelegate>
@property (nonatomic, strong) IBOutlet BTRatingView *ratingView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.ratingView.delegate = self;
    self.ratingView.emptyStarImage = [UIImage imageNamed:@"staroff.png"];
    self.ratingView.fullStarImage = [UIImage imageNamed:@"shinystar.png"];
    self.ratingView.editable = YES;
    self.ratingView.maxRating = 5;
    self.ratingView.rating = 5;
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"visitArray %lu",(unsigned long)self.visitsArray.count);

    if ([[segue identifier] isEqualToString:@"toTableView"]) {
        PreviousVisitsViewController *controller = (PreviousVisitsViewController *)[segue destinationViewController];
        controller.objects = self.visitsArray;
    }
    
}

- (void)ratingView:(BTRatingView *)ratingView ratingDidChange:(float)rating
{
    NSLog(@"RatingDidChange: %f",rating);
}

- (IBAction)saveAction:(id)sender {
    Restaurants *newRestaurant = [[Restaurants alloc]init];
    Visits *visit = [[Visits alloc]init];
    visit.theDescription = self.descriptionTextView.text;
    visit.stars = @(self.ratingView.rating);
    visit.date = self.theDatePicker.date;
    NSLog(@"D:%@ S:%@, D:%@",visit.theDescription,visit.stars,visit.date);

    newRestaurant.name = self.restaurantTextField.text;
    //newRestaurant.theDescription = self.descriptionTextView.text;
    newRestaurant.longitude = self.pinLongitude;
    newRestaurant.latitude = self.pinLatitude;
    [self.delegate createNewEntry:newRestaurant];
    [self.navigationController popViewControllerAnimated:YES];


}

- (IBAction)HideKeyboard:(id)sender {
    [sender resignFirstResponder];
    
}


@end

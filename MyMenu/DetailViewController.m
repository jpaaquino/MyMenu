//
//  DetailViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-03.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "DetailViewController.h"
#import "BTRatingView.h"
#import "Restaurants.h"
#import "Visits.h"
#import "AppDelegate.h"




@interface DetailViewController ()<BTRatingViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet BTRatingView *ratingView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurantTextField.backgroundColor = [UIColor whiteColor];

    [self registerForKeyboardNotifications];

    [self addStarsView];
   
    
    // Do any additional setup after loading the view.
}
-(void)addStarsView{
    self.ratingView.delegate = self;
    self.ratingView.emptyStarImage = [UIImage imageNamed:@"staroff.png"];
    self.ratingView.fullStarImage = [UIImage imageNamed:@"shinystar.png"];
    self.ratingView.editable = YES;
    self.ratingView.maxRating = 5;
    self.ratingView.rating = 5;

}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(self.descriptionTextView.isFirstResponder){
    [self.dismissKbButton setHidden:NO];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.7 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
    }
     ];
    }
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.view.transform = CGAffineTransformIdentity;
    
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
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"visitArray %lu",(unsigned long)self.visitsArray.count);
//
//    if ([[segue identifier] isEqualToString:@"toTableView"]) {
//        PreviousVisitsViewController *controller = (PreviousVisitsViewController *)[segue destinationViewController];
//        //controller.objects = self.visitsArray;
//    }
//    
//}

- (void)ratingView:(BTRatingView *)ratingView ratingDidChange:(float)rating
{
    NSLog(@"RatingDidChange: %f",rating);
}

- (IBAction)saveAction:(id)sender {
    
        
    NSManagedObjectContext* context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]). managedObjectContext;

    NSManagedObject *newRestaurant = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurants" inManagedObjectContext:context];

    [newRestaurant setValue:self.restaurantTextField.text forKey:@"name"];
    [newRestaurant setValue:self.pinLongitude forKey:@"longitude"];
    [newRestaurant setValue:self.pinLatitude forKey:@"latitude"];
    
    NSManagedObject *newVisit = [NSEntityDescription insertNewObjectForEntityForName:@"Visits" inManagedObjectContext:context];
    
    [newVisit setValue:self.theDatePicker.date forKey:@"date"];
    [newVisit setValue:@(self.ratingView.rating) forKey:@"stars"];
    [newVisit setValue:self.descriptionTextView.text forKey:@"theDescription"];
    [newVisit setValue:self.restaurantTextField.text forKey:@"name"];

    
    [newRestaurant setValue:[NSMutableSet setWithObject:newVisit] forKey:@"toVisits"];


    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    

}
//- (IBAction)saveAction:(id)sender {
//    Restaurants *newRestaurant = [[Restaurants alloc]init];
//    Visits *visit = [[Visits alloc]init];
//    visit.theDescription = self.descriptionTextView.text;
//    visit.stars = @(self.ratingView.rating);
//    visit.date = self.theDatePicker.date;
//    NSLog(@"D:%@ S:%@, D:%@",visit.theDescription,visit.stars,visit.date);
//    
//    newRestaurant.name = self.restaurantTextField.text;
//    newRestaurant.longitude = self.pinLongitude;
//    newRestaurant.latitude = self.pinLatitude;
//    [self.delegate createNewEntry:newRestaurant];
//    [self.navigationController popViewControllerAnimated:YES];
//    

//}


- (IBAction)HideKeyboard:(id)sender {
    [sender resignFirstResponder];
    
}

- (IBAction)dismissKb:(id)sender {
    [self.dismissKbButton setHidden:YES];
    [self.view endEditing:YES];

}


@end

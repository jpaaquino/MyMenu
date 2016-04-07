//
//  AddVisitViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-06.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "AddVisitViewController.h"
#import "AppDelegate.h"
#import "UIView+FormScroll.h"

@interface AddVisitViewController ()<BTRatingViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@end

@implementation AddVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dismissKbButton setHidden:YES];
    [self registerForKeyboardNotifications];
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
// Call this method somewhere in your view controller setup code.
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
    [self.dismissKbButton setHidden:NO];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.7 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
        
        
    }
     ];

}

//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    scrollView.the.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
//        [scrollView setContentOffset:scrollPoint animated:YES];
//    }


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.view.transform = CGAffineTransformIdentity;

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
    
    NSMutableSet *toVisits = [self.currentRestaurant valueForKey:@"toVisits"];
    [toVisits addObject:newVisit];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)HideKeyboard:(id)sender {
    [sender resignFirstResponder];
    
}

- (IBAction)dismissKb:(id)sender {
    [self.dismissKbButton setHidden:YES];
    [self.view endEditing:YES];
}

@end

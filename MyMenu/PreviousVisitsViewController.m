//
//  PreviousVisitsViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-04.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "PreviousVisitsViewController.h"

@interface PreviousVisitsViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray<Visits*>* allVisits;



@end

@implementation PreviousVisitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 73;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.navigationController.toolbarHidden = NO;
    

    
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewVisit)];
        self.navigationItem.rightBarButtonItem = addButton;
       self.navigationItem.title = self.restaurant.name;


    
    [self fetchVisits];
   // NSLog(@"Visits count %lu",self.restaurant.toVisits.count);
   // NSLog(@"AllVisits count %lu",(unsigned long)self.allVisits.count);

    
        // Do any additional setup after loading the view.
    if(self.allVisits == nil){
    self.allVisits = @[].mutableCopy;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}
-(void)insertNewVisit{
    [self performSegueWithIdentifier:@"toAddVisit" sender:self];
   
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toAddVisit"]) {
        AddVisitViewController *controller = (AddVisitViewController *)[segue destinationViewController];
        controller.currentRestaurant = self.restaurant;
    }
    
}
-(void)callAlertController{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Are you sure you want to delete this restaurant?"
                                          message:@"The entire restaurant will be deleted from the app, not just one visit!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NO", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"YES", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteRestaurant];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchVisits];
    [self.tableView reloadData];
  
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchVisits  {
    AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Visits"];//gets all data from Entity
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];//sort ToDOItem properties by title ascending
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", self.restaurant.name];
    req.predicate = predicate;
    //self.allVisits = [del.managedObjectContext executeFetchRequest:req error:nil];
//    self.allVisits = [self.restaurant.toVisits allObjects];

    self.allVisits = [del.managedObjectContext executeFetchRequest:req error:nil].mutableCopy;
    //NSLog(@"self.allVisits = %@", self.allVisits);
    //NSLog(@"All visits count: %lu",(unsigned long)self.allVisits.count);
    NSError * error = nil;
    if (![del.managedObjectContext save:&error])
    {
        NSLog(@"Error ! %@", error);
    }


}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the delegate method that gets called when we selected a cell
    NSLog(@"Cell selected for section:%ld, row: %ld", (long)indexPath.section, (long)indexPath.row);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//Only 1 section in tableview
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allVisits.count;//The number of objects in array = number of rows in table
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get our object associated with the row
    Visits *visit = self.allVisits[indexPath.row];
    //Visits *theVisit = self.restaurant.toVisits;
    // Get a cell using our identifier
    visitCell *visitcell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Customize the cell
    
    if(indexPath.row % 2 == 0){
        visitcell.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.0];
    }else{
        visitcell.backgroundColor = [UIColor colorWithRed:0.996 green:0.996 blue:0.996 alpha:1.0];

    }
    visitcell.dateLabel = [visitcell viewWithTag:1];
    visitcell.descriptionLabel = [visitcell viewWithTag:2];
    visitcell.starsLabel = [visitcell viewWithTag:3];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    //[format setDateFormat:@"MMM dd, yyyy"];
    [format setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateString = [format stringFromDate:visit.date];
    
    visitcell.dateLabel.text = [NSString stringWithFormat:@"%@",dateString];

    //visitcell.dateLabel.text = [NSString stringWithFormat:@"%@",visit.date];

     visitcell.descriptionLabel.text = visit.theDescription;
    
    switch(visit.stars.intValue) {
        case 1:
            visitcell.starsLabel.text = @"⭐️";
            break;
            
        case 2:
            visitcell.starsLabel.text = @"⭐️⭐️";
            break;
        case 3:
            visitcell.starsLabel.text = @"⭐️⭐️⭐️";
            break;
        case 4:
            visitcell.starsLabel.text = @"⭐️⭐️⭐️⭐️";
            break;
        case 5:
            visitcell.starsLabel.text = @"⭐️⭐️⭐️⭐️⭐️";
            break;

        default:
            visitcell.starsLabel.text = @"⭐️⭐️⭐️⭐️⭐️";
       }
    
    //visitcell.starsLabel.text = [NSString stringWithFormat:@"%@ ⭐️",visit.stars ];
    //[visitcell updateConstraintsIfNeeded];

//    [visitcell.contentView setNeedsLayout];
//    [visitcell.contentView layoutIfNeeded];

    
      return visitcell;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
        return NO;
    }

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.restaurant.name;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    if(sourceIndexPath == destinationIndexPath)
//    {
//        return;
//    }
//    NSString *stringToMove = [self.objects objectAtIndex:sourceIndexPath.row];
//    [self.objects removeObjectAtIndex:sourceIndexPath.row];
//    [self.objects insertObject:stringToMove atIndex:destinationIndexPath.row];
//}
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    if (proposedDestinationIndexPath.section != sourceIndexPath.section)
//    {
//        return sourceIndexPath;
//    }
//    
//    return proposedDestinationIndexPath;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext* context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]). managedObjectContext;

        Visits *toDelete = self.allVisits[indexPath.row];
        [toDelete.managedObjectContext deleteObject:toDelete];
        [toDelete.managedObjectContext save:nil];
        [self.allVisits removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *error = nil;//save
        if (![context save:&error]) {
            NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
        }

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (IBAction)deleteRestaurantButton:(id)sender {
    [self callAlertController];
    
}
-(void)deleteRestaurant{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [context deleteObject:self.restaurant];
    NSError *error = nil;//save
    if (![context save:&error]) {
        NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end


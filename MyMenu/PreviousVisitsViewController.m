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



@end

@implementation PreviousVisitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.objects == nil){
    self.objects = @[].mutableCopy;
    }
    NSLog(@"%lu",(unsigned long)self.objects.count);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

    
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the delegate method that gets called when we selected a cell
    NSLog(@"Cell selected for section:%ld, row: %ld", indexPath.section, indexPath.row);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//Only 1 section in tableview
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;//The number of objects in array = number of rows in table
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get our object associated with the row
    Visits *visit = self.objects[indexPath.row];
    // Get a cell using our identifier
    visitCell *visitcell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Customize the cell
    if(indexPath.row % 2 == 0){
        visitcell.backgroundColor = [UIColor whiteColor];
    }else{
        visitcell.backgroundColor = [UIColor orangeColor];
    }
     visitcell.dateLabel.text = [NSString stringWithFormat:@"%@",visit.date];
     visitcell.descriptionLabel.text = visit.theDescription;
    
    
      return visitcell;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
        return NO;
    }

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
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end


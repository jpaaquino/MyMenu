//
//  ViewController.m
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-01.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong,nonatomic) NSMutableArray *restaurantArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"https://developers.zomato.com/api/v2.1/geocode?lat=43.644645043&lon=-79.3949990"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // The completion handler is code that will run when the request is completed
        if (!error) {
            
            NSError *jsonError;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            //NSArray *restaurantArray = [@[@"soco", @"taverna"] mutableCopy];
            NSArray *restaurantArray = [jsonObject[@"location"]mutableCopy];//create an array with json objects that should be converted to obj-c objects
            NSLog(@"%@",restaurantArray);
            if (!jsonError) {
                // NSMutableArray *titlesArray = [NSMutableArray array];
                for (NSDictionary *restDict in restaurantArray) {//iterate thru moviesArray
                    //Movies *movie = [[Movies alloc] init];
                    
                    NSString *restaurantName = restDict[@"name"];//find the values at title key
                    //NSString *cityName = restDict[@"city"];//find value at year key
                    [self.restaurantArray addObject:restaurantName];
                }
                
                
                // tell table to reload in main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[self.collectionView reloadData];
                });
                
            }
            
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
        
    }];
    
    // Call resume on the task to start it
    [dataTask resume];
    
//    self.collectionView.collectionViewLayout = self.theLayout;
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
    

        
}
                                      
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

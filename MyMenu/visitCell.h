//
//  visitCell.h
//  MyMenu
//
//  Created by Joao Paulo Aquino on 2016-04-04.
//  Copyright © 2016 Joao Paulo Aquino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface visitCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *starsView;


@end

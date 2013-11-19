//
//  MenuItemTableCell.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/15/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cost;

@end

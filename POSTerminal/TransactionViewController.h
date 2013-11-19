//
//  TransactionViewController.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/15/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface TransactionViewController : UIViewController  

//I won't actually be making these properties and such abstract, just following a tutorial for now and changing later.
@property (nonatomic) NSArray *arrayOfProducts; //abstract
@property (nonatomic) NSInteger numberOfProducts; //abstract
-(void) updateCell:(UICollectionViewCell *) cell usingProduct: (Product *) product; //abstract

@property (nonatomic, strong) NSArray *transactionItems; //Array of Items that have been rung in. It will be an array of NSDictionary

@end

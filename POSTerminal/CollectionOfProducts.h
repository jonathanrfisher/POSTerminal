//
//  CollectionOfProducts.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface CollectionOfProducts : NSObject

-(Product *) productAtIndexPath:(int)indexPathItem;

@end

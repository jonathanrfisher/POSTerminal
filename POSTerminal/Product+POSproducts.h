//
//  Product+POSproducts.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/14/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "Product.h"

@interface Product (POSproducts)

+ (Product *) productWithDictionary:(NSDictionary *) productDictionary
             inManagedObjectContext:(NSManagedObjectContext *) context;

@end

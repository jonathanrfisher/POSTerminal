//
//  Product+POSproducts.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/14/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "Product.h"

@interface Product (POSproducts)

//+ (Product *)productWithProductID: (int) productID
//                        withPrice: (double) price
//                         withName: (NSString *) name
//                         withType: (NSString *) type
//                  withDescription: (NSString *) productDescription;

+ (Product *) productWithDictionary:(NSDictionary *) productDictionary
             inManagedObjectContext:(NSManagedObjectContext *) context;

@end

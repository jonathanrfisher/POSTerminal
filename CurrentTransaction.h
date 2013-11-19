//
//  CurrentTransaction.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface CurrentTransaction : NSManagedObject

@property (nonatomic, retain) NSNumber * transactionID;
@property (nonatomic, retain) NSSet *listOfProducts;
@end

@interface CurrentTransaction (CoreDataGeneratedAccessors)

- (void)addListOfProductsObject:(Product *)value;
- (void)removeListOfProductsObject:(Product *)value;
- (void)addListOfProducts:(NSSet *)values;
- (void)removeListOfProducts:(NSSet *)values;

@end

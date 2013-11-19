//
//  Product.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurrentTransaction;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *transactionsIn;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addTransactionsInObject:(CurrentTransaction *)value;
- (void)removeTransactionsInObject:(CurrentTransaction *)value;
- (void)addTransactionsIn:(NSSet *)values;
- (void)removeTransactionsIn:(NSSet *)values;

@end

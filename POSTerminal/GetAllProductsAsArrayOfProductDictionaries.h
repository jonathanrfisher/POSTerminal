//
//  GetAllProductsAsArrayOfProductDictionaries.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAllProductsAsArrayOfProductDictionaries : NSObject

@property (nonatomic) NSMutableArray *products;

- (void)getProductsFromCoreData;


@end

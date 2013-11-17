//
//  CollectionOfProducts.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "CollectionOfProducts.h"
#import "GetAllProductsAsArrayOfProductDictionaries.h"

@interface CollectionOfProducts ()


@property (strong,nonatomic)  GetAllProductsAsArrayOfProductDictionaries *productsGetter;

@end

@implementation CollectionOfProducts

-(GetAllProductsAsArrayOfProductDictionaries *) productsGetter
{
    if(!_productsGetter)
    {
        _productsGetter = [[GetAllProductsAsArrayOfProductDictionaries alloc] init];
    }
    return _productsGetter;
}

-(Product *) productAtIndex:(int)indexPathItem
{
    //NSLog(@"The state of self.products inside productAtIndex: %@",[self.products description]);
    Product *product =[self.products objectAtIndex:indexPathItem];
    //NSLog(@"-(Product *) productAtIndex:(int)indexPathItem WAS CALLED with indexPathItem: %d\nPRODUCT: %@", indexPathItem, [product description]);
    return product;
}

-(void) buildArrayOfProducts
{
    //NSLog(@"Building Array of Products...");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProductsArray:) name:@"productsReady" object:nil];
    
    [self.productsGetter getProductsFromCoreData];    
}

-(void) getProductsArray: (NSNotification *) notification
{
    //NSLog(@"Products are ready, time to get them!");
    self.products = self.productsGetter.products;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"productsReadyForUpdateUI" object:nil];
}


@end

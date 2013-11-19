//
//  Product+POSproducts.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/14/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "Product+POSproducts.h"

@implementation Product (POSproducts)

- (NSString *) description
{
    NSString *returnString = @"Product with values:";
    
    returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"\nname: %@",self.name]];
    returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"\nprice: %@",self.price]];
    returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"\nproductDescription: %@",self.productDescription]];
    returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"\ntype: %@",self.type]];
    returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"\nproductID: %@",self.productID]];
    
    return returnString;
}

+ (Product *)productWithDictionary:(NSDictionary *)productDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    
    Product *product = nil;
    
    NSLog(@"productDictionary: %@",[productDictionary description]);
    
    //We need to query the DB to see if our product is already in there
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    //<<<<<<<<<==================================>>>>>>>>>>>>>
    //Need to figure out exactly what is going on here
    //I understand it now,
    //the sortDescriptors tells the request how to sort the fetched items
    //the predicate adds parameters to our query
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"productID = %@",[productDictionary objectForKey:@"productID"]];
    //<<<<<<<<<==================================>>>>>>>>>>>>>>
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1)
    {
        //handle error
        NSLog(@"(!matches || [matches count] > 1)");
    }
    else //if ([matches count])
    {
        NSLog(@" (![matches count])");
        //Creates a product using the context passed in
        product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
        
        //None of the product attributes are set yet.
        
        product.name = [productDictionary objectForKey:@"name"];
        product.price = [productDictionary objectForKey:@"price"];
        product.productDescription = [productDictionary objectForKey:@"productDescription"];
        product.type = [productDictionary objectForKey:@"type"];
        product.productID = [productDictionary objectForKey:@"productID"];
        
        //What is value for key path??? with dictionary???
    }
//    else
//    {
//        NSLog(@"product = [matches lastObject];");
//        product = [matches lastObject];
//    }
    
    return product;
}


@end

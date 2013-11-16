//
//  convertXMLtoJSON.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/7/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "convertXMLtoJSON.h"

@implementation convertXMLtoJSON


//EXAMPLE OF CREATING A JSON OBJECT
//NSArray *objects=[[NSArray alloc]initWithObjects:objects here,nil];
//NSArray *keys=[[NSArray alloc]initWithObjects:corresponding keys of objects,nil];
//NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
//NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

- (id) convertToJSON: (NSString *) inputString
{
//    NSString *jsonString = @"{\"ID\":{\"Content\":268,\"type\":\"text\"},\"ContractTemplateID\":{\"Content\":65,\"type\":\"text\"}}";
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    
//    
//    NSLog(@"%@",[json objectForKey:@"ID"]);
    
//    
   // inputString = [inputString stringByAppendingString:@"]"];
   // inputString = [@"[" stringByAppendingString:inputString];
    

    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //NSLog(@"%@",[json objectForKey:@"table0"]);
    
    //NSError *error = nil; // This so that we can access the error if something goes wrong
    //NSLog(@"inputString inside convertToJSON: %@",inputString);
    
   // NSData *responseData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"descript of responseData: %@ class of responseData: %@",[responseData description],[responseData class]);
    
//    NSData *JSONData = [NSJSONSerialization
//                        dataWithJSONObject:responseData
//                        // Converts data - i.e. NSString, NSArray, NSDictionary - into JSON
//                        options:0
//                        error:nil];
//    
//    id JSONObject = [NSJSONSerialization
//                     JSONObjectWithData:JSONData
//                     // Creates an Objective-C NSData object from JSON Data
//                     options:NSJSONReadingAllowFragments
//                     error:nil];
    
    //NSLog(@"Print out of our converted JSON: %@",[json description]);
    
    return json;
}

@end

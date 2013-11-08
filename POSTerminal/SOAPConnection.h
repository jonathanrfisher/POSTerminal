//
//  SOAPConnection.h
//  POSTerminal
//
//  Created by Katherine Fisher on 11/5/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SOAPConnection;

@protocol SOAPConnectionDelegate <NSObject>
//- (void) addItemViewController:(LoginViewController *)controller didFinishEnteringItem:(NSArray *)userData;
@end

@interface SOAPConnection : NSObject

@property (nonatomic) NSMutableData *resultData;

- (void) makeConnection: (NSURL *) inputURL
         withMethodType: (NSString *) methodType
             withParams: (NSDictionary *) params
        usingParamOrder: (NSArray *) paramOrder
         withSOAPAction: (NSString *) soapAction;

- (id) returnJSON;


@end

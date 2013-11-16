//
//  LoggingManagedDocument.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/15/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "LoggingManagedDocument.h"

@implementation LoggingManagedDocument

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSLog(@"Auto-Saving Document");
    return [super contentsForType:typeName error:outError];
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{
    NSLog(@"error: %@ userInfo: %@", error, error.userInfo);
}


@end

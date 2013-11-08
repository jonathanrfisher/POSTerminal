//
//  POSTerminal.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "POSTerminal.h"
#import "POSTerminalViewController.h"


//DataClass.m
@implementation POSTerminal

@synthesize str;

static POSTerminal *instance =nil;

+(POSTerminal *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [POSTerminal new];
        }
    }
    return instance;
}

@end

//@implementation POSTerminal
//
//+(POSTerminal *)getInstance
//{
//    @synchronized(self)
//    {
//        if(!instance)
//        {
//            
//            instance= [POSTerminal new];
//        }
//    }
//    return instance;
//}
//
//@end



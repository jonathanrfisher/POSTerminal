//
//  POSTerminal.h
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>
//DataClass.h

@interface POSTerminal : NSObject {
    
    NSString *str;
    
}
@property(nonatomic,retain)NSString *str;
+(POSTerminal*)getInstance;
@end

//@interface POSTerminal : NSObject
//
//
//
//
//@property (nonatomic) NSNumber *userID;
//@property (nonatomic, strong) NSString *userType;
//@property (nonatomic, strong) POSTerminal *instance;
//
//+(POSTerminal*)getInstance;
//
//
//@end


//@interface DataClass : NSObject {
//    
//    NSString *str;
//    
//}
//@property(nonatomic,retain)NSString *str;
//+(DataClass*)getInstance;
//@end  

//
//  CreditCardViewController.h
//  POSTerminal
//
//  Created by gypC on 11/12/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditCardViewController;

@interface CreditCardViewController : UIViewController
- (IBAction)submitBtn:(UIButton *)sender;
-(BOOL)validateInput;

@end

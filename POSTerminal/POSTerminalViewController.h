//
//  POSTerminalViewController.h
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class POSTerminalViewController;

@interface POSTerminalViewController : UIViewController <LoginViewControllerDelegate>

//- (void) PopulateMenuItems:(NSString *)itemsFilePathToReadFrom;
//- (void) UpdatePOS: (NSString *)itemsFilePathToWriteTo;
//- (NSString *) Login:(NSString *)userID;
//- (void) MenuTransition;
//- (void) BeginTransaction;
//- (void) VoidTransaction;
//- (void) Logout;
- (void) addItemViewController:(LoginViewController *)controller didFinishEnteringItem:(NSArray *)userData;
//- (IBAction)dataButtonPressed:(UIButton *)sender;

@end

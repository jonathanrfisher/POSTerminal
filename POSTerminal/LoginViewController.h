//
//  LoginViewController.h
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
- (void) addItemViewController:(LoginViewController *)controller didFinishEnteringItem:(NSDictionary *)userData;
@end


@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
- (void) getJSON:(NSNotification *) notification;

@end

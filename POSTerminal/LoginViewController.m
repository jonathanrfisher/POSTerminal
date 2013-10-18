//
//  LoginViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) NSArray *userData;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@implementation LoginViewController

@synthesize delegate;

- (void) returnUserData
{
    
    if ([self.delegate isKindOfClass:[UIViewController class]])
    {
        [self.delegate addItemViewController:self didFinishEnteringItem:self.userData];
    }
}


- (IBAction)digitPressed:(UIButton *)sender
{
    NSLog(@"Button: %@",[sender currentTitle]);
    
    
    NSString *labelString = self.idLabel.text;
    
    
    self.idLabel.text = [labelString stringByReplacingCharactersInRange:NSMakeRange(self.userID.length,1) withString:@"*"];
    
    
    if(self.userID.length == 4 && [self.userID isEqualToString:@"1234"])
    {
        self.userData = @[@"Sweet Ass Manager",@"Jonathan",@"Fisher"];
    }
}






@end

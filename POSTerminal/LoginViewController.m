//
//  LoginViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "LoginViewController.h"
#import "SOAPConnection.h"
#define URL @"http://jt.serveftp.net/Datacom/Server.asmx"

@interface LoginViewController ()

@property (nonatomic, strong) NSArray *userData;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) NSURL *url;

@end

@implementation LoginViewController



@synthesize delegate;

- (NSURL *) url
{
    if (!_url)
    {
        _url = [NSURL URLWithString:URL];
    }
    return _url;
}


//EXAMPLE OF CREATING A JSON OBJECT
//NSArray *objects=[[NSArray alloc]initWithObjects:objects here,nil];
//NSArray *keys=[[NSArray alloc]initWithObjects:corresponding keys of objects,nil];
//NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
//NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

- (void) returnUserData
{
    NSLog(@"Inside returnUserData method in LoginViewController.m");
    NSLog(@"self.delegate: %@",[self.delegate description]);
    NSLog(@"self.parentViewController: %@",self.parentViewController);
    NSLog(@"presentingViewController: %@",self.presentingViewController);
    
    if ([self.delegate isKindOfClass:[UIViewController class]])
    {
        //UIViewController<LoginViewControllerDelegate> *presenter = (id<LoginViewControllerDelegate>)self.presentingViewController;
        NSLog(@"Inside the returnUserData if statement...");
        NSLog(@"Contents of self.userData: %@",[self.userData description]);
        
        
        [self.delegate addItemViewController:self didFinishEnteringItem:self.userData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //[presenter addItemViewController:self didFinishEnteringItem:self.userData];
    }
}


- (IBAction)digitPressed:(UIButton *)sender
{
    if (!self.userID)
    {
        self.userID = @"";
    }
    NSString *labelString = self.idLabel.text;
    NSString *buttonTitleString = [sender currentTitle];
    
    
    NSLog(@"Button: %@",buttonTitleString);
    NSLog(@"self.userID.length: %d",self.userID.length);
    
    self.idLabel.text = [labelString stringByReplacingCharactersInRange:NSMakeRange(self.userID.length,1) withString:@"*"];
    
    self.userID = [self.userID stringByAppendingString:[sender currentTitle]];
    
    NSLog(@"self.userID.length: %d",self.userID.length);
    NSLog(@"self.userID: %@",self.userID);
    //NSLog(@"self.userID with \"testing\" appended to it: %@",[self.userID stringByAppendingString:@"testing"]);
    NSLog(@"self.userID isEqualToString:@\"1234\": %i",[self.userID isEqualToString:@"1234"]);
    
    if(self.userID.length == 4 && [self.userID isEqualToString:@"1234"])
    {
        self.userData = @[@"Sweet Ass Manager",@"Jonathan",@"Fisher"];
        NSLog(@"Inside the main if statment...");
        
        
        [self returnUserData];
        
        NSString *response = [self performUserValidation:self.userID];
        
        if (response)
        {
            //get the user data from the returned JSON
        }
        else
        {
            //Push the clear button
        }
    }
    else if(self.userID.length == 4)
    {
        self.userID = @"";
        self.idLabel.text = @"----";
    }
}

- (NSString *) performUserValidation:(NSString *)loginCode
{
    NSString *returnString = @"Base Return String";
    
    SOAPConnection *soap = [[SOAPConnection alloc] init];
    
    //This dictionary will eventually have just one number
    //NSDictionary *dict = @{@"Username" : loginCode,
    //                       @"Password" : loginCode,
    //                      };
    
    NSDictionary *dict = @{@"password" : [NSNumber numberWithInt:2546],
                           @"username" : [NSNumber numberWithInt:2546],
                           };
    
    NSArray *paramOrder = @[@"username",@"password"];
    
    [soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:dict usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
    
    return returnString;
}




@end

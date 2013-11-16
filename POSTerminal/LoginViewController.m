//
//  LoginViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "LoginViewController.h"
#import "SOAPConnection.h"
#import "POSTerminal.h"
#define URL @"http://jt.serveftp.net/Datacom/Server.asmx"

@interface LoginViewController ()

@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) NSURL *url;
@property (nonatomic) id JSONObject;
@property (nonatomic, strong) SOAPConnection *soap;
@property (nonatomic) NSString *returnString;

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *position;

@end

@implementation LoginViewController



@synthesize delegate;

- (void) viewDidAppear:(BOOL)animated
{
    self.userData = nil;
    self.userID = nil;
    self.idLabel.text = @"----";
    self.url = nil;
    self.JSONObject = nil;
    self.soap = nil;
    self.returnString = nil;
    
    self.firstName = nil;
    self.lastName = nil;
    self.position = nil;
    
}

- (IBAction)clearButton
{
    self.idLabel.text = @"----";
    self.userID = nil;
}


- (NSURL *) url
{
    if (!_url)
    {
        _url = [NSURL URLWithString:URL];
    }
    return _url;
}




- (void) returnUserData
{
    //NSLog(@"Inside returnUserData method in LoginViewController.m");
    //NSLog(@"self.delegate: %@",[self.delegate description]);
    //NSLog(@"self.parentViewController: %@",self.parentViewController);
    //NSLog(@"presentingViewController: %@",self.presentingViewController);
    
    if ([self.delegate isKindOfClass:[UIViewController class]])
    {
        
        
        
        [self.delegate addItemViewController:self didFinishEnteringItem:self.userData];
    
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
      
    }
}



- (void) getJSON:(NSNotification *) notification
{
    //NSLog(@"INSIDE getJSON notification method");
    self.JSONObject = [self.soap returnJSON];
    
    //NSLog(@"self.JSONObject description : %@",[self.JSONObject description]);
    
    if([self.JSONObject isKindOfClass:[NSDictionary class]])
    {
        //NSLog(@"Our JSON is a dictionary");
        
        for (NSString *key in self.JSONObject)
        {
            //NSLog(@"key: %@",key);
            if([key  isEqual: @"successful"])
            {
                if(![[self.JSONObject objectForKey:key] isEqual:[NSNumber numberWithInt:1]])
                {
                    [self clearButton];
                    break;
                }
            }
            else
            {
                NSDictionary *userInfo = [[self.JSONObject objectForKey:key] objectForKey:@"0"];
                for (NSString *userKey in userInfo)
                {
                    //NSLog(@"userKey: %@",userKey);
                    if ([userKey  isEqualToString: @"FirstName"])
                    {
                        self.firstName = [userInfo objectForKey:userKey];
                    }
                    else if ([userKey  isEqualToString: @"LastName"])
                    {
                        self.lastName = [userInfo objectForKey:userKey];
                    }
                    else if ([userKey  isEqualToString: @"UserType"])
                    {
                        self.position = [userInfo objectForKey:userKey];
                    }
                    else
                    {
                        NSLog(@"RECIEVED UNEXPECTED KEY IN OUR JSON DICTIONARY: %@\nWith OBJECTFORKEY: %@",userKey, [userInfo objectForKey:userKey]);
                    }
                }
            }
        }
        
        if(self.firstName && self.lastName && self.position)
        {
            self.userData = [NSDictionary dictionaryWithObjects:@[self.firstName,self.lastName,self.position] forKeys:@[@"firstname",@"lastname",@"position"]];
            [self returnUserData];
        }
        
        //NSLog(@"Description of userData: %@", [self.userData description]);
    }

    
    
}



- (IBAction)digitPressed:(UIButton *)sender
{
    if (!self.userID)
    {
        self.userID = @"";
    }
    
    
    NSString *labelString = self.idLabel.text;
    
    if (self.userID.length < 4)
    {
        self.idLabel.text = [labelString stringByReplacingCharactersInRange:NSMakeRange(self.userID.length,1) withString:@"*"];
        
        self.userID = [self.userID stringByAppendingString:[sender currentTitle]];
    }

    if(self.userID.length == 4)
    {
        [self performUserValidation:self.userID];
    }

}

- (void) performUserValidation:(NSString *)loginCode
{
    
    NSLog(@"LOGINCODE: %@",loginCode);
    
    if(!self.soap)
        self.soap = [[SOAPConnection alloc] init];
    
    //This dictionary will eventually have just one number
    NSDictionary *dict = @{@"username" : loginCode,
                           @"password" : loginCode,
                          };
    
    
    NSArray *paramOrder = @[@"username",@"password"];
    
 
    [self.soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:dict  usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
    
    
   
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJSON:) name:@"isTheJSONReady" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

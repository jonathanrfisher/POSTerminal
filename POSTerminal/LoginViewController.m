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

@property (nonatomic, strong) NSArray *userData;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) NSURL *url;
@property (nonatomic) id JSONObject;
@property (nonatomic) SOAPConnection *soap;
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


//EXAMPLE OF CREATING A JSON OBJECT
//NSArray *objects=[[NSArray alloc]initWithObjects:objects here,nil];
//NSArray *keys=[[NSArray alloc]initWithObjects:corresponding keys of objects,nil];
//NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
//NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

- (void) returnUserData
{
    //NSLog(@"Inside returnUserData method in LoginViewController.m");
    //NSLog(@"self.delegate: %@",[self.delegate description]);
    //NSLog(@"self.parentViewController: %@",self.parentViewController);
    //NSLog(@"presentingViewController: %@",self.presentingViewController);
    
    if ([self.delegate isKindOfClass:[UIViewController class]])
    {
        //UIViewController<LoginViewControllerDelegate> *presenter = (id<LoginViewControllerDelegate>)self.presentingViewController;
        //NSLog(@"Inside the returnUserData if statement...");
        //NSLog(@"Contents of self.userData: %@",[self.userData description]);
        
        
        [self.delegate addItemViewController:self didFinishEnteringItem:self.userData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //[presenter addItemViewController:self didFinishEnteringItem:self.userData];
    }
}

//- (void)playSong:(NSNotification *) notification {
//    NSString *theTitle = [notification object];
//    NSLog(@"Play stuff", theTitle);
//}

- (void) getJSON:(NSNotification *) notification
{
    NSLog(@"INSIDE getJSON notification method");
    self.JSONObject = [self.soap returnJSON];
    
    NSLog(@"self.JSONObject description : %@",[self.JSONObject description]);
    
    if([self.JSONObject isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Our JSON is a dictionary");
        
        for (NSString *key in self.JSONObject)
        {
            NSLog(@"key: %@",key);
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
                    NSLog(@"userKey: %@",userKey);
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
                        NSLog(@"RECIEVED UNEXPECTED KEY IN OUR JSON DICTIONARY: %@",userKey);
                    }
                }
            }
        }
        
        if(self.firstName && self.lastName && self.position)
        {
            self.userData = @[self.firstName,self.lastName,self.position];
            [self returnUserData];
        }
        
        NSLog(@"Description of userData: %@", [self.userData description]);
    }
//    else if ([self.JSONObject isKindOfClass:[NSArray class]])
//    {
//        NSLog(@"Our JSON is an array");
//    }
//    else
//    {
//        NSLog(@"Our JSON is a: %@", [self.JSONObject class]);
//    }
    
//    NSLog(@"self.JSONObject[0] = %@",self.JSONObject[0]);
//    
//    if(self.JSONObject[0])
//    {
//        NSLog(@"SUCCESSFUL VALIDATION");
//        [self returnUserData];
//    }
//    else
//    {
//        NSLog(@"UNSUCCESFUL VALIDATION");
//        [self clearButton];
//    }
    
    //    if (response)
    //    {
    //        //get the user data from the returned JSON
    //        [self returnUserData];
    //    }
    //    else
    //    {
    //        //Push the clear button
    //        [self clearButton];
    //    }
    
    
}



- (IBAction)digitPressed:(UIButton *)sender
{
    if (!self.userID)
    {
        self.userID = @"";
    }
    NSString *labelString = self.idLabel.text;
    //NSString *buttonTitleString = [sender currentTitle];
    
    
    //NSLog(@"Button: %@",buttonTitleString);
    //NSLog(@"self.userID.length: %d",self.userID.length);
    
    self.idLabel.text = [labelString stringByReplacingCharactersInRange:NSMakeRange(self.userID.length,1) withString:@"*"];
    
    self.userID = [self.userID stringByAppendingString:[sender currentTitle]];
    
    //NSLog(@"self.userID.length: %d",self.userID.length);
    //NSLog(@"self.userID: %@",self.userID);
    //NSLog(@"self.userID with \"testing\" appended to it: %@",[self.userID stringByAppendingString:@"testing"]);
    //NSLog(@"self.userID isEqualToString:@\"1234\": %i",[self.userID isEqualToString:@"1234"]);
    
    if(self.userID.length == 4) //&& [self.userID isEqualToString:@"1234"])
    {
        self.userData = @[@"Sweet Ass Manager",@"Jonathan",@"Fisher"];
        //NSLog(@"Inside the main if statment...");
        
        
        [self performUserValidation:self.userID];
        //NSLog(@"RESPONSE: %@",response);
        
        
        
    }
//    else if(self.userID.length == 4)
//    {
//        self.userID = @"";
//        self.idLabel.text = @"----";
//    }
}

- (void) performUserValidation:(NSString *)loginCode
{
    self.returnString = @"Base Return String";
    
    NSLog(@"LOGINCODE: %@",loginCode);
    
    self.soap = [[SOAPConnection alloc] init];
    
    //This dictionary will eventually have just one number
    NSDictionary *dict = @{@"username" : loginCode,
                           @"password" : loginCode,
                          };
    
    //NSDictionary *dict = @{@"password" : [NSNumber numberWithInt:2546],
    //                       @"username" : [NSNumber numberWithInt:2546],
    //                       };
    
    NSArray *paramOrder = @[@"username",@"password"];
    
  
//                      self.JSONObject = [soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:dict  usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
    
    
    [self.soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:dict  usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
    
    
    
    //SEL sel = @selector(getJSON:);
    
   
    
                      
                   
//    NSLog(@"self.JSONObject description : %@",[self.JSONObject description]);
//    NSLog(@"self.JSONObject[0] = %@",self.JSONObject[0]);
//    if(self.JSONObject[0])
//    {
//        NSLog(@"SUCCESSFUL VALIDATION");
//    }
//    else
//    {
//        NSLog(@"UNSUCCESFUL VALIDATION");
//    }
    
    //NSLog(@"at the end of performUserValidation, JSON description: %@",[self.JSONObject description]);
    
    //*obj=[DataClass getInstance];
    //obj.str= @"I am Global variable";
    
    //return self.returnString;
}


- (void) viewDidLoad
{
    
    NSLog(@"Before signing up for notification");
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playSong:) name:@"playNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJSON:) name:@"isTheJSONReady" object:self.soap];
    NSLog(@"AFTER signing up for notification");
}


@end

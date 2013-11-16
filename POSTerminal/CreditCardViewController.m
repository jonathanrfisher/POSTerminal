//
//  CreditCardViewController.m
//  POSTerminal
//
//  Created by gypC on 11/12/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "CreditCardViewController.h"
#import "SOAPConnection.h"
#import "POSTerminal.h"
#define URL @"http://jt.serveftp.net/Datacom/Server.asmx"

@interface CreditCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *creditNumField;
@property (weak, nonatomic) IBOutlet UITextField *expDateField;
@property (weak, nonatomic) IBOutlet UITextField *cvvNumField;

@property (strong, nonatomic) NSArray *cardInfo;
@property (nonatomic) NSString *creditText;
@property (nonatomic) NSString *expText;
@property (nonatomic) NSString *cvvText;


//For SOAP connection
@property (nonatomic) id JSONObject;
@property (nonatomic) SOAPConnection *soap;
@property (weak, nonatomic) NSURL *url;

@end

@implementation CreditCardViewController

- (void) viewDidAppear:(BOOL)animated
{
    self.cardInfo = nil;
    //_cardInfo = nil;
    self.creditNumField.text = nil;
    //_creditNumField.text = nil;
    //_expDateField.text = nil;
    self.expDateField.text = nil;
    //_cvvNumField.text = nil;
    self.cvvNumField.text = nil;
    //for SOAP connection
    //_JSONObject = nil;
    self.JSONObject = nil;
    //_soap = nil;
    self.soap = nil;
}



- (IBAction)submitBtn:(UIButton *)sender {
    
    //if(self.validateInput == YES){
        
        //_creditText = _creditNumField.text;
        //_expText = _expDateField.text;
        //_cvvText = _cvvNumField.text;
        //_cardInfo = @[_creditText,_expText,_cvvText];
    
    self.creditText = self.creditNumField.text;
    self.expText = self.expDateField.text;
    self.cvvText = self.cvvNumField.text;
    self.cardInfo = @[self.creditText,self.expText,self.cvvText];
    
        NSLog(@"Description of cardInfo: %@", [self.cardInfo description]);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[_cardInfo description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
        //        [self validateCardInfo:_creditText];
        //        [self validateCardInfo:_expText];
        //        [self validateCardInfo:_creditText];
        
        
    //}
    
}
-(BOOL)validateInput{
    
    BOOL retvalue=YES;
    NSString *throwmessage;
    
    if ([self.creditText isEqualToString:@""] || self.creditText.length != 16)
        
    {
        throwmessage=@"Enter a valid Credit Card number";
        retvalue=NO;
    }
    
    else if ([self.expText isEqualToString:@""] || self.expText.length != 4)
        
    {
        throwmessage=@"Enter a valid expration date (mmyy)";
        retvalue=NO;
    }
    else if ([self.cvvText isEqualToString:@"" ] || self.cvvText.length != 3)
        
    {
        throwmessage=@"Enter a valid cvv number";
        retvalue=NO;
    }
    
    if (retvalue==NO)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:throwmessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    return  retvalue;
    
}

- (void) validateCardInfo:(NSString *)cardInfo
{
    
    self.soap = [[SOAPConnection alloc] init];
    self.JSONObject = [self.soap returnJSON];
    

    NSLog(@"LOGINCODE: %@",cardInfo);
    
    self.soap = [[SOAPConnection alloc] init];
    
    NSDictionary * cardInfoDict = [NSDictionary dictionaryWithObject:cardInfo forKey:@"cardinfo"];
    
    //This dictionary will eventually have just one number
//    NSDictionary *dict = @{@"username" : loginCode,
//                           @"password" : loginCode,
//                           };
    
    //NSDictionary *dict = @{@"password" : [NSNumber numberWithInt:2546],
    //                       @"username" : [NSNumber numberWithInt:2546],
    //                       };
    
    NSArray *paramOrder = @[@"cardinfo"];

    
    [self.soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:cardInfoDict  usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJSON:) name:@"isTheJSONReady" object:self.soap];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//NEED TO WRITE THIS METHOD AFTER WE SEE WHAT THE FORMAT OF ALI'S JSON LOOKS LIKE
- (void) getJSON:(NSNotification *) notification
{
    NSLog(@"INSIDE getJSON notification method for CC validation");
    
    self.JSONObject = [self.soap returnJSON];
    
    NSLog(@"self.JSONObject description for CC validation: %@",[self.JSONObject description]);
    
    
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
                    //[self clearButton];
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
                        //self.firstName = [userInfo objectForKey:userKey];
                    }
                    else if ([userKey  isEqualToString: @"LastName"])
                    {
                        //self.lastName = [userInfo objectForKey:userKey];
                    }
                    else if ([userKey  isEqualToString: @"UserType"])
                    {
                        //self.position = [userInfo objectForKey:userKey];
                    }
                    else
                    {
                        NSLog(@"RECIEVED UNEXPECTED KEY IN OUR JSON DICTIONARY: %@",userKey);
                    }
                }
            }
        }
        
//        if(self.firstName && self.lastName && self.position)
//        {
//            self.userData = [NSDictionary dictionaryWithObjects:@[self.firstName,self.lastName,self.position] forKeys:@[@"firstname",@"lastname",@"position"]];
//            [self returnUserData];
//        }
        
       // NSLog(@"Description of userData: %@", [self.userData description]);
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



@end

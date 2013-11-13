//
//  CreditCardViewController.m
//  POSTerminal
//
//  Created by gypC on 11/12/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "CreditCardViewController.h"

@interface CreditCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *creditNumField;
@property (weak, nonatomic) IBOutlet UITextField *expDateField;
@property (weak, nonatomic) IBOutlet UITextField *cvvNumField;

@property (strong, nonatomic) NSArray *cardInfo;
@property (nonatomic) NSString *creditText;
@property (nonatomic) NSString *expText;
@property (nonatomic) NSString *cvvText;

@property (nonatomic) NSString *validationString;
@property (weak, nonatomic) NSURL *url;

@end

@implementation CreditCardViewController

- (void) viewDidAppear:(BOOL)animated {
    _cardInfo = nil;
    _creditNumField.text = nil;
    _expDateField.text = nil;
    _cvvNumField.text = nil;
    
    
    // for SOAP Connection
    //    _JSONObject = nil;
    //    _soap = nil;
    //    _validationString = nil;
    
}

-(BOOL)validateInput{
    
    BOOL retvalue=YES;
    NSString *throwmessage;
    
    if ([_creditText isEqualToString:@""] || _creditText.length != 16)
        
    {
        throwmessage=@"Enter a valid Credit Card number";
        retvalue=NO;
    }
    
    else if ([_expText isEqualToString:@""] || _expText.length != 4)
        
    {
        throwmessage=@"Enter a valid expration date (mmyy)";
        retvalue=NO;
    }
    else if ([_cvvText isEqualToString:@"" ] || _cvvText.length != 3)
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitBtn:(UIButton *)sender {
    
    if(self.validateInput){
    
        _creditText = _creditNumField.text;
        _expText = _expDateField.text;
        _cvvText = _cvvNumField.text;
        _cardInfo = @[_creditText,_expText,_cvvText];
    
        NSLog(@"Description of cardInfo: %@", [_cardInfo description]);
    }
    
}
@end

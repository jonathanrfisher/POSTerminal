//
//  CalculatorViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/20/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultField;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) NSString *previousNumber;
@property (nonatomic, strong) NSString *operation;

@end

@implementation CalculatorViewController



- (IBAction)digitButtonPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    //NSLog(@"Button Pressed Was: %@", digit);
    //    UILabel *myDisplay = self.display; // same as: [self display] which is like the message: "Hey self! give me a pointer for display!
    //    NSString *currentText = myDisplay.text; // [myDisplay text]
    //    NSString *newText = [currentText stringByAppendingString:digit];
    //    [myDisplay setText:newText];
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.resultField.text = [self.resultField.text stringByAppendingString:digit];
    }
    else
    {
        self.previousNumber = self.resultField.text;
        self.resultField.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }

    
}


- (IBAction)clearButtonPressed:(UIButton *)sender
{
    NSLog(@"CLEAR BUTTON PRESSED");
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.resultField.text = @"0.00";
    self.previousNumber = nil;
    
}

- (IBAction)equalsButtonPressed:(UIButton *)sender
{
    NSLog(@"equalsPressed with previous number: %@\nand self.resultField.text: %@",self.previousNumber,self.resultField.text);
    
    
    self.resultField.text = [self CalculateResultWithLeftNumber: self.previousNumber andWithRightNumber: self.resultField.text];
    self.previousNumber = nil;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
}

- (IBAction)operationButtonPressed:(UIButton *)sender
{
    if (![self.resultField.text floatValue])
        return;
    
    
    
    NSLog(@"self.previousNumber: %@",self.previousNumber);
    NSLog(@"self.operation: %@",self.operation);
    self.userIsInTheMiddleOfEnteringANumber = NO;

    if(self.previousNumber)
    {
        NSLog(@"Inside self.previousNumber of operationButtonPressed with:\nself.operation: %@\nself.resultField.text: %@\nself.previousNumber: %@",self.operation, self.resultField.text,self.previousNumber);
        self.operation = [sender currentTitle];
        NSLog(@"self.operation inside previousNumber: %@",self.operation);
        if ([self.previousNumber isEqualToString:@"0.00"])
        {
            self.previousNumber = self.resultField.text;
            return;
        }
        self.resultField.text = [self CalculateResultWithLeftNumber: self.previousNumber andWithRightNumber: self.resultField.text];
        self.previousNumber = nil;
    }
    else
    {
        NSLog(@"Inside operationButtonPressed else statement");
        
        
        
        self.previousNumber = self.resultField.text;
        self.operation = [sender currentTitle];
        self.resultField.text = [self.resultField.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.operation]];
        NSLog(@"value for self.previousNumber in the operation else statement: %@",self.previousNumber);
    }
    
    //if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    //double result = [self.brain performOperation:sender.currentTitle];
    //NSString *resultString = [NSString stringWithFormat:@"%g",result];
    //self.display.text = resultString;
    NSLog(@"self.operation at the end of operationPressed: %@",self.operation);
}

-(void) viewDidLoad
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
                               
                               
-(NSString *) CalculateResultWithLeftNumber: (NSString *) firstNumber
                          andWithRightNumber: (NSString *) secondNumber
{
    NSString *result;
    self.previousNumber = nil;
    
    NSLog(@"CalculateResult called with:\n%@\n%@",firstNumber,secondNumber);
    NSLog(@"self.operation in CalculateResult: %@",self.operation);
    
    if([self.operation isEqualToString:@"+"])
    {
        float leftNumber = [firstNumber floatValue];
        float rightNumber = [secondNumber floatValue];
        
        result = [NSString stringWithFormat:@"%.4f",(leftNumber + rightNumber)];
    }
    else if([self.operation isEqualToString:@"-"])
    {
        float leftNumber = [firstNumber floatValue];
        float rightNumber = [secondNumber floatValue];
        
        result = [NSString stringWithFormat:@"%.4f",(leftNumber - rightNumber)];
    }
    else if([self.operation isEqualToString:@"*"])
    {
        float leftNumber = [firstNumber floatValue];
        float rightNumber = [secondNumber floatValue];
        
        result = [NSString stringWithFormat:@"%.4f",(leftNumber * rightNumber)];
    }
    else if([self.operation isEqualToString:@"/"])
    {
        float leftNumber = [firstNumber floatValue];
        float rightNumber = [secondNumber floatValue];
        
        result = [NSString stringWithFormat:@"%.4f",(leftNumber / rightNumber)];
    }
    
    NSLog(@"With result: %@",result);
    //self.operation = nil;
    return result;
}


@end

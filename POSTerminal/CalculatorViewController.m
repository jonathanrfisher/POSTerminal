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
@property (nonatomic, weak) NSString *previousNumber;

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
        self.resultField.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }

    
}


- (IBAction)clearButtonPressed:(UIButton *)sender
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.resultField.text = @"0.00";
    
}

- (IBAction)equalsButtonPressed:(UIButton *)sender
{
    
    
}

- (IBAction)operationButtonPressed:(UIButton *)sender
{
    //NSLog(@"Operation Pressed");
    if(self.previousNumber)
        self.previousNumber = [self CalculateResultWith: self.resultField.text andWith: self.previousNumber];
    
    
    //if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    //double result = [self.brain performOperation:sender.currentTitle];
    //NSString *resultString = [NSString stringWithFormat:@"%g",result];
    //self.display.text = resultString;
}

-(void) viewDidLoad
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
                               
                               
-(NSString *) CalculateResultWith: (NSString *) firstNumber
                andWith: (NSString *) secondNumber
{
    NSString *result;
    
    return result;
}


@end

//
//  CCTableViewController.m
//  POSTerminal
//
//  Created by gypC on 11/19/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "CCTableViewController.h"
#import "CreditCardViewController.h"
#import "SOAPConnection.h"
#import "POSTerminal.h"
#define URL @"http://jt.serveftp.net/Datacom/Server.asmx"

@interface CCTableViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *creditNumField;
@property (weak, nonatomic) IBOutlet UITextField *expDateField;
@property (weak, nonatomic) IBOutlet UITextField *cvvNumField;

@property (strong, nonatomic) NSArray *cardInfo;
@property (nonatomic) NSString *creditText;
@property (nonatomic) NSString *expText;
@property (nonatomic) NSString *cvvText;

@property (nonatomic, retain) IBOutlet UITableViewCell *ccCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *expCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *cvvCell;



//For SOAP connection
@property (nonatomic) id JSONObject;
@property (nonatomic) SOAPConnection *soap;
@property (weak, nonatomic) NSURL *url;

@end

@implementation CCTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJSON:) name:@"isTheJSONReady" object:self.soap];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.cardInfo = nil;
    self.creditNumField.text = nil;
    self.expDateField.text = nil;
    self.cvvNumField.text = nil;
    
    //for SOAP connection
    self.JSONObject = nil;
    self.soap = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)submitBtn:(UIButton *)sender {
    
    if(self.validateInput == YES){
        
        
        self.creditText = self.creditNumField.text;
        self.expText = self.expDateField.text;
        self.cvvText = self.cvvNumField.text;
        self.cardInfo = @[self.creditText,self.expText,self.cvvText];
        
        NSLog(@"Description of cardInfo: %@", [self.cardInfo description]);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[self.cardInfo description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
        //        [self validateCardInfo:_creditText];
        //        [self validateCardInfo:_expText];
        //        [self validateCardInfo:_creditText];
        
        
    }
    
}

- (IBAction)cancelBtn:(id)sender {
}

-(BOOL)validateInput{
    
    BOOL retvalue=YES;
    NSString *throwmessage;
    
    if ([self.creditText isEqualToString:@""] || [self.creditNumField.text length] != 16)
        
    {
        throwmessage=@"Enter a valid Credit Card number";
        retvalue=NO;
    }
    
    else if ([self.expText isEqualToString:@""] || [self.expDateField.text length] != 4)
        
    {
        throwmessage=@"Enter a valid expration date (mmyy)";
        retvalue=NO;
    }
    else if ([self.cvvText isEqualToString:@"" ] || [self.cvvNumField.text length] != 3)
        
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
    
    
    NSLog(@"CreditCardInfo: %@",cardInfo);
    
    self.soap = [[SOAPConnection alloc] init];
    
    NSDictionary * cardInfoDict = [NSDictionary dictionaryWithObject:cardInfo forKey:@"cardinfo"];
    
    
    //    NSDictionary *cardDict = @{@"credit" : cardInfo,
    //                           @"exp" : cardInfo,
    //                           @"cvv" : cardInfo
    //                          };
    
    NSArray *paramOrder = @[@"cardinfo"];
    
    
    [self.soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:cardInfoDict  usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
    
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
                NSDictionary *cardInfo = [[self.JSONObject objectForKey:key] objectForKey:@"0"];
                for (NSString *userKey in cardInfo)
                {
                    NSLog(@"userKey: %@",userKey);
                    if ([userKey  isEqualToString: @"CreditNumber"])
                    {
                        //self.firstName = [userInfo objectForKey:userKey];
                    }
                    else if ([userKey  isEqualToString: @"ExpDate"])
                    {
                        //self.lastName = [userInfo objectForKey:userKey];
                    }
                    else if ([userKey  isEqualToString: @"Cvv"])
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

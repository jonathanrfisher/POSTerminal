//
//  POSTerminalViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "POSTerminalViewController.h"
#import "POSTerminal.h"
#import "POSTerminalAppDelegate.h"

@interface POSTerminalViewController ()

@property (nonatomic,strong) NSDictionary *userData;
//@property (nonatomic) POSTerminalViewController *loginView;
@property (nonatomic, strong, retain) LoginViewController *loginPortal;
@property (weak, nonatomic) IBOutlet UILabel *whereHaveYouBeanLabel;
//@property (nonatomic, strong) UIPopoverController *loginPopover;
@property (nonatomic, strong, retain) UIViewController *loginViewController;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (weak, nonatomic) IBOutlet UILabel *userDisplayName;
@property (nonatomic, strong) NSString *userType;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *voidTransactionButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *updatePOSButton;

@property (weak, nonatomic) NSDictionary *transactionsForTheDay;
@property (strong, nonatomic) UIManagedDocument *document;

@end

@implementation POSTerminalViewController


-(IBAction)createSomeProducts
{
    //Photomania Demo, video 14 for 2013, describes using CoreDataTableViewController
    //That controller seems contstructed though, I need to watch both core data videos again.
    [self getDocumentContext];
    [self createTheProducts];
    
}

-(void) getDocumentContext
{
    //Video 12, 39:34
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    
    //URL *url = [
//    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    //POSTerminalAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    
}

-(void) createTheProducts
{
    NSArray *names = @[@"Coffee",@"Capucino",@"Hot Chocolate",@"Apple Cider",@"Cake",@"Fruit",@"Juice"];
    NSArray *prices = @[@1.39,@2.49,@1.49,@1.99,@1.99,@.79,@2.49];
    NSArray *descriptions = @[@"Jamacain cocoa beans",@"Only the best froth!",@"70% Dark Chocolate",@"The perfect sweetness with a touch of caramel",@"Lemon Cake! Yum!",@"Banana, Apple, or Orange",@"Apple, Orange, or Grape"];
    NSArray *types = @[@"Drink",@"Drink",@"Drink",@"Drink",@"Food",@"Food",@"Drink"];
    NSArray *IDs = @[@1,@2,@3,@4,@5,@6,@7];
    
    for (int i = 0; i < [IDs count]; i++)
    {
        //do something
        NSLog(@"%u,%@,%@,%@,%@,%@",i,[names objectAtIndex:i],[prices objectAtIndex:i],[descriptions objectAtIndex:i],[types objectAtIndex:i],[IDs objectAtIndex:i]);
    }
}

- (IBAction)printData:(UIButton *)sender
{
    
    NSLog(@"Done Logging in.\nself.userData: %@",[self.userData description]);
}


- (void) addItemViewController:(LoginViewController *)controller didFinishEnteringItem:(NSDictionary *)userData
{
    //NSLog(@"This was returned from LoginViewController: %@",[userData description]);
    self.userData = userData;
    
    //[FirstName,LastName,Position]
    NSString *fullName = [[[self.userData objectForKey:@"firstname"] stringByAppendingString:@" "] stringByAppendingString:[self.userData objectForKey:@"lastname"]];
    self.userDisplayName.text = fullName;
    NSLog(@"didFinishEnteringItem:userData => self.userData: %@",[self.userData description]);
    
    self.userType = [self.userData objectForKey:@"position"];
    
    if([self.userType  isEqual: @"ADMIN"])
    {
        [self.voidTransactionButton setEnabled:true];
        [self.updatePOSButton setEnabled:true];
        
    }
    
}

//@synthesize userID = _userID;
//@synthesize loginView = _loginView;

//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	if (_userID == nil)
//    {
//        //self.loginView = [[UIView alloc] initWithFrame:self.view.frame];
//        //[self.view addSubView: _loginView];
//        //[self.view addSubview: _loginView.view];
//        
//        
////        _loginView = [[POSTerminalViewController alloc] initWithNibName:@"POSTerminalViewController" bundle: [NSBundle mainBundle]];
////        [self.view addSubview: _loginView.view];
//    }
//
//}

-(void) viewDidLoad {
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_image_grey.jpg"]];
    [super viewDidLoad];
    self.userDisplayName.text = @"";
    
}

- (IBAction) BeginTransaction
{
    NSLog(@"Begin Transaction was pressed!!!");
}


- (IBAction) VoidTransaction
{
    NSLog(@"Void Transaction was pressed! You're the best!");
    //Get a SOAP connection that returns list of the days transactions
    
    
    //Make another SOAP connection that sends a transaction ID to be voided and returns success or not.
    
    
    //Alert the user that the void was successful.
}




-(IBAction)makeFakeTransactions
{
    //What would a transaction contain?
    //For the purposes of our app, it will only have a transaction ID and an amount
    //The DB on our server would have the list of products from that transaction, we would have to use the web app to see that list.
    
    NSArray *amounts = @[@"27.99",@"19.39",@"7.49",@"3.99",@"12.29"];
    NSArray *transactionIDs = @[@1,@2,@3,@4,@5];
    
    self.transactionsForTheDay = [NSDictionary dictionaryWithObjects:amounts forKeys:transactionIDs];
    
}



- (IBAction) UpdatePOS
{
    NSLog(@"you pressed updatePOS!!");
}

- (IBAction) Logout:(id)sender
{
    NSLog(@"Logout Bitch.");
    self.userData = nil;
    self.userDisplayName.text = @"";
    [self.voidTransactionButton setEnabled:false];
    [self.updatePOSButton setEnabled:false];
    [self presentViewController:self.loginViewController animated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    //LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //UIPopoverController *loginPortal = [[UIPopoverController alloc] initWithContentViewController:loginViewController];
    
    self.loginPortal = lvc;
    
    self.loginPortal.delegate = self;
    
//    self.loginPopover = [[UIPopoverController alloc] initWithContentViewController:self.loginPortal];
//    
//    if (!self.userData)
//    {
//        NSLog(@"Inside !self.userData for the POSTerminalViewController");
//        CGRect whereHaveYouBeanRect = self.whereHaveYouBeanLabel.bounds;
//        //[self presentViewController:self.loginPortal animated:YES completion:nil];
//        [self.loginPopover presentPopoverFromRect:whereHaveYouBeanRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
    self.loginViewController = [[UIViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    
    
        if (!self.userData)
        {
            //NSLog(@"Inside !self.userData for the POSTerminalViewController");
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            lvc.delegate = self;
            
            //LoginViewController *lvc2 = [LoginViewController new];
            
            
            self.loginViewController = lvc;
            
            
            
            
            //CGRect whereHaveYouBeanRect = self.whereHaveYouBeanLabel.bounds;
            //[self presentViewController:self.loginPortal animated:YES completion:nil];
            //[self.loginPopover presentPopoverFromRect:whereHaveYouBeanRect inView:self.view
            //               permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
            //UINavigationController *nav = [[UINavigationController alloc]
              //                             initWithRootViewController:lvc2];
            
            
            
            [self presentViewController:self.loginViewController animated:YES completion:nil];
            
            //[self addChildViewController:self.loginViewController];
        }
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

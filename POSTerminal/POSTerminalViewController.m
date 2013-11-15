//
//  POSTerminalViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "POSTerminalViewController.h"
#import "POSTerminal.h"

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

@end

@implementation POSTerminalViewController


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

- (IBAction)dataButtonPressed:(UIButton *)sender
{
    
    
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



- (void) PopulateMenuItems:(NSString *)itemsFilePathToReadFrom
{
    
}


- (void) UpdatePOS: (NSString *)itemsFilePathToWriteTo
{
    NSLog(@"UpdatePOS was pressed! Way to go!");
}


- (NSString *) Login:(NSString *)userID
{
    NSString *result = @"Nothing";
    
    return result;
}


- (void) MenuTransition
{
    
}


- (void) BeginTransaction
{
    NSLog(@"Begin Transaction was pressed! You're so damn cool!");
}


- (void) VoidTransaction
{
    NSLog(@"Void Transaction was pressed! You're the best!");
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

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
@property (nonatomic,strong) NSArray *userData;
//@property (nonatomic) POSTerminalViewController *loginView;
@property (nonatomic, strong) LoginViewController *loginPortal;
@property (weak, nonatomic) IBOutlet UILabel *whereHaveYouBeanLabel;
@property (nonatomic, strong) UIPopoverController *loginPopover;


@end

@implementation POSTerminalViewController

- (void) addItemViewController:(LoginViewController *)controller didFinishEnteringItem:(NSArray *)userData
{
    NSLog(@"This was returned from LoginViewController: %@",[userData description]);
    self.userData = userData;
    NSLog(@"self.userData: %@",[self.userData description]);
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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_image_grey.jpg"]];
    [super viewDidLoad];
    
}



- (void) PopulateMenuItems:(NSString *)itemsFilePathToReadFrom
{
    
}


- (void) UpdatePOS: (NSString *)itemsFilePathToWriteTo
{
    
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
    
}


- (void) VoidTransaction
{
    
}


- (void) Logout
{
    
}

- (void) viewDidAppear:(BOOL)animated
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    //LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //UIPopoverController *loginPortal = [[UIPopoverController alloc] initWithContentViewController:loginViewController];
    
    self.loginPortal = lvc;
    
    self.loginPortal.delegate = self;
    
    self.loginPopover = [[UIPopoverController alloc] initWithContentViewController:self.loginPortal];
    
    if (!self.userData)
    {
        NSLog(@"Inside !self.userData for the POSTerminalViewController");
        CGRect whereHaveYouBeanRect = self.whereHaveYouBeanLabel.bounds;
        //[self presentViewController:self.loginPortal animated:YES completion:nil];
        [self.loginPopover presentPopoverFromRect:whereHaveYouBeanRect inView:self.view permittedArrowDirections:0 animated:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

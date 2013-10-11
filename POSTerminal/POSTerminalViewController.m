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
//@property (nonatomic) NSString *userID;
//@property (nonatomic) POSTerminalViewController *loginView;

@end

@implementation POSTerminalViewController

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






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

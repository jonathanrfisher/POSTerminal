//
//  POSTerminalViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 10/8/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "POSTerminalViewController.h"
#import "POSTerminal.h"
#import "Product+POSproducts.h"

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




- (IBAction)printProductsFromCoreData
{
    if (!self.document)
    {
        [self getDocInformationWithDocument:false];
    }
    else
    {
        [self printProducts];
    }
    
    
}

-(void) printProducts
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name != nil"];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    //Product *productHolder = [[Product alloc] init];
    
    if (matches)
    {
        for (Product *productItem in matches)
        {
            //productHolder = [[Product alloc] init];
            //productHolder = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
            //productHolder = productItem;
            NSLog(@"product name: %@", [productItem.name description]);
        }
    }
    else
    {
        NSLog(@"Nothing was returned! Matches was nil!!");
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"matches" message:[@"Matches count: " stringByAppendingString:[NSString stringWithFormat:@"%d",[matches count]]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

}

-(IBAction)getDocInformationWithDocument:(BOOL *) haveDocument
{
    
    if (!haveDocument) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"ProductsDocument"];
        
        NSLog(@"URL: %@", [url description]);
        
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        NSLog(@"document: %@",[document description]);
        
        NSLog(@"![[NSFileManager defaultManager] fileExistsAtPath:[url path]]: %d",(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]));
        NSLog(@"(document.documentState == UIDocumentStateClosed): %d",(document.documentState == UIDocumentStateClosed));
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [document saveToURL:url
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  if (success) {
                      self.document = document;
                      self.managedObjectContext = document.managedObjectContext;
                      NSLog(@"if: self.document: %@", [self.document description]);
                      NSLog(@"if: self.managedObjectContext: %@", [self.managedObjectContext description]);
                      [self printProducts];
                      //[self refresh];
                  }
              }];
        }
        else if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    self.document = document;
                    self.managedObjectContext = document.managedObjectContext;
                    NSLog(@"else if: self.document: %@", [self.document description]);
                    NSLog(@"else if: self.managedObjectContext: %@", [self.managedObjectContext description]);
                    [self printProducts];
                    
                }
                //[self createTheProducts];
            }];
        }
        else {
            self.document = document;
            self.managedObjectContext = document.managedObjectContext;
            NSLog(@"else: self.document: %@", [self.document description]);
            NSLog(@"else: self.managedObjectContext: %@", [self.managedObjectContext description]);
            [self printProducts];
        }

    }
}



-(IBAction)createSomeProducts
{
    //Photomania Demo, video 14 for 2013, describes using CoreDataTableViewController
    //That controller seems contstructed though, I need to watch both core data videos again.
    [self getDocumentContext];
    //[self createTheProducts];
    
}

-(void) getDocumentContext
{
    //Video 12, 39:34
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    
    //URL *url = [
//    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    //POSTerminalAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"ProductsDocument"];
    
    NSLog(@"URL: %@", [url description]);
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    NSLog(@"document: %@",[document description]);
    
    NSLog(@"![[NSFileManager defaultManager] fileExistsAtPath:[url path]]: %d",(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]));
    NSLog(@"(document.documentState == UIDocumentStateClosed): %d",(document.documentState == UIDocumentStateClosed));
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.document = document;
                  self.managedObjectContext = document.managedObjectContext;
                  //[self refresh];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.document = document;
                self.managedObjectContext = document.managedObjectContext;
            }
            [self createTheProducts];
        }];
    } else {
        self.document = document;
        self.managedObjectContext = document.managedObjectContext;
    }

    NSLog(@"self.managedObjectContext: %@", [self.managedObjectContext description]);
    
}

-(void) createTheProducts
{
    NSArray *names = @[@"Coffee",@"Capucino",@"Hot Chocolate",@"Apple Cider",@"Cake",@"Fruit",@"Juice"];
    NSArray *prices = @[@1.39,@2.49,@1.49,@1.99,@1.99,@.79,@2.49];
    NSArray *descriptions = @[@"Jamacain cocoa beans",@"Only the best froth!",@"70% Dark Chocolate",@"The perfect sweetness with a touch of caramel",@"Lemon Cake! Yum!",@"Banana, Apple, or Orange",@"Apple, Orange, or Grape"];
    NSArray *types = @[@"Drink",@"Drink",@"Drink",@"Drink",@"Food",@"Food",@"Drink"];
    NSArray *IDs = @[@1,@2,@3,@4,@5,@6,@7];
    
    NSMutableArray *products = [[NSMutableArray alloc] init];
    NSMutableDictionary *productDict = [[NSMutableDictionary alloc] init];
    
    NSUInteger i = 0;
    
    for (i = 0; i < [IDs count]; i++)
    {
        productDict = [[NSMutableDictionary alloc] init];
        //do something
        NSLog(@"%u,%@,%@,%@,%@,%@",i,[names objectAtIndex:i],[prices objectAtIndex:i],[descriptions objectAtIndex:i],[types objectAtIndex:i],[IDs objectAtIndex:i]);
        [productDict setObject:[names objectAtIndex:i] forKey:@"name"];
        [productDict setObject:[prices objectAtIndex:i] forKey:@"price"];
        [productDict setObject:[descriptions objectAtIndex:i] forKey:@"productDescription"];
        [productDict setObject:[types objectAtIndex:i] forKey:@"type"];
        [productDict setObject:[IDs objectAtIndex:i] forKey:@"productID"];
        
        [products addObject:productDict];
        
    }
    
    
    
    NSLog(@"Before the dispatch queue.");
    NSLog(@"Description of products array: %@",[products description]);
    
    dispatch_queue_t fetchQ = dispatch_queue_create("GetProducts", NULL);
    dispatch_async(fetchQ, ^
    {
        //NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
        // put the photos in Core Data
        NSLog(@"Before [self.managedObjectContext performBlock");
            [self.managedObjectContext performBlock:^
             {
                
                 NSLog(@"Before the for (NSDictionary *product in products) loop.");
                 for (NSDictionary *product in products)
                 {
                     NSLog(@"trying to insert: %@",[product description]);
                     [Product productWithDictionary:product inManagedObjectContext:self.managedObjectContext];
                 }
                 NSLog(@"After our for loop that is supposed to create our products.");
//              dispatch_async(dispatch_get_main_queue(), ^{
//              [self.refreshControl endRefreshing];
//              });
//                 NSError *error;
//                [self.managedObjectContext save:&error];
                 NSLog(@"self.document description: %@",[self.document description]);
                 [self.document updateChangeCount:UIDocumentChangeDone];
                 NSLog(@"Data Saved.");
             }];
            NSLog(@"AFTER the [self.mana....]");
    });
    
    NSLog(@"AFTER the dispatch queue.");
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

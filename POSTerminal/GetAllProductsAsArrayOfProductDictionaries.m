//
//  GetAllProductsAsArrayOfProductDictionaries.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/17/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "GetAllProductsAsArrayOfProductDictionaries.h"
#import "Product+POSproducts.h"

@interface GetAllProductsAsArrayOfProductDictionaries ()
@property UIManagedDocument *document;
@property NSManagedObjectContext *managedObjectContext;


@end



//This fetches the products from Core Data, NOT FROM SERVER
@implementation GetAllProductsAsArrayOfProductDictionaries

-(NSMutableArray *) products
{
    if(!_products)
    {
        _products = [[NSMutableArray alloc] init];
    }
    return _products;
}

- (void)getProductsFromCoreData
{
    if (!self.document)
    {
        [self getDocInformationWithDocument:false];
    }
    else
    {
        [self getProducts];
    }
}

-(void) getProducts
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    
    //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
    
    request.sortDescriptors = @[sortDescriptor];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name != nil"];
    
    // Execute the fetch
    
    if(!self.managedObjectContext)
        [self getDocumentContext];
    
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
            //NSLog(@"product name: %@", [productItem.name description]);
            [self.products addObject:(Product *)productItem];
            //NSLog(@"self.products after adding productItem: %@", [self.products description]);
        }
    }
    else
    {
        //NSLog(@"Nothing was returned! Matches was nil!!");
    }
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"matches" message:[@"Matches count: " stringByAppendingString:[NSString stringWithFormat:@"%d",[matches count]]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
    
    //NSLog(@"self.products before posting that products are ready: %@", [self.products description]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"productsReady" object:nil];
    
}

-(void)getDocInformationWithDocument:(BOOL *) haveDocument
{
    
    if (!haveDocument) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"ProductsDocument"];
        
        //NSLog(@"URL: %@", [url description]);
        
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        //NSLog(@"document: %@",[document description]);
        
        //NSLog(@"![[NSFileManager defaultManager] fileExistsAtPath:[url path]]: %d",(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]));
        //NSLog(@"(document.documentState == UIDocumentStateClosed): %d",(document.documentState == UIDocumentStateClosed));
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [document saveToURL:url
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  if (success) {
                      self.document = document;
                      self.managedObjectContext = document.managedObjectContext;
                      //NSLog(@"if: self.document: %@", [self.document description]);
                      //NSLog(@"if: self.managedObjectContext: %@", [self.managedObjectContext description]);
                      [self getProducts];
                      //[self refresh];
                  }
              }];
        }
        else if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    self.document = document;
                    self.managedObjectContext = document.managedObjectContext;
                    //NSLog(@"else if: self.document: %@", [self.document description]);
                    //NSLog(@"else if: self.managedObjectContext: %@", [self.managedObjectContext description]);
                    [self getProducts];
                    
                }
                //[self createTheProducts];
            }];
        }
        else {
            self.document = document;
            self.managedObjectContext = document.managedObjectContext;
            //NSLog(@"else: self.document: %@", [self.document description]);
            //NSLog(@"else: self.managedObjectContext: %@", [self.managedObjectContext description]);
            [self getProducts];
        }
        
    }
}

//-(IBAction)createSomeProducts
//{
//    //Photomania Demo, video 14 for 2013, describes using CoreDataTableViewController
//    //That controller seems contstructed though, I need to watch both core data videos again.
//    //I have a copy of the Photomania demo to learn from, he did make the CoreDataTableViewController class himself, but it has a lot of useful things to learn from it.
//    [self getDocumentContext];
//}

-(void) getDocumentContext
{
    //Video 12, 39:34
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"ProductsDocument"];
    
    //NSLog(@"URL: %@", [url description]);
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    //NSLog(@"document: %@",[document description]);
    
    //NSLog(@"![[NSFileManager defaultManager] fileExistsAtPath:[url path]]: %d",(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]));
    //NSLog(@"(document.documentState == UIDocumentStateClosed): %d",(document.documentState == UIDocumentStateClosed));
    
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
            //[self createTheProducts];
        }];
    } else {
        self.document = document;
        self.managedObjectContext = document.managedObjectContext;
    }
    
    //NSLog(@"self.managedObjectContext: %@", [self.managedObjectContext description]);
    
}

//
//-(void) createTheProducts
//{
//    NSArray *names = @[@"Coffee",@"Capucino",@"Hot Chocolate",@"Apple Cider",@"Cake",@"Fruit",@"Juice"];
//    NSArray *prices = @[@1.39,@2.49,@1.49,@1.99,@1.99,@.79,@2.49];
//    NSArray *descriptions = @[@"Jamacain cocoa beans",@"Only the best froth!",@"70% Dark Chocolate",@"The perfect sweetness with a touch of caramel",@"Lemon Cake! Yum!",@"Banana, Apple, or Orange",@"Apple, Orange, or Grape"];
//    NSArray *types = @[@"Drink",@"Drink",@"Drink",@"Drink",@"Food",@"Food",@"Drink"];
//    NSArray *IDs = @[@1001,@1002,@1003,@1004,@1005,@1006,@1007];
//    
//    NSMutableArray *products = [[NSMutableArray alloc] init];
//    NSMutableDictionary *productDict = [[NSMutableDictionary alloc] init];
//    
//    NSUInteger i = 0;
//    
//    for (i = 0; i < [IDs count]; i++)
//    {
//        productDict = [[NSMutableDictionary alloc] init];
//        //do something
//        NSLog(@"%u,%@,%@,%@,%@,%@",i,[names objectAtIndex:i],[prices objectAtIndex:i],[descriptions objectAtIndex:i],[types objectAtIndex:i],[IDs objectAtIndex:i]);
//        [productDict setObject:[names objectAtIndex:i] forKey:@"name"];
//        [productDict setObject:[prices objectAtIndex:i] forKey:@"price"];
//        [productDict setObject:[descriptions objectAtIndex:i] forKey:@"productDescription"];
//        [productDict setObject:[types objectAtIndex:i] forKey:@"type"];
//        [productDict setObject:[IDs objectAtIndex:i] forKey:@"productID"];
//        
//        [products addObject:productDict];
//        
//    }
//    
//    
//    
//    NSLog(@"Before the dispatch queue.");
//    NSLog(@"Description of products array: %@",[products description]);
//    
//    dispatch_queue_t fetchQ = dispatch_queue_create("GetProducts", NULL);
//    dispatch_async(fetchQ, ^
//                   {
//                       //NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
//                       // put the photos in Core Data
//                       NSLog(@"Before [self.managedObjectContext performBlock");
//                       [self.managedObjectContext performBlock:^
//                        {
//                            
//                            NSLog(@"Before the for (NSDictionary *product in products) loop.");
//                            for (NSDictionary *product in products)
//                            {
//                                NSLog(@"trying to insert: %@",[product description]);
//                                [Product productWithDictionary:product inManagedObjectContext:self.managedObjectContext];
//                            }
//                            NSLog(@"After our for loop that is supposed to create our products.");
//                            //              dispatch_async(dispatch_get_main_queue(), ^{
//                            //              [self.refreshControl endRefreshing];
//                            //              });
//                            //                 NSError *error;
//                            //                [self.managedObjectContext save:&error];
//                            NSLog(@"self.document description: %@",[self.document description]);
//                            [self.document updateChangeCount:UIDocumentChangeDone];
//                            NSLog(@"Data Saved.");
//                        }];
//                       NSLog(@"AFTER the [self.mana....]");
//                   });
//    
//    NSLog(@"AFTER the dispatch queue.");
//}


//
//
//- (IBAction) UpdatePOS
//{
//    NSLog(@"you pressed updatePOS!!");
//    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playSong:) name:@"playNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJSONandWriteToCoreData:) name:@"isTheJSONReady" object:nil];
//    [self getDocumentContext];
//    [self performUpdatePOS];
//}
//
//- (void) performUpdatePOS
//{
//    self.soap = [[SOAPConnection alloc] init];
//    
//    NSDictionary *dict;
//    
//    NSArray *paramOrder;
//    
//    //The soap connection notifies ViewController when the JSON is ready, we signed up to notificationCenter using the following:
//    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJSONandWriteToCoreData:) name:@"isTheJSONReady" object:nil];
//    
//    [self.soap makeConnection:self.url withMethodType:SOAPUpdatePOSMethodType withParams:dict  usingParamOrder:paramOrder withSOAPAction:SOAPActionPOSUpdate];
//}
//
//- (void) getJSONandWriteToCoreData:(NSNotification *) notification
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    self.JSONObject = [self.soap returnJSON];
//    
//    NSDictionary *products;
//    
//    for (NSString *key in self.JSONObject)
//    {
//        if ([key isEqual:@"table0"])
//        {
//            products = [self.JSONObject objectForKey:@"table0"];
//        }
//    }
//    
//    NSMutableArray *productsArray = [[NSMutableArray alloc] init];
//    
//    for (NSString *key in products)
//    {
//        [productsArray addObject:[products objectForKey:key]];
//    }
//    
//    NSLog(@"productsArray: %@", [productsArray description]);
//    
//    
//    
//    dispatch_queue_t fetchQ = dispatch_queue_create("GetProducts", NULL);
//    dispatch_async(fetchQ, ^
//                   {
//                       NSLog(@"Before [self.managedObjectContext performBlock with self.manageObjectContext: %@",[self.managedObjectContext description]);
//                       [self.managedObjectContext performBlock:^
//                        {
//                            NSEnumerator *innerKeys;
//                            NSMutableDictionary *temp;
//                            NSString *tempKey;
//                            
//                            NSLog(@"Before the for (NSDictionary *product in products) loop.");
//                            NSLog(@"Contents of products: %@", [productsArray description]);
//                            
//                            for (NSDictionary *product in productsArray)
//                            {
//                                temp = [[NSMutableDictionary alloc] init];
//                                innerKeys = [product keyEnumerator];
//                                for (NSString *key in innerKeys)
//                                {
//                                    tempKey = [key lowercaseString];
//                                    
//                                    if([tempKey isEqual:@"productdescription"])
//                                        tempKey = @"productDescription";
//                                    
//                                    if([tempKey isEqual:@"productid"])
//                                        tempKey = @"productID";
//                                    
//                                    
//                                    [temp setObject:[product objectForKey:key] forKey:tempKey];
//                                }
//                                NSLog(@"trying to insert: %@",[temp description]);
//                                [Product productWithDictionary:temp inManagedObjectContext:self.managedObjectContext];
//                            }
//                            NSLog(@"After our for loop that is supposed to create our products.");
//                            //              dispatch_async(dispatch_get_main_queue(), ^{
//                            //              [self.refreshControl endRefreshing];
//                            //              });
//                            //                 NSError *error;
//                            //                [self.managedObjectContext save:&error];
//                            NSLog(@"self.document description: %@",[self.document description]);
//                            [self.document updateChangeCount:UIDocumentChangeDone];
//                            NSLog(@"Data Saved.");
//                        }];
//                       NSLog(@"AFTER the [self.mana....]");
//                   });
//    
//    NSLog(@"AFTER the dispatch queue.");
//    
//    
//    //    if([self.JSONObject isKindOfClass:[NSDictionary class]])
//    //    {
//    //        NSLog(@"Our JSON is a dictionary");
//    //
//    //        for (NSString *key in self.JSONObject)
//    //        {
//    //            NSLog(@"key: %@",key);
//    //            if([key  isEqual: @"successful"])
//    //            {
//    //                if(![[self.JSONObject objectForKey:key] isEqual:[NSNumber numberWithInt:1]])
//    //                {
//    //                    [self clearButton];
//    //                    break;
//    //                }
//    //            }
//    //            else
//    //            {
//    //                NSDictionary *userInfo = [[self.JSONObject objectForKey:key] objectForKey:@"0"];
//    //                for (NSString *userKey in userInfo)
//    //                {
//    //                    NSLog(@"userKey: %@",userKey);
//    //                    if ([userKey  isEqualToString: @"FirstName"])
//    //                    {
//    //                        self.firstName = [userInfo objectForKey:userKey];
//    //                    }
//    //                    else if ([userKey  isEqualToString: @"LastName"])
//    //                    {
//    //                        self.lastName = [userInfo objectForKey:userKey];
//    //                    }
//    //                    else if ([userKey  isEqualToString: @"UserType"])
//    //                    {
//    //                        self.position = [userInfo objectForKey:userKey];
//    //                    }
//    //                    else
//    //                    {
//    //                        NSLog(@"RECIEVED UNEXPECTED KEY IN OUR JSON DICTIONARY: %@",userKey);
//    //                    }
//    //                }
//    //            }
//    //        }
//    //
//    //        if(self.firstName && self.lastName && self.position)
//    //        {
//    //            self.userData = [NSDictionary dictionaryWithObjects:@[self.firstName,self.lastName,self.position] forKeys:@[@"firstname",@"lastname",@"position"]];
//    //            [self returnUserData];
//    //        }
//    //
//    //        NSLog(@"Description of userData: %@", [self.userData description]);
//    //    }
//}
//
//
//
//-(void) viewDidLoad {
//    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_image_grey.jpg"]];
//    [super viewDidLoad];
//    self.userDisplayName.text = @"";
//    
//    
//}
//
//- (IBAction) BeginTransaction
//{
//    NSLog(@"Begin Transaction was pressed!!!");
//}
//
//
//- (IBAction) VoidTransaction
//{
//    NSLog(@"Void Transaction was pressed! You're the best!");
//    //Get a SOAP connection that returns list of the days transactions
//    
//    
//    //Make another SOAP connection that sends a transaction ID to be voided and returns success or not.
//    
//    
//    //Alert the user that the void was successful.
//}
//
//
//
//
//-(IBAction)makeFakeTransactions
//{
//    //What would a transaction contain?
//    //For the purposes of our app, it will only have a transaction ID and an amount
//    //The DB on our server would have the list of products from that transaction, we would have to use the web app to see that list.
//    
//    NSArray *amounts = @[@"27.99",@"19.39",@"7.49",@"3.99",@"12.29"];
//    NSArray *transactionIDs = @[@1,@2,@3,@4,@5];
//    
//    self.transactionsForTheDay = [NSDictionary dictionaryWithObjects:amounts forKeys:transactionIDs];
//    
//}
//
//
//
//
//- (IBAction) Logout:(id)sender
//{
//    NSLog(@"Logout Bitch.");
//    self.userData = nil;
//    self.userDisplayName.text = @"";
//    [self.voidTransactionButton setEnabled:false];
//    [self.updatePOSButton setEnabled:false];
//    [self presentViewController:self.loginViewController animated:YES completion:nil];
//}
//
//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:NO];
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LoginViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    
//    
//    self.loginPortal = lvc;
//    
//    self.loginPortal.delegate = self;
//    
//    self.loginViewController = [[UIViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    
//    
//    
//    if (!self.userData)
//    {
//        //NSLog(@"Inside !self.userData for the POSTerminalViewController");
//        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        
//        lvc.delegate = self;
//        
//        
//        
//        self.loginViewController = lvc;
//        
//        
//        
//        
//        [self presentViewController:self.loginViewController animated:YES completion:nil];
//        
//        
//    }
//    
//    
//}
//
//
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end



@end

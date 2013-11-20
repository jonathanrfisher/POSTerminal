//
//  TransactionViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/15/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "TransactionViewController.h"
#import "MenuItemsCells.h"
#import "CollectionOfProducts.h"
#import "MenuItemTableCell.h"
#import "FooterViewForTransactionTable.h"
#import "HeaderViewForTransactionTable.h"


@interface TransactionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *menuItemsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *transactionTableView;

@property (weak, nonatomic) IBOutlet FooterViewForTransactionTable *tableFooterView;
@property (weak, nonatomic) IBOutlet HeaderViewForTransactionTable *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *totalQuantity;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;


@property (nonatomic) CollectionOfProducts *products;
@property (strong, nonatomic) NSMutableArray *transactionItems;

@end

@implementation TransactionViewController



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.tableFooterView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableHeaderView;
}

//-(void) setTransactionItems:(NSMutableArray *)transactionItems
//{
//    NSLog(@"setTransactionItems was called!!! This means the tableView data should have been reloaded.");
//    _transactionItems = transactionItems;
//    [self.transactionTableView reloadData];
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //MUST FINISH WRITING THIS CODE
    }
}

- (IBAction)tapMenuItem:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"tapMenutItem Called!");
    CGPoint tapLocation = [gesture locationInView:self.menuItemsCollectionView];
    NSIndexPath *indexPath = [self.menuItemsCollectionView indexPathForItemAtPoint:tapLocation];
    
    
    //Update the transactionItems array by either updating the dictionary corresponding to the product, or adding an entry to the dictionary.
    if (indexPath)
    {
        //NSLog(@"indexPath within first tapMenuItem if statement");
        UICollectionViewCell *cell = [self collectionView:self.menuItemsCollectionView cellForItemAtIndexPath:indexPath];
        
        MenuButtonView *menuButtonView = ((MenuItemsCells *)cell).menuButtonView;

        NSString *name = menuButtonView.name;
        NSNumber *cost = [NSNumber numberWithFloat:[menuButtonView.cost floatValue]];
        NSNumber *quantity = [NSNumber numberWithInt:1];
        
        int transactionItemsIndexForCurrentItem = -1;
        bool transactionItemsContainsAnEntryForCurrentItem = false;

        
        for (int i = 0; i < [self.transactionItems count]; i++)
        {
            if ([name isEqualToString:[[self.transactionItems objectAtIndex:i] objectForKey:@"name"]]) {
                transactionItemsIndexForCurrentItem = i;
                transactionItemsContainsAnEntryForCurrentItem = true;
                break;
            }
        }
        
        if (transactionItemsIndexForCurrentItem != -1)
        {
            quantity = [NSNumber numberWithInt:[[[self.transactionItems objectAtIndex:transactionItemsIndexForCurrentItem] objectForKey:@"quantity"] intValue]];
        }
        
        
        NSArray *objects = @[name,cost,quantity];
        NSArray *keys = @[@"name",@"cost",@"quantity"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
        
        //NSLog(@"Description of dict in tapMenuItem: %@",dict);
        //NSLog(@"Description of self.transactionItems: %@",[self.transactionItems description]);
        
        NSString *quant;
        int value;
        
        if (transactionItemsContainsAnEntryForCurrentItem)    //[self.transactionItems containsObject:dict])
        {
            //NSLog(@"Inside [self.transactionItems containsObject:dict] in tapMenuItem");
            quant = [[self.transactionItems objectAtIndex:transactionItemsIndexForCurrentItem] objectForKey:@"quantity"];
            value = [quant intValue];
            value += 1;
            quant = [NSString stringWithFormat:@"%d",value];
            
            NSMutableDictionary *tempDict = [[self.transactionItems objectAtIndex:transactionItemsIndexForCurrentItem] mutableCopy];

            [tempDict setObject:quant forKey:@"quantity"];
            
            [self.transactionItems replaceObjectAtIndex:transactionItemsIndexForCurrentItem withObject:tempDict];
            [self calculateTotalQuantity];
            [self calculateTotalCost];
            [self.transactionTableView reloadData];
            //[[self.transactionItems objectAtIndex:i] setObject:quant forKey:@"quantity"];
        }
        else
        {
            //NSArray *arrayWithDict = [NSArray arrayWithObject:dict];
            //NSLog(@"Inside else for [self.transactionItems containsObject:dict] in tapMenuItem");
            
            self.transactionItems = [NSMutableArray arrayWithArray:[self.transactionItems arrayByAddingObject:dict]];
            
            [self calculateTotalQuantity];
            [self calculateTotalCost];
            //self.transactionItems = [self.transactionItems arrayByAddingObjectsFromArray:arrayWithDict];
            //NSLog(@"description of self.transactionItems inside the else statement for tapMenuItem: %@",[self.transactionItems description]);
            [self.transactionTableView reloadData];
        }

        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"You tapped a menu item" message:@"yup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];

        //        [self.game flipCardAtIndex:indexPath.item];
        //        self.flipCount++;
        //        [self updateUI];
        //        self.gameResult.score = self.game.score;
        
        
        
        
        //NSLog(@"description of self.transactionItems: %@",[self.transactionItems description]);
        
    }
}

-(void) calculateTotalQuantity
{
    int quantity = 0;
    
    
    for (int i = 0; i < [self.transactionItems count]; i++)
    {
        quantity += [[[self.transactionItems objectAtIndex:i] objectForKey:@"quantity"] intValue];
    }
    self.totalQuantity.text = [NSString stringWithFormat:@"Total: %d",quantity];
}

-(void) calculateTotalCost
{
    float cost = 0;
    float currentCost = 0;
    int quantity = 0;
    
    for (int i = 0; i < [self.transactionItems count]; i++)
    {
        quantity = [[[self.transactionItems objectAtIndex:i] objectForKey:@"quantity"] intValue];
        currentCost = [[[self.transactionItems objectAtIndex:i] objectForKey:@"cost"] floatValue];
        
        cost += currentCost * quantity;
    }
    
    self.totalCost.text = [NSString stringWithFormat:@"%.2f",cost];
}



- (IBAction)longPressOnMenuItem:(UILongPressGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.menuItemsCollectionView];
    NSIndexPath *indexPath = [self.menuItemsCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath)
    {
        UICollectionViewCell *cell = [self collectionView:self.menuItemsCollectionView cellForItemAtIndexPath:indexPath];
        
        MenuButtonView *menuButtonView = ((MenuItemsCells *)cell).menuButtonView;
        
        NSString *name = menuButtonView.name;
        NSString *descriptionString = menuButtonView.productDescription;
        
        NSString *cost = menuButtonView.cost;
        
        descriptionString = [descriptionString stringByAppendingString:[NSString stringWithFormat:@"\n%@",cost]];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:name message:descriptionString delegate:self cancelButtonTitle:@"Groove On" otherButtonTitles:nil, nil];
        [alert show];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return [self.transactionItems count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductTableCell";
    
    MenuItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure the cell
    //NSLog(@"descriptiongs of:\ncell: %@\ncell.quantity: %@\ncell.quantity.text: %@\nself.transactionItems: %@\n[self.transactionItems objectAtIndex:indexPath.row]: %@",[cell description],[cell.quantity description],[cell.quantity.text description],[self.transactionItems description],[[self.transactionItems objectAtIndex:indexPath.row] description]);
    
    cell.quantity.text = [NSString stringWithFormat:@"%@",[[self.transactionItems objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
    cell.name.text = [[self.transactionItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    float tempCost = [[[self.transactionItems objectAtIndex:indexPath.row] objectForKey:@"cost"] floatValue];
    tempCost = tempCost * [cell.quantity.text intValue];
    
    cell.cost.text = [NSString stringWithFormat:@"%.2f",tempCost];
    
    return cell;
}

//- (void)setTransactionItems:(NSMutableArray *)transactionItems
//{
//    self.transactionItems = transactionItems;
//    [self.transactionTableView reloadData];
//}


-(CollectionOfProducts *) products
{
    if(!_products)
    {
        //NSLog(@"Inside !_products for TransactionViewController");
        _products = [[CollectionOfProducts alloc] init];
        [_products buildArrayOfProducts];
    }
    
    return _products;
}

//-(NSMutableArray *) transactionItems
//{
//    
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemButton" forIndexPath:indexPath];
    //NSLog(@"self.products before using updateCell: %@",[[self.products productAtIndex:indexPath.item]description]);
    Product *product = [self.products productAtIndex:indexPath.item];
    [self updateCell:cell usingProduct:product];
    return cell;
}

-(void) updateCell:(UICollectionViewCell *) cell usingProduct: (Product *) product
{
    //abstract
    //NSLog(@"Updating cell with: [cell isKindOfClass:[MenuItemsCells class]] == %hhd\n[product isKindOfClass:[Product class]] == %hhd\nAnd with Product:\n%@",[cell isKindOfClass:[MenuItemsCells class]], [product isKindOfClass:[Product class]],[product description]);
    if ([cell isKindOfClass:[MenuItemsCells class]])
    {
        MenuButtonView *menuButtonView = ((MenuItemsCells *)cell).menuButtonView;
        if ([product isKindOfClass:[Product class]]) {
            Product *productItem = (Product *)product;
            //Assign the appropriate values to menuButtonView
            menuButtonView.name = productItem.name;
            //menuButtonView.price = productItem.price;
            menuButtonView.productDescription = productItem.productDescription;
            menuButtonView.cost = [NSString stringWithFormat:@"%@",productItem.price];
            //menuButtonView.productID = productItem.productID
            //menuButtonView.type = productItem.type;
            //NSLog(@"menuButtonView.name == %@\nmenuButtonView.productDescription == %@",menuButtonView.name,menuButtonView.productDescription);
        }
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.products.products count];
    //return self.numberOfProducts;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    //return [self.products.products count];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateUI
{
    //NSLog(@"UpdateUI called!!!!!!!!\nwith self.products.products: %@", [self.products.products description]);
    for (UICollectionViewCell *cell in [self.menuItemsCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.menuItemsCollectionView indexPathForCell:cell];
        Product *product = [self.products productAtIndex:indexPath.item];
        [self updateCell:cell usingProduct:product];
    }
    [self.menuItemsCollectionView reloadData];
    //self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)viewDidLoad
{
    self.transactionItems = [[NSMutableArray alloc] init];
    //NSLog(@"TransactionViewController viewDidLoad");
    [super viewDidLoad];
    //NSLog(@"self.products: %@", [self.products description]);
    [self.products buildArrayOfProducts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"productsReadyForUpdateUI" object:nil];
     // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

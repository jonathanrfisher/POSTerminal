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


@interface TransactionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *menuItemsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *transactionTableView;

@property (nonatomic) CollectionOfProducts *products;


@end

@implementation TransactionViewController


- (IBAction)tapMenuItem:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.menuItemsCollectionView];
    NSIndexPath *indexPath = [self.menuItemsCollectionView indexPathForItemAtPoint:tapLocation];
    
    
    //Update the transactionItems array by either updating the dictionary corresponding to the product, or adding an entry to the dictionary.
    if (indexPath)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"You tapped a menu item" message:@"yup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        //        [self.game flipCardAtIndex:indexPath.item];
//        self.flipCount++;
//        [self updateUI];
//        self.gameResult.score = self.game.score;
    }
}



- (IBAction)longPressOnMenuItem:(UILongPressGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.menuItemsCollectionView];
    NSIndexPath *indexPath = [self.menuItemsCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath)
    {
        UICollectionViewCell *cell = [self collectionView:self.menuItemsCollectionView cellForItemAtIndexPath:indexPath];
        
        MenuButtonView *menuButtonView = ((MenuItemsCells *)cell).menuButtonView;
        
        
        NSString *descriptionString = menuButtonView.productDescription;
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Item Description" message:descriptionString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    cell.quantity.text = [[self.transactionItems objectAtIndex:indexPath.row] objectForKey:@"quantity"];
    cell.name.text = [[self.transactionItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    NSInteger tempCost = [[[self.transactionItems objectAtIndex:indexPath.row] objectForKey:@"cost"] intValue];
    tempCost = tempCost * [cell.quantity.text intValue];
    
    cell.cost.text = [NSString stringWithFormat:@"%d",tempCost];
    
    return cell;
}

- (void)setTransactionItems:(NSArray *)transactionItems
{
    _transactionItems = transactionItems;
    [self.transactionTableView reloadData];
}


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
    NSLog(@"Updating cell with: [cell isKindOfClass:[MenuItemsCells class]] == %hhd\n[product isKindOfClass:[Product class]] == %hhd\nAnd with Product:\n%@",[cell isKindOfClass:[MenuItemsCells class]], [product isKindOfClass:[Product class]],[product description]);
    if ([cell isKindOfClass:[MenuItemsCells class]])
    {
        MenuButtonView *menuButtonView = ((MenuItemsCells *)cell).menuButtonView;
        if ([product isKindOfClass:[Product class]]) {
            Product *productItem = (Product *)product;
            //Assign the appropriate values to menuButtonView
            menuButtonView.name = productItem.name;
            //menuButtonView.price = productItem.price;
            menuButtonView.productDescription = productItem.productDescription;
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
    NSLog(@"TransactionViewController viewDidLoad");
    [super viewDidLoad];
    NSLog(@"self.products: %@", [self.products description]);
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

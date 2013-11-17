//
//  TransactionViewController.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/15/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "TransactionViewController.h"
#import "MenuItemsCollectionViewController.h"
#import "MenuItemsCells.h"
#import "CollectionOfProducts.h"


@interface TransactionViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *menuItemsCollectionView;
@property (nonatomic) CollectionOfProducts *products;


@end

@implementation TransactionViewController

-(CollectionOfProducts *) products
{
    if(!_products)
    {
        NSLog(@"Inside !_products");
        _products = [[CollectionOfProducts alloc] init];
    }
    
    return _products;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemButton" forIndexPath:indexPath];
    Product *product = [self.products productAtIndex:indexPath.item];
    [self updateCell:cell usingProduct:product];
    return cell;
}

-(void) updateCell:(UICollectionViewCell *) cell usingProduct: (Product *) product
{
    //abstract
    NSLog(@"Updating cell with: [cell isKindOfClass:[MenuItemsCells class]] == %hhd\n[product isKindOfClass:[Product class]] == %hhd",[cell isKindOfClass:[MenuItemsCells class]], [product isKindOfClass:[Product class]]);
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
            NSLog(@"menuButtonView.name == %@\nmenuButtonView.productDescription == %@",menuButtonView.name,menuButtonView.productDescription);
        }
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
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
    for (UICollectionViewCell *cell in [self.menuItemsCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.menuItemsCollectionView indexPathForCell:cell];
        Product *product = [self.products productAtIndex:indexPath.item];
        [self updateCell:cell usingProduct:product];
    }
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

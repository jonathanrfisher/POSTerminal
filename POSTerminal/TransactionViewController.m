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


@interface TransactionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *MenuItemsCollectionView;

@property (nonatomic) CollectionOfProducts *products;


@end

@implementation TransactionViewController

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemButton" forIndexPath:indexPath];
    Product *product = [self.products productAtIndexPath:indexPath.item];
    [self updateCell:cell usingProduct:product];
    return cell;
}

-(void) updateCell:(UICollectionViewCell *) cell usingProduct: (Product *) product
{
    //abstract
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
        }
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfProducts;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

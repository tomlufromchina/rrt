//
//  SquareViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-19.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SquareViewController.h"

@interface SquareViewController ()

@end

@implementation SquareViewController

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
    
    self.title = @"书桌";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(45, 65);

    CGFloat paddingY = 20;
    CGFloat paddingX = 40;
    layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    
    layout.minimumLineSpacing = paddingY;
    
    layout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 50);
    
    self.collectionView.collectionViewLayout = layout;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection data source
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          withReuseIdentifier:@"DeskHeader"
                                                                 forIndexPath:indexPath];
        
        UILabel *label = (UILabel*)[reusableview viewWithTag:1];
        if (indexPath.section == 0) {
            label.text = @"公共应用";
        } else {
            label.text = @"校内应用";
        }
    }
    
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SquareCell"
                                                                           forIndexPath:indexPath];
    return cell;
}

#pragma mark - collection delegate
#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"The index of collection view is:%d --- section:%d", indexPath.row, indexPath.section);
    
    
    NSURL * url = [NSURL URLWithString:@"Refresh://userId=test"];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"没有安装该应用" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        
        [view show];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end

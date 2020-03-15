//
//  PhotoDetailsController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-29.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "PhotoDetailsController.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "PhotoDetailsCell.h"

#define TagOffline 1000
#define MaxSelectedNum 5

@interface PhotoDetailsController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL bEditMode;

@end

@implementation PhotoDetailsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.photoAlbum.AlbumName;
    self.navigationController.navigationBar.translucent = NO;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    
    self.bEditMode = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"选择"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(selectPictures:)];
    rightItem.tag = 1;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //UICollectionView
    self.collectionView = (UICollectionView*)[self.view viewWithTag:1];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(104, 104);
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    [self.collectionView setCollectionViewLayout:layout];
    
    
    // Register cell class
    [self.collectionView registerClass:[PhotoDetailsCell class]
            forCellWithReuseIdentifier:@"PhotoDetailsCell"];

    //Toolview
    self.toolView = (UIView*)[self.view viewWithTag:2];
    [self.toolView setHidden:YES];
    self.deleteButton = (UIButton*)[self.toolView viewWithTag:1];
    [_deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setEnabled:NO];
    
    
    
    [self show];
    [self.netWorkManager pictureList:[RRTManager manager].loginManager.loginInfo.tokenId
                              UserId:[RRTManager manager].loginManager.loginInfo.userId
                             AlbumId:[NSString stringWithFormat:@"%d", self.photoAlbum.AlbumId]
                            PageSize:10
                           PageIndex:1
                             success:^(NSArray *photoListArray) {
                                 [self dismiss];
                                 NSLog(@"The urls is:%@", photoListArray);
                                 [self updateView:photoListArray];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"你还没有上传相片哦!"];

        
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView:(NSArray*)array;
{
    self.images = array;
    
    [self.collectionView reloadData];
}

- (void)delete:(id)sender
{
    NSArray *array = [self.collectionView indexPathsForSelectedItems];
    NSString *buttonTitle = nil;
    if ([array count] > 1) {
        buttonTitle = [NSString stringWithFormat:@"删除%d张照片", [array count]];
    } else {
        buttonTitle = @"删除照片";
    }
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:buttonTitle, nil];
    [sheet showInView:self.view];
}

- (void)updateUI
{
    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
    self.block();
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectPictures:(UIBarButtonItem*)button
{
    if (button.tag == 1) {
        button.title = @"取消";
        button.tag = 2;
        self.bEditMode = YES;
        [self.toolView setHidden:NO];
        [self.deleteButton setEnabled:NO];
    } else if (button.tag == 2) {
        button.title = @"选择";
        button.tag = 1;
        self.bEditMode = NO;
        [self.toolView setHidden:YES];
        [self.deleteButton setEnabled:NO];
    }
    
    //it is must
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoDetailsCell" forIndexPath:indexPath];
    
    cell.showsOverlayViewWhenSelected = self.bEditMode;

    Photo *photo = (Photo*)[self.images objectAtIndex:indexPath.row];
    
    cell.url = photo.url;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bEditMode) {
        NSArray *array = [collectionView indexPathsForSelectedItems];
        int count = [array count];
        if (count > 0) {
            [self.deleteButton setEnabled:YES];
        } else {
            [self.deleteButton setEnabled:NO];
        }
        
        
    } else {
        int count = [self.images count];
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            
            Photo *photo1 = (Photo*)[self.images objectAtIndex:i];
            photo.url = [NSURL URLWithString:photo1.url]; // 图片路径
            
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:
                                          [NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = (UIImageView*)[cell viewWithTag:1]; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bEditMode) {
        NSArray *array = [collectionView indexPathsForSelectedItems];
        int count = [array count];
        if (count > 0) {
            [self.deleteButton setEnabled:YES];
        } else {
            [self.deleteButton setEnabled:NO];
        }
        
        
    } else {
        int count = [self.images count];
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            
            Photo *photo1 = (Photo*)[self.images objectAtIndex:i];
            photo.url = [NSURL URLWithString:photo1.url]; // 图片路径
            
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:
                                          [NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = (UIImageView*)[cell viewWithTag:1]; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

#pragma mark - UIActionSheet delete
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"开始调用接口删除照片");
        
        NSArray *array = [self.collectionView indexPathsForSelectedItems];
        
        NSMutableArray *photoIds = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSIndexPath *indexPath in array) {
            Photo *photo = (Photo*)[self.images objectAtIndex:indexPath.row];
            [photoIds addObject:photo.photoId];
        }

        __block PhotoDetailsController *_self = self;
        [self.netWorkManager deletePhotos:[RRTManager manager].loginManager.loginInfo.tokenId
                                  photoId:photoIds
                                  success:^(NSDictionary *dict) {
            [_self deletePhotosSuccess:dict];
                                      [self updateUI];
        } failed:^(NSString *errorMSG) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"删除照片失败"];

        }];
    }
}

- (void)deletePhotosSuccess:(NSDictionary*)dict
{
    NSArray *array = [self.collectionView indexPathsForSelectedItems];

    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.images];
    for (NSIndexPath *indexPath in array) {
        Photo *photo = (Photo*)[self.images objectAtIndex:indexPath.row];
        [tmpArray removeObject:photo];
    }
    
    self.images = tmpArray;
    
    
    [self selectPictures:self.navigationItem.rightBarButtonItem];
}

@end

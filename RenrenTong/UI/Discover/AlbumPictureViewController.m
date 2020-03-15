//
//  AlbumDetailViewController.m
//  RenrenTong
//
//  Created by aedu on 15/4/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "AlbumPictureViewController.h"
#import "PictureDetailViewController.h"
#import "PhotoDetailsCell.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "ImageCollectionViewCell.h"
#import "AlbumList.h"
#import "PicturesScrollerView.h"
#import "MJRefresh.h"
#import "PhotoCollectionReusableView.h"
#import "SendPicViewController.h"
#import "MyClassPassesOnThePictureViewController.h"
#define CellWidth (SCREENWIDTH - 70)/4


@interface AlbumPictureViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,PictureScrollerViewDelegate>
{
    UILabel *totleSelectLabel;
    UIView *deleteView;
    NSInteger selectNum;
    NSMutableArray *selectArray;
    NSMutableArray *dataArray;
    BOOL isSelectAll;
    UIButton *allselect;
    UIButton *deleteButton;
    NSIndexPath *currentIndex;//相册浏览Section
    BOOL backToSelfView;
    BOOL isAuthority; //相片管理
    BOOL isPictuterUpload; //图片上传权限
    
    NSInteger dataPage;
    BOOL isHeadRefresh; //判断是否头更新
    BOOL isFootRefresh; //判断是否根更新
    NSMutableArray *currentNextPageAry;
}

@property (nonatomic, assign) BOOL bEditMode;


@end


@implementation AlbumPictureViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.bEditMode = NO;
    NSLog(@"````````%@",self.classId);
    selectArray = [[NSMutableArray alloc] init];
    self.title = @"相册详情";
    dataArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(selectPictures:)];
    rightItem.tag = 1;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(20, 75, SCREENWIDTH - 40, 44);
    [uploadBtn setTitle:@"上传照片" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    uploadBtn.layer.masksToBounds = YES;
    uploadBtn.layer.cornerRadius = 5;
    uploadBtn.backgroundColor = theLoginButtonColor;
    [self.view addSubview:uploadBtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat startY = CGRectGetMaxY(uploadBtn.frame);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, startY, SCREENWIDTH, SCREENHEIGHT- startY) collectionViewLayout:layout];
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
    [self.collectionView registerClass:[PhotoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentSize = CGSizeMake(0, SCREENHEIGHT - 64 + 20);
    self.collectionView.alwaysBounceVertical = YES;
    [self setupRefresh];
    [self.view addSubview:self.collectionView];
    dataPage = 1;
    [self initData];
    [self checkAuthority];
    
    // Do any additional setup after loading the view.
}
#pragma mark - scrollview 刷新操作
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.collectionView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.collectionView addFooterWithTarget:self action:@selector(footerReresh)];
}
- (void)headerReresh
{
    if (!isHeadRefresh) {
        dataPage = 1;
        isHeadRefresh = YES;
        [self initData];
    }
}

- (void)footerReresh
{
    if (!isFootRefresh) {
        isFootRefresh = YES;
        [self initData];
    }
}
-(void)endRefresh
{
    if (isHeadRefresh) {
        [self.collectionView headerEndRefreshing];
        isHeadRefresh = NO;
    }
    if (isFootRefresh){
        [self.collectionView footerEndRefreshing];
        isFootRefresh = NO;
    }
}
#pragma mark - 获取图片列表
-(void)initData
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoListS",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.albumId,@"AblumId",[NSNumber numberWithInt:dataPage],@"pageIndex",@"20",@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoList *albumList = [[GetPhotoList alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            if (dataPage == 1) {
                dataArray = albumList.items;
            }else{
                GetPhotoItems *item= [albumList.items objectAtIndex:0];
                GetPhotoItems *lastitem = [dataArray objectAtIndex:dataArray.count - 1];
                if ([item.Month isEqualToString:lastitem.Month]) {
                    [lastitem.List addObjectsFromArray:item.List];
                    [albumList.items removeObject:item];
                }
                [dataArray addObjectsFromArray:albumList.items];
            }
            [self.collectionView reloadData];
            [self endRefresh];
            dataPage ++;
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
            if(isSelectAll)
            {
                [dataArray removeAllObjects];
            }
            [self.collectionView reloadData];
            [self endRefresh];
            [self dismiss];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
        if(isSelectAll)
        {
            [dataArray removeAllObjects];
        }
        [self.collectionView reloadData];
        [self endRefresh];
        [self dismiss];
    } cache:^(id cache) {
    }];
}
#pragma mark - 检查权限
-(void)checkAuthority
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetAuthority",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:json error:nil];
        if (result.result == 1 ) {
            for (GetAuthorityItem *item in result.items) {
                if ([item.AuthDes isEqualToString:@"相册管理"] && item.IsOwn) {
                    isAuthority = YES;
                }
                if ([item.AuthDes isEqualToString:@"相片上传"] && item.IsOwn) {
                    isPictuterUpload = YES;
                }
            }
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:cache error:nil];
        if (result.result == 1 ) {
            for (GetAuthorityItem *item in result.items) {
                if ([item.AuthDes isEqualToString:@"相册管理"] && item.IsOwn) {
                    isAuthority = YES;
                }
                if ([item.AuthDes isEqualToString:@"相片上传"] && item.IsOwn) {
                    isPictuterUpload = YES;
                }
            }
        }
    }];
}
#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellWidth, CellWidth);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 5, 20);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GetPhotoItems *item = [dataArray objectAtIndex:section];
    return item.List.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell" forIndexPath:indexPath];
    GetPhotoItems *item = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = item.List;
    GetPhotoItemList *itemList = [array objectAtIndex:indexPath.row];
    [cell.image setImageURLStr:itemList.PhotoUrl placeholder:[UIImage imageNamed:@"defaultImage"]];
    if ([selectArray containsObject:itemList.PhotoId]) {
        cell.selectImage.hidden = NO;
    }else{
        cell.selectImage.hidden = YES;
    }
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        PhotoCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        GetPhotoItems *item = [dataArray objectAtIndex:indexPath.section];
        headerView.label.text = [item.Month stringByReplacingOccurrencesOfString:@"/" withString:@"年"];
        headerView.label.text = [headerView.label.text stringByAppendingString:@"日"];
        return headerView;
    }else{
        return nil;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    GetPhotoItems *item = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = item.List;
    GetPhotoItemList *itemList = [array objectAtIndex:indexPath.row];
    if (self.bEditMode) {
        
        if (cell.selectImage.hidden) {
            [selectArray addObject:itemList.PhotoId];
            cell.selectImage.hidden = NO;
        }else{
            [selectArray removeObject:itemList.PhotoId];
            cell.selectImage.hidden = YES;
        }
        if(selectArray.count != dataArray.count){
            if (allselect.selected) {
                allselect.selected = !allselect.selected;
            }
        }
        totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",(int)selectArray.count];
        if (selectArray.count > 0) {
            deleteButton.backgroundColor = theLoginButtonColor;
            deleteButton.userInteractionEnabled = YES;
        }else{
            deleteButton.backgroundColor = [UIColor grayColor];
            deleteButton.userInteractionEnabled = NO;
        }
    } else {
        currentIndex = indexPath;
        PicturesScrollerView *view = [[PicturesScrollerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
        GetPhotoItems *item = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = item.List;
        [view setUpNavigation:[NSString stringWithFormat:@"%d/%d",(int)currentIndex.row + 1,array.count] navigationColor:theLoginButtonColor];
        for (NSInteger i = 0; i < array.count; i++) {
            GetPhotoItemList *itemList = [array objectAtIndex:i];
            [view.photoArray addObject:itemList.PhotoUrl];
        }
        view.startIndex = indexPath.row;
        view.pictureScrollerViewDelegate = self;
        view.isShowNavigationBar = YES;
        [self.view addSubview:view];
        [self.navigationController setNavigationBarHidden:YES];
        backToSelfView = YES;
    }
}
#pragma mark - 上传图片
-(void)uploadImage:sender
{
    if(isPictuterUpload){
        [self.navigationController pushViewController:MyClassPassOnPicVCID
                                       withStoryBoard:DiscoverStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                MyClassPassesOnThePictureViewController *vc = (MyClassPassesOnThePictureViewController*)viewController;
                                                vc.classId = self.classId;
                                                vc.block = ^{
                                                    [self headerReresh];
                                                };
                                            }];
    }else{
        [self showImage:nil status:@"没有权限，不能上传照片"];
    }
}
#pragma mark - 显示底部删除选择内容视图

- (void)selectPictures:(UIBarButtonItem*)button
{
    if (isAuthority) {
        if (button.tag == 1) {
            button.title = @"取消";
            button.tag = 2;
            self.bEditMode = YES;
            [self showDeleteView];
        } else if (button.tag == 2) {
            button.title = @"选择";
            button.tag = 1;
            self.bEditMode = NO;
            [self hideDeleteView];
            [selectArray removeAllObjects];
            selectNum = 0;
            totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",(int)selectNum];
            [self.collectionView reloadData];
        }
    }else{
        [self showImage:nil status:@"没有权限，不能删除"];
    }
}

-(void)showDeleteView
{
    if (!deleteView) {
        deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 50)];
        deleteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:deleteView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.4;
        [deleteView addSubview:lineView];
        
        allselect = [UIButton buttonWithType:UIButtonTypeCustom];
        allselect.frame = CGRectMake(10, 10, 70, 30);
        [allselect setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [allselect setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [allselect setTitle:@"全选" forState:UIControlStateNormal];
        [allselect setTitle:@"取消" forState:UIControlStateSelected];
        [allselect addTarget:self action:@selector(selectDeleteAll:) forControlEvents:UIControlEventTouchUpInside];
        allselect.layer.masksToBounds = YES;
        allselect.layer.cornerRadius = 3;
        allselect.layer.borderWidth = 1;
        allselect.layer.borderColor = [UIColor greenColor].CGColor;
        [deleteView addSubview:allselect];
        
        totleSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 1, 150, 50)];
        totleSelectLabel.text = @"已选（0）";
        totleSelectLabel.center = CGPointMake(SCREENWIDTH/2, totleSelectLabel.center.y);
        totleSelectLabel.textAlignment = NSTextAlignmentCenter;
        totleSelectLabel.textColor = theLoginButtonColor;
        [deleteView addSubview:totleSelectLabel];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(SCREENWIDTH - 90, 10, 70, 30);
        deleteButton.backgroundColor = [UIColor grayColor];
        deleteButton.userInteractionEnabled = NO;
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.cornerRadius = 3;
        [deleteView addSubview:deleteButton];
    }
    [UIView animateWithDuration:0.35 animations:^{
        deleteView.center = CGPointMake(deleteView.center.x, deleteView.center.y - deleteView.frame.size.height);
    } completion:^(BOOL finished) {
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height - 50);
    }];
}
-(void)hideDeleteView
{
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height + 50);
    [UIView animateWithDuration:0.35 animations:^{
        deleteView.center = CGPointMake(deleteView.center.x, deleteView.center.y + deleteView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -删除图片网络操作
-(void)deletePic:(UIButton*)sender
{
    self.request = [[ASIFormDataRequest alloc] init];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/class/DeletePhoto",aedudomain]]]];
    [self show];
    [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"toKen"];
    [self.request setPostValue:@"2" forKey:@"TypeId"];
    for (NSInteger i = 0; i < selectArray.count; i++) {
        [self.request addPostValue:[selectArray objectAtIndex:i] forKey:@"ObjectId"];
    }
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
    [self.request startAsynchronous];
    
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self showImage:nil status:@"删除图片失败"];
    
    NSLog(@"The error is:%@", theRequest.error);
}

- (void)uploadSendFinished:(ASIHTTPRequest *)theRequest
{
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    GetPhotoList *albumList = [[GetPhotoList alloc] initWithDictionary:dict error:nil];
    if (albumList.result == 1) {
            isSelectAll = YES;
            [selectArray removeAllObjects];
            allselect.selected = !allselect.selected;
            [self headerReresh];
            totleSelectLabel.text = @"已选（0）";
            deleteButton.backgroundColor = [UIColor grayColor];
            deleteButton.userInteractionEnabled = NO;
            [self dismiss];
    }else{
        [self showImage:nil status:@"删除图片失败"];
    }
}
#pragma mark - 全选点击事件
-(void)selectDeleteAll:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [selectArray removeAllObjects];
        totleSelectLabel.text = @"已选（0）";
        deleteButton.backgroundColor = [UIColor grayColor];
        deleteButton.userInteractionEnabled = NO;
    }else{
        for (NSInteger i = 0; i < dataArray.count; i++) {
            GetPhotoItems *item = [dataArray objectAtIndex:i];
            NSArray *array = item.List;
            for (GetPhotoItemList *itemLiset in array) {
                [selectArray addObject:itemLiset.PhotoId];
            }
        }
        totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",selectArray.count];
        deleteButton.backgroundColor = theLoginButtonColor;
        deleteButton.userInteractionEnabled = YES;
    }
    
    [self.collectionView reloadData];
}

-(void)rightButtonEvent:(NSInteger)i
{
    [self.navigationController setNavigationBarHidden:NO];
    GetPhotoItems *item = [dataArray objectAtIndex:currentIndex.section];
    GetPhotoItemList *itemList = [item.List objectAtIndex:i];
    PictureDetailViewController *view = [[PictureDetailViewController alloc] init];
    view.photoId = itemList.PhotoId;
    [self.navigationController pushViewController:view animated:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
}
//单张图片浏览返回处理
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (backToSelfView) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}
-(void)back{
    backToSelfView = NO;
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

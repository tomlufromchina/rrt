//
//  MyClassAlbumViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyClassAlbumViewController.h"
#import "AlbumPictureViewController.h"
#import "PictureCollectionViewCell.h"
#import "AlbumList.h"

@interface MyClassAlbumViewController ()< UIActionSheetDelegate>
{
    UIButton *allselect;
    UILabel *totleSelectLabel;//已选删除数量显示label
    UIView *deleteView; //删除视图操作界面
    NSMutableArray *selectArray; //已选删除数组（indexPath）
//    NSInteger selectNum; 
    NSMutableArray *photoAry; //相册列表数组
    BOOL isSelectAll;//全选标志
    UIButton *deleteButton; //删除相册按钮
    
    BOOL isAuthority;//判断相册删除操作权限
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@property (nonatomic, assign) BOOL bEditMode; //删除操作标志


@end

@implementation MyClassAlbumViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAlbumList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bEditMode = NO;
    selectArray = [[NSMutableArray alloc] init];
    photoAry = [[NSMutableArray alloc] init];
    self.title = @"班级相册";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(selectPictures:)];
    rightItem.tag = 1;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
    [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
}
#pragma mark -  获取相册列表
-(void)getAlbumList
{
//    [self showUploadView:LoadingMsg];
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoAblumList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            photoAry = (NSMutableArray*)albumList.items;
            [self.collectionView reloadData];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showImage:nil status:erromodel.msg];
        }
    } fail:^(id errors) {
        [self showImage:nil status:errors];
    } cache:^(id cache) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
            photoAry = (NSMutableArray*)albumList.items;
            [self.collectionView reloadData];
        }
    }];
    [self checkAuthority];
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
            }
        }
    }];
    
}

#pragma mark - UICollectionViewdelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(130, 100);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photoAry.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    AlbumListItems *item = [photoAry objectAtIndex:indexPath.row];
    [cell.image setImageWithUrlStr:item.DefaultPhotoUrl placholderImage:[UIImage imageNamed:@"defaultAlbumss"]];
//    if (isSelectAll && self.bEditMode) {
//        [selectArray addObject:item.AblumId];
//    }
    if ([selectArray containsObject:item.AblumId]) {
        cell.selectImage.hidden = NO;
    }else{
        cell.selectImage.hidden = YES;
    }
    cell.imageName.text = item.AblumName;
    cell.imageNum.text = [NSString stringWithFormat:@"%d",item.PhotoCount.intValue];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bEditMode) {
        PictureCollectionViewCell *cell = (PictureCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        AlbumListItems *item = [photoAry objectAtIndex:indexPath.row];
        if (cell.selectImage.hidden) {
            [selectArray addObject:item.AblumId];
            cell.selectImage.hidden = NO;
        }else{
            [selectArray removeObject:item.AblumId];
            cell.selectImage.hidden = YES;
        }
         if(selectArray.count != photoAry.count){
            if (allselect.selected) {
                allselect.selected = !allselect.selected;
            }
        }
        totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",selectArray.count];
        if (selectArray.count > 0) {
            deleteButton.backgroundColor = theLoginButtonColor;
            deleteButton.userInteractionEnabled = YES;
        }else{
            deleteButton.backgroundColor = [UIColor grayColor];
            deleteButton.userInteractionEnabled = NO;
        }
        
    }else{
        AlbumPictureViewController *view = [[AlbumPictureViewController alloc] init];
        AlbumListItems *item = [photoAry objectAtIndex:indexPath.row];
        view.albumId = item.AblumId;
        view.classId = self.classId;
        [self.navigationController pushViewController:view animated:YES];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:nil
                                                                    action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
    }
}

#pragma mark - 删除相册视图处理
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
            totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",(int)selectArray.count];
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
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAldum:) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - 全选点击事件
-(void)selectDeleteAll:(UIButton*)sender
{
    
    sender.selected = !sender.selected;
    isSelectAll = sender.selected;
    if (!isSelectAll) {
        [selectArray removeAllObjects];
        totleSelectLabel.text = @"已选（0）";
        deleteButton.backgroundColor = [UIColor grayColor];
        
    }else{
        [selectArray removeAllObjects];
        for (AlbumListItems *item in photoAry) {
            [selectArray addObject:item.AblumId];
        }
        totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",photoAry.count];
        deleteButton.backgroundColor = theLoginButtonColor;
        deleteButton.userInteractionEnabled = YES;
    }
    [self.collectionView reloadData];
}

#pragma mark -删除相册网络操作
-(void)deleteAldum:(id)sender
{
    
    self.request = [[ASIFormDataRequest alloc] init];
    [self setRequest:[ASIFormDataRequest requestWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"http://nmapi.%@/class/DeletePhoto",aedudomain]]]];
    [self show];
    [self.request addPostValue:@"1" forKey:@"TypeId"];
    for (NSInteger i = 0; i < selectArray.count; i++) {
        NSString *albumID = [selectArray objectAtIndex:i];
        [self.request addPostValue:albumID forKey:@"ObjectId"];
    }
    [self.request setTimeOutSeconds:20];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(uploadFailed:)];
    [self.request setDidFinishSelector:@selector(uploadSendFinished:)];
    [self.request startAsynchronous];

    
    
}
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self showImage:nil status:@"删除相册失败"];
    
    NSLog(@"The error is:%@", theRequest.error);
}


- (void)uploadSendFinished:(ASIHTTPRequest *)theRequest
{
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    GetPhotoList *albumList = [[GetPhotoList alloc] initWithDictionary:dict error:nil];
    //    NSArray *selectArry = [NSArray arrayWithArray:selectAry];
    if (albumList.result == 1) {
        allselect.selected = !allselect.selected;
        [selectArray removeAllObjects];
        [self getAlbumList];
        totleSelectLabel.text = @"已选（0）";
        deleteButton.backgroundColor = [UIColor grayColor];
        deleteButton.userInteractionEnabled = NO;
        [self dismiss];
    }else{
        [self showImage:nil status:@"删除相册失败"];
    }
    
    
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

@end

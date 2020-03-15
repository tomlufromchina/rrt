//
//  AlbumListViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-1.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AlbumListViewController.h"
#import "CreateAlbumViewController.h"
#import "AlbumList.h"
#import "MJRefresh.h"

@interface AlbumListViewController ()
{
    NSInteger dataPage;
    NSInteger currentPage;//分页获取，当前页数
    BOOL isHeadRefresh; //判断是否头更新
    BOOL isFootRefresh; //判断是否根更新
}

@property (nonatomic, strong)NetWorkManager *netWorkManager;
@property (nonatomic, strong)NSMutableArray *albums;

@end

@implementation AlbumListViewController

#pragma mark - viewController lifecycle
#pragma mark -
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataPage = 1;
    currentPage = 1;
    self.title = @"选择相册";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    if (!self.isHideRightNavigationButton) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新建相册"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(createNewAlbum)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }else{
        [self setupRefresh];
    }
    
    
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    //获取有哪些相册
    
    [self initData];
}

- (void)initData
{
    [self show];
    if (self.isHideRightNavigationButton) {
        NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoAblumList",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",nil];
        
        [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
            AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
            if (albumList.result == 1) {
                if (dataPage == 1) {
                    self.albums = (NSMutableArray*)albumList.items;
                }else{
                    [self.albums addObjectsFromArray:albumList.items];
                    
                }
                [self.tableView reloadData];
            }else{
                dataPage = currentPage;
            }
            [self endRefresh];
            [self dismiss];
        } fail:^(id errors) {
            dataPage = currentPage;
            [self endRefresh];
            [self dismiss];
        } cache:^(id cache) {
        }];
        
    }else{
        [self.netWorkManager photoList:[RRTManager manager].loginManager.loginInfo.tokenId
                                UserId:[RRTManager manager].loginManager.loginInfo.userId
                              PageSize:20
                             PageIndex:1
                               success:^(NSArray *photoListArray) {
                                   [self dismiss];
                                   [self updateData:photoListArray];
                               } failed:^(NSString *errorMSG) {
                                   [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"获取相册列表失败"];
                                   
                               }];
    }
}

- (void)updateData:(NSArray*)array
{
    self.albums = array;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albums count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumListCell"
                                                            forIndexPath:indexPath];
    
    UIImageView *albumCoverImgView = (UIImageView*)[cell viewWithTag:1];
    UILabel *albumNameLabel = (UILabel*)[cell viewWithTag:2];
    if (self.isHideRightNavigationButton) {
        AlbumListItems *item = [self.albums objectAtIndex:indexPath.row];
        [albumCoverImgView setImageWithUrlStr:item.ablumFace
                              placholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
        albumNameLabel.text = item.AblumName;
    }else{
        
        PhotoList *album = (PhotoList*)[self.albums objectAtIndex:indexPath.row];
        
        [albumCoverImgView setImageWithUrlStr:album.CoverPatch
                              placholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
        albumNameLabel.text = album.AlbumName;
    }
    
    return cell;
}

#pragma mark - Table view data delegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isHideRightNavigationButton) {
        AlbumListItems *item = [self.albums objectAtIndex:indexPath.row];
        self.block(item);
    }else{
        PhotoList *album = (PhotoList*)[self.albums objectAtIndex:indexPath.row];
        self.block(album);
    }
    
    
    
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.2f];
}

#pragma mark - Ubility
#pragma mark -
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNewAlbum
{
    //新建相册
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:ActivityStoryBoardName bundle:nil];
    
    CreateAlbumViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:
                                     CreateAlbumVCID];
    
    vc.createAlbumBlock = ^(){
        //重新获取相册
        [self initData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerReresh)];
}
- (void)headerReresh
{
    if (!isHeadRefresh) {
        currentPage = dataPage;
        dataPage = 1;
        isHeadRefresh = YES;
        [self initData];
    }
}

- (void)footerReresh
{
    if (!isFootRefresh) {
        currentPage = dataPage;
        dataPage++;
        isFootRefresh = YES;
        [self initData];
    }
    
    
}
-(void)endRefresh
{
    if (isHeadRefresh) {
        [self.tableView headerEndRefreshing];
        isHeadRefresh = NO;
    }
    if (isFootRefresh){
        [self.tableView footerEndRefreshing];
        isFootRefresh = NO;
    }
}
@end

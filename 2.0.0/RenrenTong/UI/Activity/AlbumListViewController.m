//
//  AlbumListViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-1.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AlbumListViewController.h"
#import "CreateAlbumViewController.h"

@interface AlbumListViewController ()

@property (nonatomic, strong)NetWorkManager *netWorkManager;
@property (nonatomic, strong)NSArray *albums;

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
    
    self.title = @"选择相册";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新建相册"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(createNewAlbum)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    //获取有哪些相册
    
    [self getData];
}

- (void)getData
{
    [self showWithStatus:@""];
    [self.netWorkManager photoList:[RRTManager manager].loginManager.loginInfo.tokenId
                            UserId:[RRTManager manager].loginManager.loginInfo.userId
                          PageSize:20
                         PageIndex:1
                           success:^(NSArray *photoListArray) {
                               [self dismiss];
                               [self updateData:photoListArray];
                           } failed:^(NSString *errorMSG) {
                               [self showWithTitle:@"获取相册列表失败" withTime:2.0f];
                           }];
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

    PhotoList *album = (PhotoList*)[self.albums objectAtIndex:indexPath.row];
    
    [albumCoverImgView setImageWithUrlStr:album.CoverPatch
                          placholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
    albumNameLabel.text = album.AlbumName;

    return cell;
}

#pragma mark - Table view data delegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PhotoList *album = (PhotoList*)[self.albums objectAtIndex:indexPath.row];
    
    self.block(album);
    
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
        [self getData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

@end

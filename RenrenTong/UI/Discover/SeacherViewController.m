//
//  SeacherViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-11-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SeacherViewController.h"
#import "BindFamilyValidationViewController.h"
#import "ChatViewController.h"
#import "ContactDetailViewController.h"
#import "PhotoUITapGestureRecognizer.h"
#import "SearcherCell.h"

#import "MLEmojiLabel.h"
#import "MJRefresh.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface SeacherViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate>

{
    int recpageIndex;
    int recpageSize;
    int sendpageIndex;
    int sendpageSize;
    int pciPageSize;
    int pciPageIndex;
    int namePageIndex;
    int namePageSize;
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, strong) NSMutableArray *dataSource3;
@property (nonatomic, assign) NSInteger buttonIndex;
@property (nonatomic, assign) BOOL isClick;// 判断选择展示选择类型还是请求
@property (nonatomic, strong) NSMutableArray *emjoalablearray;


@end

@implementation SeacherViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"搜索";
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.navigationController.navigationBar.translucent = NO;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.dataSource2= [[NSMutableArray alloc] init];
    self.dataSource3 = [[NSMutableArray alloc] init];
    self.emjoalablearray = [[NSMutableArray alloc] init];
    
    [self.searcherButton setTintColor:[UIColor whiteColor]];
    [self.searcherButton setImage:[UIImage imageNamed:@"f3"]forState:UIControlStateNormal];
    [self.searcherButton.layer setMasksToBounds:YES];
    [self.searcherButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.searcherButton.layer setBorderWidth:1.0]; //边框宽度
    self.searcherButton.layer.borderColor = appColor.CGColor;
    // 设置光标颜色
    self.textField.tintColor = appColor;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    //初始化上拉刷新和下拉加载更多
    [self setupRefresh];
    
    recpageIndex = 1;
    recpageSize = 7;
    sendpageIndex = 1;
    sendpageSize = 7;
    pciPageIndex = 1;
    pciPageSize = 7;
    namePageIndex = 1;
    namePageSize = 7;
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}
#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __weak SeacherViewController *_self = self;
    if (self.buttonIndex == 0) {
        [self show];
        sendpageIndex=1;
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:1
                            PageSize:sendpageSize
                           PageIndex:sendpageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self.emjoalablearray removeAllObjects];
                                 [_self.dataSource removeAllObjects];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView headerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView headerEndRefreshing];
                             }];
        
    } else if (self.buttonIndex == 1){
        recpageIndex = 1;
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:2
                            PageSize:recpageSize
                           PageIndex:recpageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self.emjoalablearray removeAllObjects];
                                 [_self.dataSource removeAllObjects];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView headerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView headerEndRefreshing];
                             }];
        
    } else if (self.buttonIndex == 2){
        pciPageIndex = 1;
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:3
                            PageSize:pciPageSize
                           PageIndex:pciPageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self.emjoalablearray removeAllObjects];
                                 [_self.dataSource removeAllObjects];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView headerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView headerEndRefreshing];
                             }];
        
    } else{
        namePageIndex = 1;
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:4
                            PageSize:namePageSize
                           PageIndex:namePageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self.emjoalablearray removeAllObjects];
                                 [_self.dataSource removeAllObjects];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView headerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView headerEndRefreshing];
                             }];
        
    }
    
}

- (void)footerReresh
{
    __weak SeacherViewController *_self = self;
    if (self.buttonIndex == 0) {
        [self show];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:1
                            PageSize:sendpageSize
                           PageIndex:sendpageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView footerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView footerEndRefreshing];
                             }];
        
    } else if (self.buttonIndex == 1){
        [self show];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:2
                            PageSize:recpageSize
                           PageIndex:recpageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView footerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView footerEndRefreshing];
                             }];
        
    } else if (self.buttonIndex == 2){
        [self show];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:3
                            PageSize:pciPageSize
                           PageIndex:pciPageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView footerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView footerEndRefreshing];
                             }];
        
    } else{
        [self show];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:4
                            PageSize:namePageSize
                           PageIndex:namePageIndex
                             success:^(NSMutableArray *data) {
                                 [_self dismiss];
                                 [_self gotoUpdataUI:data];
                                 [_self.mainTableView footerEndRefreshing];
                             } failed:^(NSString *errorMSG) {
                                 [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                 [_self.mainTableView footerEndRefreshing];
                             }];
        
    }
}
#pragma mark -- 搜索按钮响应

- (IBAction)clickSearchButton:(UIButton *)sender
{
    if (self.textField.text.length == 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入关键字"];

        
    } else {
        if (!self.isClick) {
            CGFloat xWidth = self.view.bounds.size.width - 20.0f;
            CGFloat yHeight = 272.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
            poplistview.delegate = self;
            poplistview.datasource = self;
            poplistview.listView.scrollEnabled = FALSE;
            [poplistview setTitle:@"选择类型"];
            [poplistview show];
            
        } else{
            // 微博
            if (self.buttonIndex == 0) {
                [self show];
                [self.emjoalablearray removeAllObjects];
                [self.dataSource removeAllObjects];
                [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                                     KeyWord:self.textField.text
                                      TypeId:1
                                    PageSize:7
                                   PageIndex:1
                                     success:^(NSMutableArray *data) {
                                         [self dismiss];
                                         [self gotoUpdataUI:data];
                                     } failed:^(NSString *errorMSG) {
                                         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     }];
             // 日志
            } else if (self.buttonIndex == 1){
                [self show];
                [self.emjoalablearray removeAllObjects];
                [self.dataSource removeAllObjects];
                [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                                     KeyWord:self.textField.text
                                      TypeId:2
                                    PageSize:7
                                   PageIndex:1
                                     success:^(NSMutableArray *data) {
                                         [self dismiss];
                                         [self gotoUpdataUI:data];
                                     } failed:^(NSString *errorMSG) {
                                         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     }];
             // 图片
            } else if (self.buttonIndex == 2){
                [self show];
                [self.emjoalablearray removeAllObjects];
                [self.dataSource removeAllObjects];
                [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                                     KeyWord:self.textField.text
                                      TypeId:3
                                    PageSize:7
                                   PageIndex:1
                                     success:^(NSMutableArray *data) {
                                         [self dismiss];
                                         [self gotoUpdataUI:data];
                                     } failed:^(NSString *errorMSG) {
                                         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     }];
            // 人名
            } else {
                [self show];
                [self.emjoalablearray removeAllObjects];
                [self.dataSource removeAllObjects];
                [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                                     KeyWord:self.textField.text
                                      TypeId:4
                                    PageSize:7
                                   PageIndex:1
                                     success:^(NSMutableArray *data) {
                                         [self dismiss];
                                         [self gotoUpdataUI:data];
                                     } failed:^(NSString *errorMSG) {
                                         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     }];
            }
            
        }
        
    }
}

#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
    
    NSInteger row = indexPath.row;
    
    if(row == 0){
        cell.textLabel.text = @"搜微博";
//        cell.imageView.image = [UIImage imageNamed:@"dynamic_wb.png"];
    }else if (row == 1){
        cell.textLabel.text = @"搜日志";
//        cell.imageView.image = [UIImage imageNamed:@"dynamic_diary"];
    }else if (row == 2){
        cell.textLabel.text = @"搜图片";
//        cell.imageView.image = [UIImage imageNamed:@"dynamic_pic.png"];
    }else {
        cell.textLabel.text = @"搜人名";
//        cell.imageView.image = [UIImage imageNamed:@"dynamic_camera.png"];
    }
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    self.isClick = YES;
    self.buttonIndex = indexPath.row;
    if (indexPath.row == 0) {
        [self show];
        [self.emjoalablearray removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:1
                            PageSize:7
                           PageIndex:1
                             success:^(NSMutableArray *data) {
                                 [self dismiss];
                                 [self gotoUpdataUI:data];
                             } failed:^(NSString *errorMSG) {
                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                             }];
        
    } else if (indexPath.row == 1){
        [self show];
        [self.emjoalablearray removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:2
                            PageSize:7
                           PageIndex:1
                             success:^(NSMutableArray *data) {
                                 [self dismiss];
                                 [self gotoUpdataUI:data];
                             } failed:^(NSString *errorMSG) {
                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                             }];
        
    } else if (indexPath.row == 2){
        [self show];
        [self.emjoalablearray removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:3
                            PageSize:7
                           PageIndex:1
                             success:^(NSMutableArray *data) {
                                 [self dismiss];
                                 [self gotoUpdataUI:data];
                             } failed:^(NSString *errorMSG) {
                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                             }];
        
    } else{
        [self show];
        [self.emjoalablearray removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.netWorkManager seacher:[RRTManager manager].loginManager.loginInfo.userId
                             KeyWord:self.textField.text
                              TypeId:4
                            PageSize:7
                           PageIndex:1
                             success:^(NSMutableArray *data) {
                                 [self dismiss];
                                 [self gotoUpdataUI:data];
                             } failed:^(NSString *errorMSG) {
                                 [self showErrorWithStatus:errorMSG];
                             }];
        
    }
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
#pragma mark -- 数据刷新界面
- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
        for (int i = 0; i < [data count]; i ++) {
            SeacherObject *obj=[data objectAtIndex:i];
            if (obj.TypeId == 1 || obj.TypeId == 2 ) {
                [self.dataSource addObject:obj];
                [self.emjoalablearray addObject:[self createLableWithText:obj.Body
                                                                     font:[UIFont systemFontOfSize:15]
                                                                    width:SCREENWIDTH - 60]];
            } else if (obj.TypeId == 3){
                [self.dataSource addObject:obj];
                [self.emjoalablearray addObject:[self createLableWithText:obj.Description
                                                                     font:[UIFont systemFontOfSize:15]
                                                                    width:SCREENWIDTH - 60]];
            } else if (obj.TypeId == 4){
                [self.dataSource addObject:obj];
                [self.emjoalablearray addObject:[self createLableWithText:obj.Description
                                                                     font:[UIFont systemFontOfSize:15]
                                                                    width:SCREENWIDTH - 60]];
                
            }
        }
        self.mainTableView.hidden = NO;
        [self.mainTableView reloadData];
        sendpageIndex ++;
        recpageIndex ++;
        pciPageIndex ++;
        namePageIndex ++;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeacherObject *SO = [self.dataSource objectAtIndex:indexPath.row];
    CGFloat height = 0;
    if (SO.TypeId == 1 || SO.TypeId == 2 || SO.TypeId ==4) {
        if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
            height = 45;
            height += ((MLEmojiLabel*)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
            height += 10;
        }
    }
    if (SO.TypeId == 3 && SO.RelativePath.length > 0) {
        height = 45;
        height += 80;// 图片高度
        height += ((MLEmojiLabel *)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
        height += 10;// 底部预留10
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearcherCell";
    SearcherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearcherCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SeacherObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    [cell.headerView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain, obj.UserId]]];
    cell.nameLabel.text = obj.UserName;
    cell.timeLabel.text = obj.DateTime;
    
    //防止重用问题
    UIView *emjoView = (UIView *)[cell viewWithTag:103];
    if (emjoView) {
        [emjoView removeFromSuperview];
    }
    
    cell.manIMG.hidden = YES;
    cell.womenIMG.hidden = YES;
    
    cell.content = [self.emjoalablearray objectAtIndex:indexPath.row];
    cell.content.top = cell.timeLabel.bottom;
    cell.content.left = cell.timeLabel.left;
    cell.content.tag = 103;
    [cell addSubview:[self.emjoalablearray objectAtIndex:indexPath.row]];
    // 搜图片
    if (obj.TypeId == 3) {
        [self loadPhoto:cell SO:obj];
    
    // 人名
    } else if (obj.TypeId == 4){
        cell.timeLabel.text = obj.Schools;
        [cell.addFriend setTintColor:[UIColor whiteColor]];
        [cell.addFriend setBackgroundColor:appColor];
        [cell.addFriend.layer setMasksToBounds:YES];
        [cell.addFriend.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [cell.addFriend.layer setBorderWidth:1.0]; //边框宽度
        cell.addFriend.layer.borderColor = appColor.CGColor;
        cell.addFriend.top = cell.nameLabel.top + 5;
        if (obj.Sex == 0) {
            cell.manIMG.hidden = NO;
            cell.womenIMG.hidden = YES;
        } else if(obj.Sex == 2){
            cell.womenIMG.hidden = NO;
            cell.manIMG.hidden = YES;
        }
        if ([obj.Relevance isEqualToString:@"是好友"]) {
            cell.addFriend.hidden = YES;
            
        } else if ([obj.Relevance isEqualToString:@"不是好友"]){
            cell.addFriend.hidden = NO;
        }
        
        cell.userName.text = obj.Roles;
        
        [cell.addFriend addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SeacherObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    
    if (obj.TypeId == 4) {
        // 接口返回的bool不能判断，只能用字符串
        if ([obj.Relevance isEqualToString:@"是好友"]) {
            [self.navigationController pushViewController:ChatVCID
                                           withStoryBoard:MessageStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    ChatViewController *vc = (ChatViewController*)viewController;
                                                    vc.UserName=obj.UserName;
                                                    vc.UserId=obj.UserId;
                                                }];
            
        } else if ([obj.Relevance isEqualToString:@"不是好友"]){
            [self.navigationController pushViewController:ContactDetailVCID
                                           withStoryBoard:ContactStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                                    vc.OUserId = obj.UserId;
                                                }];
        }
    }
    

}

#pragma mark -- 计算图片高度
- (void)loadPhoto:(SearcherCell *)cell SO:(SeacherObject*)SO
{
    if (SO.RelativePath.length > 0) {
        
        //防止重用问题
        UIView *emjoView = (UIView *)[cell viewWithTag:1000];
        if (emjoView) {
            [emjoView removeFromSuperview];
        }
        
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        cell.photoview = [[UIView alloc] init];
        CGFloat width = 70;
        CGFloat height = 70;
        CGFloat margin = 10;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell.photoview addSubview:imageView];
        
        // 计算位置
        int row = 0/3;
        int column = 0%3;
        CGFloat x =  column * (width + margin);
        CGFloat y =  row * (height + margin);
        imageView.frame = CGRectMake(x, y, width, height);
        NSString* urlstr;
        urlstr = SO.RelativePath;
        
        // 下载图片
        [imageView setImageURLStr:urlstr placeholder:placeholder];
        // 事件监听
        imageView.tag = 1;
        imageView.userInteractionEnabled = YES;
        PhotoUITapGestureRecognizer *tap = [[PhotoUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        tap.so = SO;
        tap.img = imageView;
        [imageView addGestureRecognizer:tap];
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.photoview setFrame:CGRectMake(cell.timeLabel.left , cell.content.bottom+10, SCREENWIDTH - 40, 70)];
        cell.photoview.tag = 1000;
        // 将图片添加到Cell上
        [cell addSubview:cell.photoview];
    }
}

#pragma mark -- 展示图片
- (void)tapImage:(PhotoUITapGestureRecognizer *)tap
{
    
    NSUInteger count = 1;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString* url;
        url = tap.so.RelativePath;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = tap.img; // 来源于哪个UIImageView
        [photos addObject:photo];
        
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark -- 添加好友

- (void)addFriend:(UIButton *)sender
{
    __weak SeacherViewController *_self = self;
    //获取NSIndexPath和cell上面的每个button
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.mainTableView];
    NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:hitPoint];
    
    __weak SeacherObject *tmp = (SeacherObject*)[self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@",tmp.UserId);

    [self show];
    [self.netWorkManager addStrangers:[RRTManager manager].loginManager.loginInfo.tokenId
                               UserId:tmp.UserId
                         SenderUserId:[RRTManager manager].loginManager.loginInfo.userId
                               Sender:[RRTManager manager].loginManager.loginInfo.userName
                            InviteTxt:@"你好！很高兴认识你。"
                              success:^(NSString *data) {
                                  [_self updateUI:data];
        
    } failed:^(NSString *errorMSG) {
        [_self showErrorWithStatus:errorMSG];

    }];
}

- (void)updateUI:(NSString *)data
{
    [self showSuccessWithStatus:data];
}

#pragma mark emjolable

-(MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
    MLEmojiLabel*_emojiLabel= [[MLEmojiLabel alloc]init];
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = font;
    _emojiLabel.emojiDelegate = self;
    _emojiLabel.backgroundColor = [UIColor clearColor];
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emojiLabel.isNeedAtAndPoundSign = YES;
    [_emojiLabel setEmojiText:text];
    _emojiLabel.frame = CGRectMake(0, 0, width, 0);
    [_emojiLabel sizeToFit];
    return _emojiLabel;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

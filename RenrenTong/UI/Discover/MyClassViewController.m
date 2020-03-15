//
//  MyClassViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyClassViewController.h"
#import "MyClassCell.h"
#import "MyClassAmongCell.h"
#import "MJRefresh.h"
#import "TheAllBullentinsViewController.h"
#import "MyClassAlbumViewController.h"
#import "MyClassArticleViewController.h"
#import "MyClassArticleReleaseViewController.h"
#import "SendPicViewController.h"
#import "AlbumList.h"
#import "ArcicleDetailViewController.h"
#import "ArticleOrLogDetailsViewController.h"
#import "MyClassPassesOnThePictureViewController.h"
#import "DynamicCell.h"
#import "PublishCommentView.h"
#import "PublishListAndPraiseView.h"
#import "commentaryToolView.h"
#import "MJRefresh.h"

@interface MyClassViewController ()<UITableViewDataSource, UITableViewDelegate,MyClassListViewDelegate,UITextFieldDelegate,commentaryToolViewDelegate,DynamicCellDelegate>
{
    CGFloat _popoverWidth;
    int sectionTwoCount;
    NSString *_tempClassID;
    NSString *_tempClassName;
    NSString *_tempClassSoglon;
    NSString *_tempClassFace;
    NSMutableArray *praiseArray;// 点赞图片仿重用
    BOOL isArticleAuthority; //文章权限
    BOOL isPictureAuthority; //照片权限
    BOOL isFirstTimes;
    
    commentaryToolView *inputView; //发表评论视图
    NSString *tempToUserID;
    NSString *tempObjectId;
    
    //分页加载处理
    BOOL isHeadEndRefresh;
    BOOL isFootEndRefresh;
    NSMutableArray *tempCacheAry;
}
@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic, strong) MyClassListView *cover;
@property (nonatomic, strong) UITableView *tableView;// 选择班级列表
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *myClassListArray;//班级数据源
@property (nonatomic, strong) NSMutableArray *myClassBulletinArray;//班级公告数据源

// 班级动态相关数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复评论1，还是回复某个人0
@property (nonatomic, assign) int activityIndex;
@property (nonatomic, assign) int commentIndex;
@property (nonatomic, strong) TheMyTendencyList *visitorModel;
@end

@implementation MyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //上拉刷新和下拉加载更多
    isHeadEndRefresh = YES;
    isFootEndRefresh = YES;
    _tempClassID = @"";
    [self setupRefresh];
    [self resetPopover];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.myClassListArray = [NSMutableArray array];
    self.myClassBulletinArray = [NSMutableArray array];
    
    self.dataSource = [[NSMutableArray alloc] init];
    praiseArray = [NSMutableArray array];
    
    sectionTwoCount = 1;
    self.pageIndex = 1;
    self.pageSize = 5;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.mainTableView reloadData];
    [self initView];
    [self getMyclassListData];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainTableView addGestureRecognizer:tapGesture];
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
    if (isHeadEndRefresh) {
        self.pageIndex = 1;
        [self requestClassBulletin];
        [self getClassDynamicData];
    }
}

- (void)footerReresh
{
    if (isFootEndRefresh) {
        [self getClassDynamicData];
    }
}

#pragma mark -- 加载数据
#pragma mark --
  // 我的班级列表
-(void)getMyclassListData
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetClassList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userRole,@"UserRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:json error:nil];
        if (list.result == 1) {
            self.myClassListArray =(NSMutableArray*)list.items;
            MyCurrentClassListModelitems *obj = self.myClassListArray[0];
            _tempClassName = obj.ClassName;
            [self.titlebtn setTitle:_tempClassName forState:UIControlStateNormal];
            
            _tempClassID = obj.ClassId;
            _tempClassSoglon = obj.Slogan;
            _tempClassFace = obj.ClassFace;
            [self.mainTableView reloadData];
            [self.titlebtn setTitle:_tempClassName forState:UIControlStateNormal];
            [self checkAuthority];
            [self requestClassBulletin];// 默认第一个
            [self getClassDynamicData];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            self.myClassListArray = (NSMutableArray*)list.items;
            MyCurrentClassListModelitems *obj = self.myClassListArray[0];
            _tempClassName = obj.ClassName;
            [self.titlebtn setTitle:_tempClassName forState:UIControlStateNormal];
            
            _tempClassID = obj.ClassId;
            [self requestClassBulletin];// 默认第一个
            _tempClassSoglon = obj.Slogan;
            _tempClassFace = obj.ClassFace;
            [self.mainTableView reloadData];
            [self.titlebtn setTitle:_tempClassName forState:UIControlStateNormal];
            [self checkAuthority];
            [self getClassDynamicData];
        }
    }];
}


#pragma mark -- 获取班级公告
#pragma mark -- 

- (void)requestClassBulletin
{
    // 获取班级公告
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetNoticeList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_tempClassID,@"classId",@"1",@"pageIndex",@"2",@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassModelBulletin *list = [[MyCurrentClassModelBulletin alloc] initWithString:json error:nil];
        if (list.result == 1) {
            self.myClassBulletinArray = (NSMutableArray*)list.items;
            [self.mainTableView reloadData];
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        MyCurrentClassModelBulletin *list = [[MyCurrentClassModelBulletin alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            self.myClassBulletinArray = (NSMutableArray*)list.items;
            [self.mainTableView reloadData];
        }
    }];
    
}
-(void)getClassDynamicData
{
    // 班级动态
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetClassActivity",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"typeId",_tempClassID,@"classId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theMyTendency.st == 0) {
            if (self.pageIndex == 1) {
                isHeadEndRefresh = YES;
                [self.mainTableView headerEndRefreshing];
                [self.mainTableView footerEndRefreshing];
            }else{
                isFootEndRefresh = YES;
                [self.mainTableView footerEndRefreshing];
            }
            [self updateView:theMyTendency.msg.list];
            self.pageIndex ++;
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            if (self.pageIndex == 1) {
                isHeadEndRefresh = YES;
                [self.mainTableView headerEndRefreshing];
                [self.mainTableView footerEndRefreshing];
            }else{
                isFootEndRefresh = YES;
                [self.mainTableView footerEndRefreshing];
            }
            [self showUploadView:erromodel.msg];
        }
    } fail:^(id errors) {
        if (self.pageIndex == 1) {
            isHeadEndRefresh = YES;
            [self.mainTableView headerEndRefreshing];
            [self.mainTableView footerEndRefreshing];
        }else{
            isFootEndRefresh = YES;
            [self.mainTableView footerEndRefreshing];
        }
        [self showUploadView:errors];
    } cache:^(id cache) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theMyTendency.st == 0) {
            if (theMyTendency.msg.list && self.pageIndex > 1) {
                tempCacheAry = (NSMutableArray*)theMyTendency.msg.list;
            }
            [self updateView:theMyTendency.msg.list];
        }
    }];

}

- (void)updateView:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        if (self.pageIndex > 1) {
            //判断有无缓存数据，有则去除缓存
            if (tempCacheAry && tempCacheAry.count >0) {
                [self.dataSource removeObjectsInArray:tempCacheAry];
            }
            [self.dataSource addObjectsFromArray:data];
        }else{
            self.dataSource = data;
        }
        [self.mainTableView reloadData];
    }
}

#pragma mark -- 初始化titleview控件
#pragma mark --

- (void)initView
{
    UIView *titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.titlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titlebtn.frame = CGRectMake(5, 9, 170, 26);
    [self.titlebtn addTarget:self action:@selector(titlebtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titlebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.titlebtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [self.titlebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleview addSubview:self.titlebtn];
    
    UIButton *drwonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drwonButton.top = 20;
    drwonButton.left = self.titlebtn.right - 15;
    drwonButton.width = 15;
    drwonButton.height = 8;
    [drwonButton setBackgroundImage:[UIImage imageNamed:@"xljt-"] forState:UIControlStateNormal];
    [drwonButton addTarget:self action:@selector(drwonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    drwonButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    [titleview addSubview:drwonButton];
    self.navigationItem.titleView = titleview;
    
    //right button
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [rightButton setImage:[UIImage imageNamed:@"normaltitle_plus"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addActions)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, _popoverWidth, 200);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.tableView = blueView;
    [self.tableView setSeparatorColor:theLoginButtonColor];
    
    
    inputView = [[commentaryToolView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 50)];
    inputView.delegate = self;
    [inputView.iconBtn removeFromSuperview];
    inputView.textView.frame = CGRectMake(10, 10, SCREENWIDTH - CGRectGetMaxX(inputView.iconBtn.frame) - 45, 30);
    inputView.lineImgView.frame = CGRectMake(10, 35, SCREENWIDTH - CGRectGetMaxX(inputView.iconBtn.frame) - 45, 4);
    [self.view addSubview:inputView];
    
    //register keyboard note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - keyboard show and hide
#pragma mark -
- (void)keyboardShow:(NSNotification *)note
{
    inputView.procLable.hidden = YES;
    self.mainTableView.bounces = NO;
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height - 50;
    [UIView animateWithDuration:0.25 animations:^{
        inputView.transform = CGAffineTransformMakeTranslation(0,ty);
    }];
    
}

- (void)keyboardHide:(NSNotification *)note
{
    if (inputView.textView.text.length == 0) {
        inputView.procLable.hidden = NO;
    }
    self.mainTableView.bounces = YES;
    inputView.transform = CGAffineTransformIdentity;
}

#pragma mark -- 初始化DXPopover
#pragma mark --
- (void)resetPopover
{
    self.popover = [DXPopover new];
    _popoverWidth = 170;
}

- (void)titlebtnClick:(UIButton *)sender
{
    [self updateTableViewFrame];
    
    UIView *titleView = self.navigationItem.titleView;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(titleView.frame), CGRectGetMaxY(titleView.frame) + 20);
    // 初始化选择班级列表
    [self.popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.tableView inView:self.view];
    __weak typeof(self)weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:titleView];
    };
}

- (void)drwonButtonClick:(UIButton *)sender
{
    [self titlebtnClick:self.titlebtn];
}
#pragma mark  - 权限检查请求
-(void)checkAuthority
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetAuthority",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_tempClassID,@"classId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:json error:nil];
        if (result.result == 1 ) {
            for (GetAuthorityItem *item in result.items) {
                if ([item.AuthDes isEqualToString:@"文章上传"] && item.IsOwn) {
                    isArticleAuthority = YES;
                }
                if ([item.AuthDes isEqualToString:@"相片上传"] && item.IsOwn) {
                    isPictureAuthority = YES;
                }
            }
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:cache error:nil];
        if (result.result == 1 ) {
            for (GetAuthorityItem *item in result.items) {
                if ([item.AuthDes isEqualToString:@"文章上传"] && item.IsOwn) {
                    isArticleAuthority = YES;
                }
                if ([item.AuthDes isEqualToString:@"相片上传"] && item.IsOwn) {
                    isPictureAuthority = YES;
                }
            }
        }
    }];
}

- (void)addActions
{
    MyClassListView *cover = [[MyClassListView alloc] init];
    self.cover = cover;
    cover.delegate = self;
    [self.cover show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.mainTableView) {
        return 3;
    } else{
        return 1;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        if (indexPath.section == 0) {
            return 115;
        } else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                return 139;
            } else{
                return 105;
            }
        } else{
            DynamicCell *cell = [[DynamicCell alloc] init];
            if ([self.dataSource count] && [self.dataSource count] > 0) {
                cell.model = [self.dataSource objectAtIndex:indexPath.row];
            }
            return cell.height;
        }
    } else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        if (section == 0) {
            return 0.01;
        } else{
            return 20;
        }
    } else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:18];
        headerLabel.frame = CGRectMake(10.0, -5, 300.0, 20.0);
        if (section == 0) {
            headerLabel.text =  @"";
        }else if (section == 1){
            headerLabel.text = @"班级公告";
        }else if (section == 2){
            headerLabel.text = @"班级动态";
        }
        [customView addSubview:headerLabel];
        return customView;
    } else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        if (section == 0) {
            return 1;
        } else if (section == 1){
            if (self.myClassBulletinArray && [self.myClassBulletinArray count] > 0) {
                if ([self.myClassBulletinArray count] == 1) {
                    return 1;
                } else{
                    return [self.myClassBulletinArray count];
                }
            } else{
                return sectionTwoCount;

            }
        } else{
            if ([self.dataSource count] && [self.dataSource count] > 0) {
                return [self.dataSource count];
            } else{
                return 0;
            }
        }
    } else{
        return self.myClassListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        if (indexPath.section == 0) {
            static NSString *cellIdentifier = @"MyClassCell";
            //自定义cell类
            MyClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                //通过xib的名称加载自定义的cell
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyClassCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.myClassListArray && [self.myClassListArray count] > 0) {
                cell.classNameLabel.text = _tempClassName;
                [cell.userHeaderImageView setImageWithURL:[NSURL URLWithString:_tempClassFace] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
                cell.classSloganLabel.text = _tempClassSoglon;
            }
            [cell.clickArticleButton addTarget:self action:@selector(clickArticleButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.clickAlbumButton addTarget:self action:@selector(clickAlbumButton:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else if (indexPath.section == 1){
            static NSString *cellIdentifier = @"MyClassAmongCell";
            //自定义cell类
            MyClassAmongCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                //通过xib的名称加载自定义的cell
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyClassAmongCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.myClassBulletinArray && [self.myClassBulletinArray count] > 0) {
                if ([self.myClassBulletinArray count] == 1) {
                    MyCurrentClassModelBulletinitems *obj = [self.myClassBulletinArray objectAtIndex:0];
                    cell.conmmentLabel.text = obj.ArchiveTitle;
                    cell.allCommentLabel.text = obj.ArchiveText;
                    cell.readingLabel.text = [NSString stringWithFormat:@"阅读(%@)",obj.HitCount];
                } else{
                    MyCurrentClassModelBulletinitems *obj = [self.myClassBulletinArray objectAtIndex:indexPath.row];
                    cell.conmmentLabel.text = obj.ArchiveTitle;
                    cell.allCommentLabel.text = obj.ArchiveText;
                    cell.readingLabel.text = [NSString stringWithFormat:@"阅读(%@)",obj.HitCount];
                    cell.timeLabel.text = obj.PubTime;
                }
                
            } else{ // 没有班级公告
                cell.myClassDynamicLabel.hidden = NO;
                cell.lookMoreButton.hidden = YES;
                cell.lineView.hidden = YES;
                cell.conmmentLabel.hidden = YES;
                cell.readingLabel.hidden = YES;
                cell.allCommentLabel.hidden = YES;
                cell.timeLabel.hidden = YES;
                cell.BulletinLabel.hidden = NO;
            }
            if (indexPath.row != 0) {
                cell.myClassDynamicLabel.hidden = YES;
                cell.lookMoreButton.hidden = YES;
                cell.lineView.hidden = YES;
                
                cell.conmmentLabel.frame = CGRectMake(8, 8, 304, 21);
                cell.allCommentLabel.top = cell.conmmentLabel.bottom + 5;
                cell.readingLabel.top = cell.allCommentLabel.bottom + 5;
                cell.timeLabel.top = cell.allCommentLabel.bottom + 5;
            }
            
            [cell.lookMoreButton addTarget:self action:@selector(clickLookMoreButton) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        } else{
            static NSString *cellIdentifier = @"DynamicCell";
            //自定义cell类
            DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[DynamicCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.dataSource && [self.dataSource count] > 0) {
                cell.model = [self.dataSource objectAtIndex:indexPath.row];
                cell.delegate = self;
            }
            return cell;
        }
    } else{
        static NSString *cellId = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        MyCurrentClassListModelitems *obj = self.myClassListArray[indexPath.row];
        cell.textLabel.text = obj.ClassName;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
    } else{
        [self.popover dismiss];
        MyCurrentClassListModelitems *obj = self.myClassListArray[indexPath.row];
        [self.titlebtn setTitle:obj.ClassName forState:UIControlStateNormal];
        _tempClassID = obj.ClassId;
        _tempClassName = obj.ClassName;
        _tempClassSoglon = obj.Slogan;
        _tempClassFace = obj.ClassFace;
        [self headerReresh];
    }
    [tableView reloadData];
}

#pragma mark -- DynamicCellDelegete
#pragma mark --
// 赞1
-(void)DynamicPraise:(DynamicCell*)cell
{
    __weak MyClassViewController *_self = self;
    if ([cell.model.TypeId isEqualToString:@"1"]) {
        [self samePraise:cell.model WithTypeId:1 WithCell:cell];
    } else if ([cell.model.TypeId isEqualToString:@"2"]){
        [self samePraise:cell.model WithTypeId:2 WithCell:cell];
    } else if ([cell.model.TypeId isEqualToString:@"3"]){
        [self samePraise:cell.model WithTypeId:4 WithCell:cell];
    } else if ([cell.model.TypeId isEqualToString:@"4"]){
        // 另外调班级网点赞接口
        [self.netWorkManager classArticlePraise:cell.model.ObjectId
                                         userId:[RRTManager manager].loginManager.loginInfo.userId
                                        success:^(NSDictionary *data) {
                                            [_self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"点赞成功"];
                                            [self headerReresh];
                                        } failed:^(NSString *errorMSG) {
                                            [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                        }];
    }
}
// 评论1
-(void)DynamicComment:(DynamicCell *)cell
{
    self.bReplyToComment = YES;
    self.visitorModel = cell.model;
    [inputView.textView becomeFirstResponder];
}
//回复1
-(void)DynamicReplayComment:(DynamicCell *)cell ReplayID:(NSString*)toUserID
{
    self.bReplyToComment = NO;
    self.visitorModel = cell.model;
    tempToUserID = toUserID;
    [inputView.textView becomeFirstResponder];
    
}
// 评论（回复）1
- (void)publishWithParentId:(NSString *)parentId ObjectId:(NSString *)objectId
{
    TheMyTendencyList *VM = self.visitorModel;
    if (self.bReplyToComment) {// 评论
        if ([VM.TypeId isEqualToString:@"1"]) {
            [self commonCommentaryOrReplyMethodsParentId:parentId ObjectId:objectId TypeId:1];
        } else if ([VM.TypeId isEqualToString:@"2"]){
            [self commonCommentaryOrReplyMethodsParentId:parentId ObjectId:objectId TypeId:2];
        } else if ([VM.TypeId isEqualToString:@"3"]){
            [self commonCommentaryOrReplyMethodsParentId:parentId ObjectId:objectId TypeId:4];
        } else if ([VM.TypeId isEqualToString:@"4"]){
            [self.netWorkManager classArticleCommentary:objectId
                                                 userId:[RRTManager manager].loginManager.loginInfo.userId
                                                    pId:@"0"
                                            commentText:inputView.textView.text
                                                success:^(NSDictionary *data) {
                                                    [self showImage:[UIImage imageNamed:@""] status:@"评论成功"];
                                                    [self headerReresh];//重新刷新界面
                                                } failed:^(NSString *errorMSG) {
                                                    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                }];
        }
    } else{// 回复
        if ([VM.TypeId isEqualToString:@"1"]) {
            [self commonCommentaryOrReplyMethodsParentId:parentId ObjectId:objectId TypeId:1];
            
        } else if ([VM.TypeId isEqualToString:@"2"]){
            [self commonCommentaryOrReplyMethodsParentId:parentId ObjectId:objectId TypeId:2];
            
        } else if ([VM.TypeId isEqualToString:@"3"]){
            [self commonCommentaryOrReplyMethodsParentId:parentId ObjectId:objectId TypeId:4];
            
        } else if ([VM.TypeId isEqualToString:@"4"]){
            [self.netWorkManager classArticleCommentary:objectId
                                                 userId:[RRTManager manager].loginManager.loginInfo.userId
                                                    pId:parentId
                                            commentText:inputView.textView.text
                                                success:^(NSDictionary *data) {
                                                    [self showImage:[UIImage imageNamed:@""] status:@"回复成功"];
                                                    [self headerReresh];//重新刷新界面
                                                } failed:^(NSString *errorMSG) {
                                                    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                }];
        }
    }
    inputView.textView.text = @"";
}

// 更多评论1
-(void)DynamicMoreComment:(DynamicCell *)cell
{
    if ([cell.model.TypeId isEqualToString:@"2"]) {
        [self.navigationController pushViewController:ArticleOrLogDetailsVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ArticleOrLogDetailsViewController *VC = (ArticleOrLogDetailsViewController *)viewController;
                                                VC.articleId =  cell.model.ObjectId;
                                            }];
    } else if ([cell.model.TypeId isEqualToString:@"4"]){
        ArcicleDetailViewController *VC = [[ArcicleDetailViewController alloc] init];
        VC.articleId = cell.model.ObjectId;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

// 发表
- (void)clickSendButton
{
    if (inputView.textView.text.length == 0) {
        [self showUploadView:@"内容不能为空哦！"];
    } else{
        if (self.bReplyToComment) {// 评论
            [self publishWithParentId:@"0" ObjectId:self.visitorModel.ObjectId];
        } else{
            [self publishWithParentId:tempToUserID ObjectId:self.visitorModel.ObjectId];
        }
    }
}

- (void)commonCommentaryOrReplyMethodsParentId:(NSString *)parentId ObjectId:(NSString *)objectId TypeId:(int)TypeId
{
    if (self.bReplyToComment) {
        [self.netWorkManager postTheReplyCommentsWithUserId:[RRTManager manager].loginManager.loginInfo.userId
                                          commentedObjectId:objectId
                                                       body:inputView.textView.text
                                                     typeId:TypeId
                                                    success:^(NSDictionary *data) {
                                                        [self showImage:[UIImage imageNamed:@""] status:@"评论成功"];
                                                        [self headerReresh];//重新刷新界面
                                                    } failed:^(NSString *errorMSG) {
                                                        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                    }];
    } else{
        [self.netWorkManager postReplyCommentsWithUserId:[RRTManager manager].loginManager.loginInfo.userId
                                       commentedObjectId:objectId
                                                    body:inputView.textView.text
                                                  typeId:TypeId
                                                parentId:[parentId intValue]
                                                 success:^(NSDictionary *data) {
                                                     [self showImage:[UIImage imageNamed:@""] status:@"回复成功"];
                                                     [self headerReresh];//重新刷新界面
                                                 } failed:^(NSString *errorMSG) {
                                                     [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                 }];
    }
    
}

- (void)samePraise:(TheMyTendencyList *)visitorModel WithTypeId:(int)typeId WithCell:(DynamicCell *)cell
{
    __weak MyClassViewController *_self = self;
    [self.netWorkManager postPraiseWithtoken:[RRTManager manager].loginManager.loginInfo.tokenId
                                    objectId:visitorModel.ObjectId
                                      typeId:typeId
                                     success:^(NSDictionary *data) {
                                         [_self showImage:[UIImage imageNamed:@""] status:@"点赞成功"];
                                         [_self headerReresh];
                                     } failed:^(NSString *errorMSG) {
                                         [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     }];
}


#pragma mark -- 班级文章响应按钮
#pragma mark --
- (void)clickArticleButton:(UIButton *)sender
{
    [self.navigationController pushViewController:MyClassArticleVCID
                                   withStoryBoard:DiscoverStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            MyClassArticleViewController *VC =(MyClassArticleViewController *)viewController;
                                            VC.classId = _tempClassID;
                                        }];
}

#pragma mark -- 班级相册响应按钮
#pragma mark --

- (void)clickAlbumButton:(UIButton *)sender
{
    [self.navigationController pushViewController:MyClassAlbumVCID
                                   withStoryBoard:DiscoverStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            MyClassAlbumViewController *VC =(MyClassAlbumViewController *)viewController;
                                            VC.classId = _tempClassID;
                                        }];
}
#pragma mark -- 查看更多班级公告
#pragma mark --

- (void)clickLookMoreButton
{
//    CommonSuccessBlock block = ^(void){
//        [self requestData];
//    };

    [self.navigationController pushViewController:TheAllBullentinsVCID
                                   withStoryBoard:DiscoverStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            TheAllBullentinsViewController *vc = (TheAllBullentinsViewController*)viewController;
                                            vc.classID = _tempClassID;
//                                            vc.block = block;
                                        }];

}


#pragma mark -- MyClassListViewDelegate
#pragma mark --

- (void)compsoeView:(MyClassListView *)compsoeView didClickType:(IWComposeButtonType)type
{

    CommonSuccessBlock block = ^(void){
        [self headerReresh];
    };
    if (type == IWComposeButtonTypeSendTabulation) {
        if (isArticleAuthority) {
            [self.navigationController pushViewController:MyClassArticleReleaseVCID
                                           withStoryBoard:DiscoverStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    MyClassArticleReleaseViewController *VC = (MyClassArticleReleaseViewController *)viewController;
                                                    VC.classId = _tempClassID;
                                                    VC.block = block;
                                                }];

        } else{
            [self showImage:nil status:@"没有权限，不能发表文章"];
        }
    } else if (type == IWComposeButtonTypeSendAlbum){
        if (isPictureAuthority) {
            [self.navigationController pushViewController:MyClassPassOnPicVCID
                                           withStoryBoard:DiscoverStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    MyClassPassesOnThePictureViewController *vc = (MyClassPassesOnThePictureViewController*)viewController;
                                                    vc.classId = _tempClassID;
                                                    vc.block = block;
                                                }];
        } else{
            [self showImage:nil status:@"没有权限，不能上传照片"];
        }
    }
}

#pragma mark -- titleView 动画
#pragma mark --
- (void)bounceTargetView:(UIView *)targetView
{
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        targetView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)updateTableViewFrame
{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.width = _popoverWidth;
    self.tableView.frame = tableViewFrame;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    [self.inputView setHidden:YES];
}

#pragma mark - UIScrollView delegate
#pragma mark -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)hidenNavigationBar:(BOOL)isEnd
{
    if (isEnd) {
        self.navigationController.navigationBar.hidden = NO;
        
    } else{
        self.navigationController.navigationBar.hidden = YES;
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerReresh];
    
}
@end

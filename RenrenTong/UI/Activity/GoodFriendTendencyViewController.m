//
//  GoodFriendTendencyViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "GoodFriendTendencyViewController.h"
#import "ArticleOrLogDetailsViewController.h"
#import "ArcicleDetailViewController.h"
#import "MJRefresh.h"
#import "DynamicCell.h"
#import "PublishCommentView.h"
#import "PublishListAndPraiseView.h"
#import "commentaryToolView.h"
#import "MJRefresh.h"

@interface GoodFriendTendencyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DynamicCellDelegate,commentaryToolViewDelegate>
{
    commentaryToolView *inputView; //发表评论视图
    NSString *tempToUserID;
    NSString *tempObjectId;
    
    //分页加载处理
    BOOL isHeadEndRefresh;
    BOOL isFootEndRefresh;
    NSMutableArray *tempCacheAry;
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) TheMyTendencyList *visitorModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复评论1，还是回复某个人0
@property (nonatomic, assign) int commentIndex;
@property (nonatomic, assign) int pageIndex;

@end

@implementation GoodFriendTendencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    self.navigationCenterView.hidden = YES;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.pageIndex = 1;
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 126) style:UITableViewStyleGrouped];

    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.view addSubview:self.mainTableView];
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainTableView addGestureRecognizer:tapGesture];
    [self initView];
    [self requestData];
}

- (void)initView
{
    inputView = [[commentaryToolView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50 - 64, SCREENWIDTH, 50)];
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
        [self requestData];
    }
    
}

- (void)footerReresh
{
    if (isFootEndRefresh) {
        [self requestData];
    }
}

#pragma mark -- 数据请求
#pragma mark --

- (void)requestData
{
    
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetHomeActivity",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"typeId",[RRTManager manager].loginManager.loginInfo.tokenId,@"token",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theGoodFriendTendency.st == 0) {
            if (self.pageIndex == 1) {
                isHeadEndRefresh = YES;
                [self.mainTableView headerEndRefreshing];
            }else{
                isFootEndRefresh = YES;
                [self.mainTableView footerEndRefreshing];
            }
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            self.pageIndex ++;
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            if (self.pageIndex == 1) {
                isHeadEndRefresh = YES;
                [self.mainTableView headerEndRefreshing];
            }else{
                isFootEndRefresh = YES;
                [self.mainTableView footerEndRefreshing];
            }
            [self showUploadView:erromodel.msg];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
        isHeadEndRefresh = YES;
        isFootEndRefresh = YES;
    } cache:^(id cache) {
        TheMyTendency *theGoodFriendTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theGoodFriendTendency.st == 0) {
            if (theGoodFriendTendency && self.pageIndex > 1) {
                tempCacheAry = [theGoodFriendTendency.msg.list mutableCopy];
            }
            [self updateView:[theGoodFriendTendency.msg.list mutableCopy]];
            isHeadEndRefresh = YES;
            isFootEndRefresh = YES;
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

#pragma mark -- UITableViewDataSourceAndDelegete
#pragma mark --
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [[DynamicCell alloc] init];
    
    cell.model = [self.dataSource objectAtIndex:indexPath.section];
    
    return cell.height;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 0.001;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DynamicCell";
    //自定义cell类
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DynamicCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = [self.dataSource objectAtIndex:indexPath.section];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TheMyTendencyList *VM = self.dataSource[indexPath.section];
    if ([VM.TypeId isEqualToString:@"2"]) {
        [self.navigationController pushViewController:ArticleOrLogDetailsVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ArticleOrLogDetailsViewController *VC = (ArticleOrLogDetailsViewController *)viewController;
                                                VC.articleId =  VM.ObjectId;
                                            }];
    }  else if ([VM.TypeId isEqualToString:@"4"]){
        ArcicleDetailViewController *VC = [[ArcicleDetailViewController alloc] init];
        VC.articleId = VM.ObjectId;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark -- DynamicCellDelegete
#pragma mark --
// 赞1
-(void)DynamicPraise:(DynamicCell*)cell
{
    __weak GoodFriendTendencyViewController *_self = self;
    [self show];
    if ([cell.model.TypeId isEqualToString:@"1"]) {
        [self samePraise:cell.model WithTypeId:1 WithCell:cell];
    } else if ([cell.model.TypeId isEqualToString:@"2"]){
        [self samePraise:cell.model WithTypeId:2 WithCell:cell];
    } else if ([cell.model.TypeId isEqualToString:@"3"]){
        [self samePraise:cell.model WithTypeId:4 WithCell:cell];
    } else if ([cell.model.TypeId isEqualToString:@"4"]){
        // 另外调班级网点赞接口
        NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/PraiseArchive",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",cell.model.ObjectId],@"archiveId",[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"userId",nil];
        [HttpUtil PostWithUrl:requestUrl
                   parameters:dic
                      success:^(id json) {
                          ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                          if (result.result.intValue == 1) {
                              [_self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"点赞成功"];
                              cell.model.IsPraise = [NSNumber numberWithInt:1];
                              TheMyTendencyPraiseUsers *pariseUser = [[TheMyTendencyPraiseUsers alloc] init];
                              pariseUser.PictureUrl = [RRTManager manager].loginManager.loginInfo.userAvatar;
                              [cell.model.PraiseUsers addObject:pariseUser];
                              NSIndexPath *path = [self.mainTableView indexPathForCell:cell];
                              [self.dataSource replaceObjectAtIndex:path.section withObject:cell.model];
                              [self.mainTableView reloadData];
                          } else if (result.result.intValue == 0){
                              [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"你已经点过赞了"];
                          }
                      } fail:^(id error) {
                          [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"点赞失败"];
                      } cache:^(id cache) {
                          
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
            NSString *requestUrl = [NSString stringWithFormat:@"http://nmapi.%@/class/PostPublishComment",
                                    aedudomain];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",objectId],@"archiveId",[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"userId",@"0",@"pId",[NSString stringWithFormat:@"%@",inputView.textView.text],@"commentText",nil];
            [HttpUtil PostWithUrl:requestUrl
                       parameters:dic
                          success:^(id json) {
                              ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                              
                              if (result.result.intValue == 1) {
                                  [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"评论成功"];
                                  [self headerReresh];
                              } else{
                                  [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"评论失败"];
                              }
                          } fail:^(id error) {
                              [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"评论失败"];
                              
                          } cache:^(id cache) {
                              
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

                                                    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"回复成功"];
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

- (void)clickSendButton
{
    [self show];
    if (inputView.textView.text.length == 0) {
        [self showImage:nil status:@"输入内容不能为空！"];
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
        NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments",
                                aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"UserId",[NSString stringWithFormat:@"%@",objectId],@"commentedObjectId",inputView.textView.text,@"body",[NSString stringWithFormat:@"%d",TypeId],@"typeId",nil];
        [HttpUtil PostWithUrl:requestUrl
                   parameters:dic
                      success:^(id json) {
                          ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                          if (result.st.intValue == 0) {
                              [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"评论成功"];
                              [self headerReresh];//重新刷新界面
                          } else{
                              [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:result.msg];
                          }
                      } fail:^(id error) {
                          [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:error];
                      } cache:^(id cache) {
                          
                      }];
    } else{
        NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments",
                                aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"UserId",[NSString stringWithFormat:@"%@",objectId],@"commentedObjectId",inputView.textView.text,@"body",[NSString stringWithFormat:@"%d",TypeId],@"typeId",parentId,@"parentId",nil];
        [HttpUtil PostWithUrl:requestUrl
                   parameters:dic
                      success:^(id json) {
                          ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                          if (result.st.intValue == 0) {
                              [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"回复成功"];
                              [self headerReresh];//重新刷新界面
                          } else{
                              [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:result.msg];
                          }
                      } fail:^(id error) {
                          [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:error];
                      } cache:^(id cache) {
                          
                      }];
    }
}

- (void)samePraise:(TheMyTendencyList *)visitorModel WithTypeId:(int)typeId WithCell:(DynamicCell *)cell
{
    __weak GoodFriendTendencyViewController *_self = self;
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostPraise",
                            aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.tokenId],@"token",[NSString stringWithFormat:@"%@",visitorModel.ObjectId],@"objectID",[NSString stringWithFormat:@"%d",typeId],@"typeId",nil];
    
    [HttpUtil PostWithUrl:requestUrl
               parameters:dic
                  success:^(id json) {
                      ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                      if (result.st.intValue == 0) {
                          [_self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"点赞成功"];
                          cell.model.IsPraise = [NSNumber numberWithInt:1];
                          TheMyTendencyPraiseUsers *pariseUser = [[TheMyTendencyPraiseUsers alloc] init];
                          pariseUser.PictureUrl = [RRTManager manager].loginManager.loginInfo.userAvatar;
                          [cell.model.PraiseUsers addObject:pariseUser];
                          NSIndexPath *path = [self.mainTableView indexPathForCell:cell];
                          [self.dataSource replaceObjectAtIndex:path.section withObject:cell.model];
                          [self.mainTableView reloadData];
                      } else if(result.st.intValue == 1){
                          [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:result.msg];
                      } else{
                          [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:result.msg];
                      }
                      
                  } fail:^(id error) {
                      [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:error];
                  } cache:^(id cache) {
                      
                  }];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
     self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self headerReresh];
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
@end

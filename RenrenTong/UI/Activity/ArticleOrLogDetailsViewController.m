//
//  ArticleOrLogDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ArticleOrLogDetailsViewController.h"
#import "NSDate+Tool.h"
#import "MLEmojiLabel.h"
#import "IWCompsoeView.h"
#import "PublishListAndPraiseView.h"
#import "UMSocial.h"
#import "commentaryToolView.h"
#import "AlbumList.h"
#import "UIimageView+Animation.h"
#import "NSString+TextSize.h"
#import "MJRefresh.h"

@interface ArticleOrLogDetailsViewController ()<MLEmojiLabelDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,IWCompsoeViewDelegate,UMSocialUIDelegate,commentaryToolViewDelegate,PublishListAndPraiseViewDelegate>
{
    
    UIScrollView *scrollView;
    
    UILabel *time; //时间
    UILabel *detailText; //文章内容详情
    UILabel *titleLabel;//图片名称
    UILabel *nameLabel; //用户名
    UIImageView *userImage; //用户头像
    PublishListAndPraiseView *commentBackView; //评论点赞整体视图
    
    //评论
    commentaryToolView *inputView; //发表评论视图
    
    NSMutableArray *commentArray; //评论列表数组
    LogModel *detail; //网络获取回的详情内容对象model
    NSString *toUserId; //回复用户对象的id
    
    //评论列表
    NSInteger dataPage;//分页获取，当前页数(网络获取后，成功获取，加1，失败，不变)
    NSInteger currentPage;//分页获取，当前页数(网络获取时的页数)
    BOOL isEndRefresh; //判断是否头更新

    // 分享
    IWCompsoeView *cover;
    NetWorkManager *net;
    
}

@end

@implementation ArticleOrLogDetailsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"日志详情";
    toUserId = @"0";
    
    //    键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 初始化分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 2, 43, 14)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"FXXX-"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //   隐藏键盘点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    dataPage = 1;
    currentPage = 1;
    isEndRefresh = YES;
    
    net = [[NetWorkManager alloc] init];
    [self initView];
}

#pragma mark - 键盘监听及隐藏
-(void)keyboardWillshow:(NSNotification*)notification
{
    inputView.procLable.hidden = YES;
    scrollView.bounces = NO;
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        inputView.transform = CGAffineTransformMakeTranslation(0,ty);
        scrollView.transform = CGAffineTransformMakeTranslation(0,ty);
        [scrollView scrollRectToVisible:commentBackView.frame animated:YES];
    }];
    
}
-(void)keyboardWillhide:(NSNotification*)notification
{
    if (inputView.textView.text.length == 0) {
        inputView.procLable.hidden = NO;
    }
    scrollView.bounces = YES;
    inputView.transform = CGAffineTransformIdentity;
    scrollView.transform = CGAffineTransformIdentity;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    return YES;
    
}

-(void)endEdit
{
    [self.view endEditing:YES];
}

-(void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 50)];
    scrollView.bounces = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    [self.view addSubview:scrollView];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH- 20, 35)];
    titleLabel.textColor = MainTextColor;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:titleLabel];
    
    userImage = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), 25, 25)];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 25/2;
    [scrollView addSubview:userImage];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame) + 5, userImage.frame.origin.y, 80, 25)];
    nameLabel.textColor = CommentViewTextColor;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:nameLabel];
    
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 10, CGRectGetMaxY(titleLabel.frame), 140, 25)];
    time.font = nameLabel.font;
    time.textColor = GrayTextColor;
    time.center = CGPointMake(SCREENWIDTH/2 + 15 , time.center.y);
    time.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:time];
    
    detailText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(userImage.frame), CGRectGetMaxY(userImage.frame) + 20, SCREENWIDTH - 20, 0)];
    detailText.textAlignment = NSTextAlignmentLeft;
    detailText.textColor = MainTextColor;
    detailText.numberOfLines = 0;
    detailText.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:detailText];
    
    commentBackView = [[PublishListAndPraiseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailText.frame), SCREENWIDTH, 20)];
    commentBackView.delegate = self;
    [scrollView addSubview:commentBackView];
    
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(commentBackView.frame));
    inputView = [[commentaryToolView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT -50, SCREENWIDTH, 50)];
    inputView.delegate = self;
    [self.view addSubview:inputView];
}

#pragma mark - 下拉更新处理


- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [scrollView addHeaderWithTarget:self action:@selector(headerReresh)];
}
- (void)headerReresh
{
    [self initData];
}

-(void)initData
{
    [self show];
    [self getArticleDetail];
    [self getArticleComment];
}

-(void)setButton:(NSString*)imageString Text:(NSString*)text
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

#pragma mark - PublishListAndPraiseViewDelegate
-(void)remark
{
    toUserId = @"0";
    [inputView.textView becomeFirstResponder];
}
-(void)selectToReply:(NSString*)selectId
{
    toUserId = selectId;
    [inputView.textView becomeFirstResponder];
    
}

-(void)praise
{
    if (commentBackView.ispraised) {
        [self showImage:nil status:@"已经点过赞了"];
        return;
    }
    [net postPraiseWithtoken:[RRTManager manager].loginManager.loginInfo.tokenId
                    objectId:self.articleId
                      typeId:2
                     success:^(NSDictionary *data) {
                         [commentBackView changePraiseImage];
                         [self getArticleDetail];
                     } failed:^(NSString *errorMSG) {
                         [self showImage:nil status:@"点赞失败"];
                     }];
}

-(void)getMoreComment
{
    if (isEndRefresh) {
        currentPage = dataPage;
        dataPage ++;
        isEndRefresh = NO;
        [self getArticleComment];
    }
}

#pragma mark - 发表评论
-(void)clickSendButton
{
    if (inputView.textView.text.length == 0 ) {
        [self showImage:nil status:@"请输入评论内容"];
        return;
    }
    [self show];
    [net clickReply:[RRTManager manager].loginManager.loginInfo.userId
  commentedObjectId:self.articleId
               body:[inputView.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""]
             typeId:@"2"
           parentId:toUserId
            success:^(NSDictionary *data) {
                dataPage = 1;
                [self getArticleComment];
                inputView.textView.text = @"";
                [inputView RecoverFrame];
                [self dismiss];
                toUserId = @"0";
                
            } failed:^(NSString *errorMSG) {
                [self showImage:nil status:@"发表评论失败，请重试"];
            }];
}

#pragma mark - 获取日志详情
-(void)getArticleDetail
{
    [net logDetails:[RRTManager manager].loginManager.loginInfo.userId
             blogId:self.articleId
            success:^(NSMutableArray *data) {
                if (data && [data count] > 0) {
                    detail = data[0];
                    titleLabel.text = detail.Title;
                    [userImage setImageWithUrlStr:detail.PictureUrl placholderImage:[UIImage imageNamed:@"defaultImage"]];
                    nameLabel.text = detail.UserName;
                    time.text = [NSDate getDateStringByFormatterString:[NSDate getDateByDefaultFormatterString:detail.DateTime] Formate:@"M月dd日  H:mm"];
                    CGSize detailTextSize = [detail.Body boundingRectWithSize:CGSizeMake(detailText.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                    detailText.frame = CGRectMake(detailText.frame.origin.x, detailText.frame.origin.y, detailText.frame.size.width, detailTextSize.height);
                    detailText.text = detail.Body;
                    commentBackView.frame = CGRectMake(commentBackView.frame.origin.x, CGRectGetMaxY(detailText.frame), commentBackView.frame.size.width, commentBackView.frame.size.height);
                    BOOL isUploadHeadView = YES;
                    if (detail.IsPraise) {
                        [commentBackView changePraiseImage];
                    }
                    if (detail.PraiseCount > 0) {
                        for (NSInteger i = 0; i < detail.praisePopulationURLs.count; i++) {
                            if (i == 3) {
                                [commentBackView addPraiseNumLabel:[NSString stringWithFormat:@"等%d人觉得很赞",detail.praisePopulationURLs.count]];
                                break;
                            }
                            DynamicComments *dy = detail.praisePopulationURLs[i];
                            [commentBackView addPraiseHeadImage:dy.PictureUrl IsupdateView:isUploadHeadView];
                            isUploadHeadView = NO;
                        }
                    }
                    scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(commentBackView.frame)  + 20);
                    [self dismiss];
                }
            } failed:^(NSString *errorMSG) {
                [self dismiss];
            }];
}

#pragma mark - 获取文章评论

-(void)getArticleComment
{
    [net getBlogCommentList:self.articleId
                  pageIndex:dataPage
                    success:^(NSMutableArray *data) {
                        if (dataPage > 1) {
                            [commentArray addObjectsFromArray:data];
                        } else{
                            commentArray = data;
                        }
                        isEndRefresh = YES;
                        [inputView.iconBtn setTitle:[NSString stringWithFormat:@"%d",commentArray.count] forState:UIControlStateNormal];
                        NSString *comments = @"";
                        for (int j = 0; j < commentArray.count; j ++) {
                            DynamicComments *DC = [commentArray objectAtIndex:j];
                            NSString* br = @"";
                            //换行
                            if (j < [commentArray count] - 1) {
                                br=@"\n";
                            }
                            if (DC.ParentId > 0) {
                                comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC  回复 U[%@]U%dI%dIC%dC :%@", DC.Author,DC.CommenId,j,0,DC.ToUserDisplayName,DC.ParentId,j,0,DC.Body],br];
                            } else{
                                comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC :%@", DC.Author,DC.CommenId,j,0,DC.Body],br];
                            }
                        }
                        [commentBackView addCommentList:comments];
                        scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(commentBackView.frame)  + 20);
                        [scrollView headerEndRefreshing];
                        [self dismiss];
                    } failed:^(NSString *errorMSG) {
                        [scrollView headerEndRefreshing];
                        isEndRefresh = YES;
                        [self showImage:nil status:@"没有更多评论"];
                    }];
}

#pragma mark -- 分享按钮

-(void)share
{
    [self.view endEditing:YES];
    cover = [[IWCompsoeView alloc] init];
    cover.delegate = self;
    [cover show];
}

- (void)compsoeView:(IWCompsoeView *)compsoeView didClickType:(IWComposeButtonType)type
{
    if (type == IWComposeButtonTypeSina) {
        
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"来自【智慧云人人通】班级文章的分享 %@ %@",detail.LinkUrl,detail.Body] shareImage:[UIImage imageNamed:@"fenxiangtupian.png"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (type == IWComposeButtonTypeQzone)
    {
        [UMSocialData defaultData].extConfig.title = @"来自【智慧云人人通】班级文章的分享";
        [UMSocialData defaultData].extConfig.qzoneData.url = detail.LinkUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone]
                                                            content:detail.Body
                                                              image:[UIImage imageNamed:@"fenxiangtupian.png"]
                                                           location:nil
                                                        urlResource:nil
                                                presentedController:self
                                                         completion:^(UMSocialResponseEntity *shareResponse){
                                                             if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                 [self showImage:[UIImage imageNamed:@""] status:@"分享成功"];
                                                             }
                                                         }];
        
    }else if (type == IWComposeButtonTypeWenXin)
    {
        [UMSocialData defaultData].extConfig.title = @"来自【智慧云人人通】班级文章的分享";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = detail.LinkUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                            content:detail.Body
                                                              image:[UIImage imageNamed:@"fenxiangtupian.png"]
                                                           location:nil
                                                        urlResource:nil
                                                presentedController:self
                                                         completion:^(UMSocialResponseEntity *shareResponse){
                                                             if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                 [self showImage:[UIImage imageNamed:@""] status:@"分享成功"];
                                                             }
                                                         }];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
@end

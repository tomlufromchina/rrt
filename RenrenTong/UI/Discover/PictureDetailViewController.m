//
//  PictureDetailViewController.m
//  RenrenTong
//
//  Created by aedu on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "MJRefresh.h"
#import "NSDate+Tool.h"
#import "PublishListAndPraiseView.h"
#import "commentaryToolView.h"
#import "AlbumList.h"
#define Spacing 10

@interface PictureDetailViewController ()<UITextViewDelegate,MLEmojiLabelDelegate,PublishListAndPraiseViewDelegate,commentaryToolViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect cotentSize;
    BOOL isScorllViewOffset;//键盘是否引起scrollview偏移位移
    CGFloat scrollViewOfset;//键盘引起scrollview偏移位移
    UITapGestureRecognizer *tapGestureRecognizer;
    
    UIScrollView *scrollView;
    UIImageView *topImage;
    UILabel *name;
    UILabel *time;
    UILabel *describtion;
    UIImageView *midImage;
    commentaryToolView *inputView; //发表评论视图

    
    
    PublishListAndPraiseView *commentBackView;
    
    NSMutableArray *commentArray;
    BOOL isRecomment;
    GetPhotoItemList *detail;
    NSString *toUserId;
    
    //评论列表
    NSInteger dataPage;
    NSMutableArray *currentNextPageAry;
    BOOL isGetMoreComment; //判断是否是获取更多评论，如果不是则当没有评论的时候不返回错误信息提示
    BOOL isViewFirstAppear;//判断是否是第一次进入界面，如果是，则在判断评论未有数据时，不做提示。
    BOOL isEndRefresh; //判断是否头更新
}

@end

@implementation PictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    self.title = @"照片详情";
    toUserId = @"0";
    self.automaticallyAdjustsScrollViewInsets = NO;
    dataPage = 1;
    isEndRefresh = YES;
    [self initView];
    [self headerReresh];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 50)];
    scrollView.contentSize = CGSizeMake(0, scrollView.frame.size.height + 20);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    cotentSize = scrollView.frame;
    //上拉刷新和下拉加载更多
    scrollView.backgroundColor = [UIColor whiteColor];
    [self setupRefresh];
    [self.view addSubview:scrollView];
    
    topImage = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing, Spacing, 50, 50)];
    [scrollView addSubview:topImage];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topImage.frame) + Spacing, topImage.frame.origin.y, SCREENWIDTH - CGRectGetMaxX(topImage.frame) - 20, 30)];
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = MainTextColor;
    name.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:name];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMaxY(name.frame), 100, 20)];
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = GrayTextColor;
    time.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:time];
    
    describtion = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topImage.frame), CGRectGetMaxY(topImage.frame) + Spacing, SCREENWIDTH - 40, 0)];
    describtion.textAlignment = NSTextAlignmentLeft;
    describtion.font = [UIFont systemFontOfSize:15];
    describtion.textColor = MainTextColor;
    describtion.numberOfLines = 0;
    [scrollView addSubview:describtion];
    
    midImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(topImage.frame), CGRectGetMaxY(describtion.frame), 150, 150)];
    [scrollView addSubview:midImage];
    
    commentBackView = [[PublishListAndPraiseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(midImage.frame), SCREENWIDTH, 44)];
    commentBackView.delegate = self;
    [scrollView addSubview:commentBackView];
    
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
    isViewFirstAppear = YES;
    [self initData];
}

-(void)initData
{
    [self getPhotoDetail];
    dataPage = 1;
    [self getCommentList];
}

#pragma mark - 获取照片详情
-(void)getPhotoDetail
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoDetail",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.photoId,@"PhotoId",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoDetail *albumList = [[GetPhotoDetail alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            [self reloadViews:albumList.photo];
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        GetPhotoDetail *albumList = [[GetPhotoDetail alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
             [self reloadViews:albumList.photo];
        }
    }];
}
-(void)reloadViews:(GetPhotoItemList *)model
{
    detail = model;
    [topImage setImageWithURL:[NSURL URLWithString:detail.PhotoUrl] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    name.text = detail.PhotoName;
    CGSize detailTextSize = [detail.PhotoCaption boundingRectWithSize:CGSizeMake(describtion.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    describtion.frame = CGRectMake(describtion.frame.origin.x, describtion.frame.origin.y, describtion.frame.size.width, detailTextSize.height);
    describtion.text = detail.PhotoCaption;
    [midImage setImageWithURL:[NSURL URLWithString:detail.PhotoUrl] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    time.text = [NSDate getDateStringByFormatterString:[NSDate getDateByDefaultFormatterString:detail.PubTime] Formate:@"M月dd日  H:mm"];
    
    midImage.frame = CGRectMake(CGRectGetMinX(topImage.frame), CGRectGetMaxY(describtion.frame) + Spacing, 150, 150);
    
    commentBackView.frame = CGRectMake(0, CGRectGetMaxY(midImage.frame), SCREENWIDTH, commentBackView.frame.size.height);
    [scrollView headerEndRefreshing];
    BOOL isUploadHeadView = YES;
    if (detail.Praise.count > 0) {
        for (NSInteger i = 0; i < detail.Praise.count; i++) {
            if (i == 3) {
                [commentBackView addPraiseNumLabel:[NSString stringWithFormat:@"等%d人觉得很赞",detail.Praise.count]];
                break;
            }
            GetArchivePraise *praise = [detail.Praise objectAtIndex:i];
            [commentBackView addPraiseHeadImage:praise.UserFace IsupdateView:isUploadHeadView];
            if ([praise.UserId isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
                [commentBackView changePraiseImage];
            }
            isUploadHeadView = NO;
        }
    }
}
#pragma mark - 获取评论列表
-(void)getCommentList
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoCommentList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.photoId ,@"PhotoId",[NSNumber numberWithInt:dataPage],@"pageIndex",@"5",@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoCommentList *list = [[GetPhotoCommentList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (dataPage > 1 && list.items.count > 0) {
                if (currentNextPageAry) {
                    [commentArray removeObjectsInArray:currentNextPageAry];
                    currentNextPageAry = nil;
                }
                [commentArray addObjectsFromArray:list.items];
            }else{
                commentArray = (NSMutableArray*)list.items;
            }
            [self reloadCommentView:list.items];
            dataPage ++;
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            isEndRefresh = YES;
            if (!isViewFirstAppear) {
                if (erromodel.msg) {
                    [self showUploadView:erromodel.msg];
                }else{
                    if(isGetMoreComment){
                        [self showUploadView:@"没有更多评论"];
                    }
                }
            }
        }
        [scrollView headerEndRefreshing];
        isViewFirstAppear = NO;
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        GetPhotoCommentList *list = [[GetPhotoCommentList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (list.items) {
                if (dataPage > 1) {
                    if (currentNextPageAry) {
                        [commentArray removeObjectsInArray:currentNextPageAry];
                        currentNextPageAry = nil;
                    }
                    [commentArray addObjectsFromArray:list.items];
                    currentNextPageAry = (NSMutableArray*)list.items;
                }else{
                    commentArray = (NSMutableArray*)list.items;
                }
                [self reloadCommentView:list.items];
        }
        }
    }];

}
-(void)reloadCommentView:(NSMutableArray*)model
{
    [inputView.iconBtn setTitle:[NSString stringWithFormat:@"%d",commentArray.count] forState:UIControlStateNormal] ;
    isEndRefresh = YES;
    NSString *comments = @"";
    for (int j = 0; j < commentArray.count; j ++) {
        GetPhotoCommentListItem *bc=[commentArray objectAtIndex:j];
        NSString* br = @"";
        //换行
        if (j < [commentArray count] - 1) {
            br=@"\n";
        }
        if (bc.ParentId.intValue > 0) {
            comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC  回复 U[%@]U%dI%dIC%dC :%@", bc.Author,bc.CommentId.intValue,j,0,bc.ToUserDisplayName,bc.ParentId.intValue,j,0,bc.Body],br];
        }else{
            comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC :%@", bc.Author,bc.CommentId.intValue,j,0,bc.Body],br];
        }
    }
    [commentBackView addCommentList:comments];
    if (CGRectGetMaxY(commentBackView.frame) > scrollView.frame.size.height) {
        scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(commentBackView.frame)  + 20);
    }
    
}

-(void)setButton:(NSString*)imageString Text:(NSString*)text
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

#pragma mark - PublishListAndPraiseViewDelegate

-(void)praise
{
    if (commentBackView.ispraised) {
        [self showUploadView:@"已经点过赞了"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/PraisePhoto",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.photoId,@"PhotoId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *model = [[ErrorModel alloc] initWithString:json error:nil];
        if (model.result.integerValue == 1) {
            [commentBackView changePraiseImage];
            [self getPhotoDetail];
        }else{
            [self showUploadView:model.msg];
        }
    } fail:^(id errors) {
        [self showUploadView:errors];
    } cache:^(id cache) {
        
    }];
}

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

-(void)getMoreComment
{
    if (isEndRefresh) {
        isEndRefresh = NO;
        [self getCommentList];
    }
}
#pragma mark - 发表评论
-(void)clickSendButton
{
    if (inputView.textView.text.length == 0 ) {
        [self showUploadView:@"请输入评论内容"];
        return;
    }
    [self show];
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/PostPhotoComment",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.photoId,@"photoId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",toUserId,@"pId",inputView.textView.text,@"commentText",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        [self dismiss];
        ErrorModel *model = [[ErrorModel alloc] initWithString:json error:nil];
        if (model.result.integerValue == 1) {
            dataPage = 1;
            [self getCommentList];
            inputView.textView.text = @"";
            [inputView RecoverFrame];
            toUserId = @"0";
        }else{
             [self showUploadView:model.msg];
        }
    } fail:^(id errors) {
        [self dismiss];
         [self showUploadView:errors];
    } cache:^(id cache) {
        
    }];
}

#pragma mark - 评论输入视图高度处理

-(void)keyboardWillshow:(NSNotification*)notification
{
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
-(void)endEdit
{
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    return YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

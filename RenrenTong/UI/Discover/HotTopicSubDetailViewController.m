//
//  HotTopicSubDetailViewController.m
//  RenrenTong
//
//  Created by aedu on 15/4/22.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "HotTopicSubDetailViewController.h"
#import "PublishListAndPraiseView.h"
#import "AlbumList.h"
#import "MJRefresh.h"
#import "TopicView.h"
#import "commentaryToolView.h"

@interface HotTopicSubDetailViewController ()<MLEmojiLabelDelegate,PublishListAndPraiseViewDelegate,UIGestureRecognizerDelegate,commentaryToolViewDelegate>
{
    UIScrollView *scrollView;
    
    TopicView *topicView;
    PublishListAndPraiseView *commentBackView; //评论列表点赞整体视图
    commentaryToolView *inputView; //发表评论视图
    NSString *toUserId; //回复用户对象的id
    NSMutableArray *commentArray;
}

@end

@implementation HotTopicSubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _model.TheTitle;
    toUserId = @"0";
    //    键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    //   隐藏键盘点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self initView];
    [self initData];
}
-(void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 50)];
    scrollView.bounces = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    topicView = [[TopicView alloc] init];
    topicView.model = _model;
    topicView.frame = CGRectMake(0, 10, SCREENWIDTH, topicView.hight);
    
    [scrollView addSubview:topicView];
    
    commentBackView = [[PublishListAndPraiseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topicView.frame), SCREENWIDTH, 20)];
    commentBackView.delegate = self;
    [scrollView addSubview:commentBackView];
    [self setCommentAndPriaseView];
    
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(commentBackView.frame));
    
    inputView = [[commentaryToolView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT -50, SCREENWIDTH, 50)];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    
    if (_replayUserId) {
        [self replayToUser:_replayUserId];
    }
}

#pragma mark - 下拉更新处理

-(void)initData
{
    [self getArticleComment];
}
-(void)setCommentAndPriaseView
{
    BOOL isUploadHeadView = YES;
    if(_model.IsPraise.boolValue) {
        [commentBackView changePraiseImage];
    }
    for (NSInteger i = 0; i < self.model.PraiseUsers.count; i++) {
        if (i == 3) {
            [commentBackView addPraiseNumLabel:[NSString stringWithFormat:@"等%d人觉得很赞",self.model.PraiseUsers.count]];
            break;
        }
        TheMyTendencyPraiseUsers *item = [self.model.PraiseUsers objectAtIndex:i];
        [commentBackView addPraiseHeadImage:item.PictureUrl IsupdateView:isUploadHeadView];
        isUploadHeadView = NO;
        
    }
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
    [inputView.textView becomeFirstResponder];
    toUserId = selectId;
}

-(void)praise
{
    if (commentBackView.ispraised) {
        [self showImage:nil status:@"已经点过赞了"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/PostPraise",
                     aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"toKen",self.model.MicroblogId,@"objectId",@"1",@"typeId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        ErrorModel *moder = [[ErrorModel alloc] initWithString:json error:nil];
        if (moder.result.integerValue == 0) {
            [commentBackView changePraiseImage];
            [self showImage:nil status:@"点赞成功"];
            DynamicComments *newitem = [[DynamicComments alloc] init];
            newitem.PictureUrl = [RRTManager manager].loginManager.loginInfo.userAvatar;
            if(!self.model.PraiseUsers){
                self.model.PraiseUsers = [[NSMutableArray alloc] init];
            }
            [self.model.PraiseUsers insertObject:newitem atIndex:0];
            [self setCommentAndPriaseView];
        }else{
            [self showImage:nil status:moder.msg];
        }
    } fail:^(id errors) {
        [self showImage:nil status:errors];
    } cache:^(id cache) {
        
    }];
}

-(void)getMoreComment
{
    [self showImage:nil status:@"没有更多评论"];
}
#pragma mark - 发表评论
-(void)clickSendButton
{
    if (inputView.textView.text.length == 0 ) {
        [self showImage:nil status:@"请输入评论内容"];
        return;
    }
    [self show];
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments",
                     aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"UserId",self.model.MicroblogId,@"commentedObjectId",@"1",@"typeId",inputView.textView.text,@"body",toUserId,@"parentId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        [self getArticleComment];
        inputView.textView.text = @"";
        [inputView RecoverFrame];
        [self dismiss];
        toUserId = @"0";
    } fail:^(id errors) {
        [self showImage:nil status:errors];
    } cache:^(id cache) {
        
    }];
}



#pragma mark - 获取文章评论
-(void)getArticleComment
{
    [self show];
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogComment",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.model.MicroblogId,@"microblogId",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetMicroblogComment *result = [[GetMicroblogComment alloc] initWithString:json error:nil];
        if (result.st == 0 ) {
            commentArray = (NSMutableArray*)result.msg.list;
            [inputView.iconBtn setTitle:[NSString stringWithFormat:@"%d",commentArray.count] forState:UIControlStateNormal] ;
            NSString *comments = @"";
            for (int j = 0; j < commentArray.count; j ++) {
                GetPhotoCommentListItem *bc=[commentArray objectAtIndex:j];
                NSString* br = @"";
                //换行
                if (j < [commentArray count] - 1) {
                    br=@"\n";
                }
                if (bc.ParentId.intValue > 0) {
                    comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC  回复 U[%@]U%dI%dIC%dC :%@", bc.Author,bc.CommenId.intValue,j,0,bc.ToUserDisplayName,bc.ParentId.intValue,j,0,bc.Body],br];
                }else{
                    comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC :%@", bc.Author,bc.CommenId.intValue,j,0,bc.Body],br];
                }
            }
            [commentBackView addCommentList:comments];
            scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(commentBackView.frame)  + 20);
            [self dismiss];
        }else{
            [self dismiss];
        }
    } fail:^(id errors) {
        [self showImage:nil status:errors];
        [self dismiss];
    } cache:^(id cache) {
    }];

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

-(void)replayToUser:(NSString*)replyUserId
{
    toUserId = replyUserId;
    [inputView.textView becomeFirstResponder];
    [self clickSendButton];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

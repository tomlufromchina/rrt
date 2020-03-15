//
//  CommentViewController.m
//  RenrenTong
//
//  Created by aedu on 15/3/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CommentViewController.h"
#import "TopicHeaderView.h"
#import "NSString+TextSize.h"
#import "ToolBar.h"
#import "Microblog.h"
#import "CommentCentent.h"
#import "MicroblogFrame.h"
#import "TopicCell.h"
#import "TopView.h"
#import "BootView.h"
#import "CommentView.h"


@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ToolBarDelegate,CommentViewDelegate,TopViewDelegate>
@property(nonatomic ,strong)NetWorkManager *netWork;
@property(nonatomic, weak)ToolBar *toolbar;
@property(nonatomic, strong)NSArray *commentArray;
@property(nonatomic, strong)MicroblogFrame *microblogFrame;
@property(nonatomic, assign)int parentId;


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentId = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论详情";

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    
    //register keyboard note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    TopicHeaderView *headerView = [[TopicHeaderView alloc]init];
    headerView.topicName.text = self.hotTopic.TagName;
    headerView.detailString = self.micBlog.Body;
    CGSize textSize = [headerView.detailString sizeWithFont:headerView.topicDetail.font MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, textSize.height + 55);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 40)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.tableHeaderView = headerView;
    [self.view addSubview:tableView];
    
    ToolBar *toolbar = [[ToolBar alloc]init];
    toolbar.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
    [self.view addSubview:toolbar];
    toolbar.textView.delegate = self;
    toolbar.textView.left = toolbar.textView.left - 20;
    toolbar.procLable.left = toolbar.textView.left + 3;
    self.toolbar = toolbar;
    toolbar.delegate = self;
    toolbar.iconBtn.hidden = YES;
    [toolbar bringSubviewToFront:tableView];
    
    self.commentArray = [NSArray array];
    self.netWork = [[NetWorkManager alloc]init];
    [self getMoreComment];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)getMoreComment
{
    [self show];
    [self.netWork getMicroblogCommentWithmicroblogId:self.micBlog.MicroblogId success:^(NSMutableArray *data) {
        self.commentArray = [CommentCentent objectArrayWithKeyValuesArray:data];
        self.micBlog.CommentCentent = self.commentArray;
        MicroblogFrame *microblogFrame = [[MicroblogFrame alloc]init];
        microblogFrame.micBlog = self.micBlog;
        self.microblogFrame = microblogFrame;
        [self dismiss];
        [self.mainView reloadData];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:@"没有数据"];
        [self dismiss];
        MicroblogFrame *microblogFrame = [[MicroblogFrame alloc]init];
        microblogFrame.micBlog = self.micBlog;
        self.microblogFrame = microblogFrame;
        [self.mainView reloadData];
    }];
    
}

- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.mainView.transform = CGAffineTransformMakeTranslation(0, ty);
                         self.toolbar.transform = CGAffineTransformMakeTranslation(0, ty);
                     }];
    
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.mainView.transform = CGAffineTransformIdentity;
                         self.toolbar.transform = CGAffineTransformIdentity;
                     }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        self.toolbar.procLable.hidden = YES;
    }else
    {
        self.toolbar.procLable.hidden = NO;
    }
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect textframe = self.toolbar.textView.frame;
    CGFloat y = newSize.height - textframe.size.height;
    if(y != 0)
    {
        textframe.size.height = newSize.height;
        self.toolbar.textView.frame = textframe;
        CGRect frame = self.toolbar.frame;
        frame.origin.y = self.toolbar.frame.origin.y - y;
        frame.size.height = frame.size.height + y;
        self.toolbar.frame = frame;
        self.toolbar.iconBtn.centerY = self.toolbar.textView.centerY;
        self.toolbar.sendBtn.centerY = self.toolbar.textView.centerY;
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.microblogFrame.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [TopicCell cellWithTabelView:tableView];
    cell.topView.delegate = self;
    cell.bootView.moreBtn.hidden = YES;
    cell.topView.praiseBtn.tag = 1000;
    cell.bootView.commentView.delegate = self;
    cell.microblogFrame = self.microblogFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)sendBtnClick
{
    [self.view endEditing:YES];
    if (self.toolbar.textView.text.length == 0) {
        [self showErrorWithStatus:@"发送内容为空"];
    }else
    {
    [self.netWork postReplyCommentsWithUserId:[RRTManager manager].loginManager.loginInfo.userId commentedObjectId:[NSString stringWithFormat:@"%@",self.micBlog.MicroblogId] body:self.toolbar.textView.text typeId:1 parentId:self.parentId success:^(NSDictionary *data) {
        [self showSuccessWithStatus:[data objectForKey:@"msg"]];
        [self getMoreComment];
        
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
    self.toolbar.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
    self.toolbar.textView.text = @"";
    self.toolbar.textView.frame = CGRectMake(30, 10,  SCREENWIDTH - 110, 30);
    self.toolbar.sendBtn.frame = CGRectMake(SCREENWIDTH - 55, 10, 50, 30);
    self.toolbar.procLable.hidden = NO;
    self.toolbar.procLable.text = @"说点什么...";
    self.parentId = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self dismiss];
        
    });
    }
}
- (void)btnClick:(int)tag
{
    if (tag == 1000) {
        [self.netWork postPraiseWithtoken:[RRTManager manager].loginManager.loginInfo.tokenId objectId:[NSString stringWithFormat:@"%@",self.micBlog.MicroblogId] typeId:1 success:^(NSDictionary *data) {
        } failed:^(NSString *errorMSG) {
            
        }];
    }
    
}
- (void)toUserBtnClick:(int)tag
{
    CommentCentent *comment = self.commentArray[tag];
    self.parentId = comment.Id;
    self.toolbar.procLable.text = [NSString stringWithFormat:@"回复:%@",comment.Author];
}

@end

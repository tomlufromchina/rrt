//
//  RecordDetailsController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "RecordDetailsController.h"
#import "ViewControllerIdentifier.h"
#import "UIImageView+WebCache.h"

#import "InputView.h"
#import "FaceBoard.h"

@interface RecordDetailsController ()<MLEmojiLabelDelegate,InputViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) FaceBoard *faceBoard;
@property (strong, nonatomic) UIImageView *headView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *subjectTitile;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UILabel *creatTime;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIView *pdView;//评论和赞的视图
@property (nonatomic, strong) MLEmojiLabel* emjolable;
@property (nonatomic, strong) MLEmojiLabel *commentlale;
@property (nonatomic, strong) JournalDetail *blogCommnts;
@property (nonatomic, strong) UILabel *llabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *backImg;

//临时变量
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复评论YES，还是回复某个人NO
@property (nonatomic, assign) int activityIndex;
@property (nonatomic, assign) int commentIndex;

@property (nonatomic, assign) BOOL isAnnimating;

@end

@implementation RecordDetailsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isAnnimating = NO;
    self.title = @"日志详情";
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self initView];
}

#pragma mark -- 初始化控件
#pragma mark --
- (void)initView
{
    [self requestData];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    self.scrollView.pagingEnabled = NO; //是否翻页
    self.scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;//滚动指示的风格
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    [self.headView.layer setMasksToBounds:YES];
    self.headView.layer.cornerRadius = 2.0;
    self.headView.layer.cornerRadius = 2.0;
    self.headView.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
    [self.scrollView addSubview:self.headView];
    
    self.name = [[UILabel alloc] init];
    self.name.top = self.headView.top;
    self.name.left = self.headView.right + 10;
    self.name.font = [UIFont systemFontOfSize:15];
    self.name.textColor = appColor;
    self.name.width = 192;
    self.name.height = 21;
    [self.scrollView addSubview:self.name];
    
    self.time = [[UILabel alloc] init];
    self.time.top = self.name.bottom + 5;
    self.time.font = [UIFont systemFontOfSize:13];
    self.time.textColor = [UIColor grayColor];
    self.time.left = self.headView.right + 10;
    self.time.width = 192;
    self.time.height = 21;
    [self.scrollView addSubview:self.time];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.top = self.headView.bottom + 10;
    self.lineView.left = self.headView.left - 10;
    self.lineView.width = self.view.bounds.size.width;
    self.lineView.height = 1;
    self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:self.lineView];
    
    self.subjectTitile = [[UILabel alloc] init];
    self.subjectTitile.top = self.lineView.bottom + 10;
    self.subjectTitile.font = [UIFont systemFontOfSize:15];
    self.subjectTitile.numberOfLines = 0;
    self.subjectTitile.left =  10;
    self.subjectTitile.width = self.view.bounds.size.width;
    self.subjectTitile.height = 30;
    [self.scrollView addSubview:self.subjectTitile];
    
    //init inputView
    self.inputView = [[InputView alloc] init];
    self.inputView.delegate = self;
    self.inputView.textField.delegate = self;
    CGRect rect = self.inputView.frame;
    self.inputView.frame = CGRectMake(rect.origin.x,
                                      self.view.frame.size.height,
                                      rect.size.width,
                                      rect.size.height);
    self.inputView.textField.placeholder = @"说点什么吧...";
    self.inputView.textField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:self.inputView];
    [self.inputView setHidden:YES];
    
    //init faceboard
    self.faceBoard = [[FaceBoard alloc] init];
    self.faceBoard.inputTextField = self.inputView.textField;
    rect = self.faceBoard.frame;
    self.faceBoard.frame = CGRectMake(rect.origin.x,
                                      self.view.frame.size.height,
                                      rect.size.width,
                                      rect.size.height);
    [self.view addSubview:self.faceBoard];
    [self.faceBoard setHidden:YES];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
     //添加自己做为观察者，以获取键盘显示时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //添加自己做为观察者，以获取键盘隐藏时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    

}
#pragma mark -- 整个界面数据请求
#pragma mark --
-(void)requestData
{
    [self showWithStatus:@""];
    [self.netWorkManager blogDetail:self.rid
                            success:^(NSArray *blogDetailArray) {
        [self dismiss];
        [self updateUI:blogDetailArray];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
}

#pragma mark -- 刷新界面
#pragma mark --
- (void)updateUI:(NSArray *)data
{
    if ([data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            self.blogCommnts = data[i];
            self.name.text = self.blogCommnts.Author;
            //        self.time.text = self.blogCommnts.DateCreated;
            self.subjectTitile.text = self.blogCommnts.Subject;
            [self.headView setImageWithURL:[NSURL URLWithString:self.blogCommnts.OwnerId] placeholderImage:[UIImage imageNamed:@"default"]];
            
            NSString* body = [self flattenHTML:self.blogCommnts.Body];
            //日志内容
            self.emjolable = [self createLableWithText:body font:[UIFont systemFontOfSize:15] width:300];
            self.emjolable.top=self.subjectTitile.bottom+10;
            self.emjolable.left = 10;
            [self.scrollView addSubview:self.emjolable];
            
            self.chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.chatBtn.width = 27;
            self.chatBtn.height = 26;
            self.chatBtn.left = 280;
            self.chatBtn.top = self.emjolable.bottom +10;
            [self.chatBtn setImage:[UIImage imageNamed:@"Chat_Message"] forState:UIControlStateNormal];
            [self.chatBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:self.chatBtn];
            
            //评论和赞的背景View
            self.pdView = [[UIView alloc] init];
            self.pdView.left = self.chatBtn.left - 120;
            self.pdView.top = self.emjolable.bottom + 8;
            self.pdView.width = 120;
            self.pdView.height = 30;
            self.pdView.alpha = 0;
            self.pdView.layer.cornerRadius = 3.0f;
            
            UIImageView *pdViewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pdView.width, self.pdView.height)];
            pdViewImageView.image = [UIImage imageNamed:@"presse_Back.png"];
            [self.pdView addSubview:pdViewImageView];
            
            UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.frame = CGRectMake(23, 8, 30, 15);
            pBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            [pBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [pBtn setTitle:@"赞" forState:UIControlStateNormal];
            [pBtn addTarget:self action:@selector(clickPraiseButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.pdView addSubview:pBtn];
            UIImageView *pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2.5, 27, 26)];
            pImageView.image = [UIImage imageNamed:@"praise"];
            [self.pdView addSubview:pImageView];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 8, 1, 15)];
            lineView.backgroundColor = [UIColor blackColor];
            [self.pdView addSubview:lineView];
            
            
            UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dBtn.frame = CGRectMake(85, 8, 30, 15);
            dBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            [dBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [dBtn setTitle:@"评论" forState:UIControlStateNormal];
            [dBtn addTarget:self action:@selector(clickDicussButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.pdView addSubview:dBtn];
            //评论
            UIImageView *dImageView = [[UIImageView alloc] initWithFrame:CGRectMake(57, 2.5, 27, 26)];
            dImageView.image = [UIImage imageNamed:@"dicuss"];
            [self.pdView addSubview:dImageView];
            [self.scrollView addSubview:self.pdView];
            
            //初始化评论界面
            self.creatTime = [[UILabel alloc] init];
            self.creatTime.top = self.emjolable.bottom + 10;
            self.creatTime.left = 10;
            self.creatTime.font = [UIFont systemFontOfSize:13];
            self.creatTime.textColor = [UIColor grayColor];
            self.creatTime.height = 20;
            self.creatTime.width = 155;
            self.creatTime.text = self.blogCommnts.DateCreated;
            [self.scrollView addSubview:self.creatTime];
            
            self.commentView = [[UIView alloc] init];
            self.commentView.top = self.creatTime.bottom + 10;
            self.commentView.left = 10;
            self.commentView.width = 300;
            [self.scrollView addSubview:self.commentView];
            
            self.backImg = [[UIImageView alloc] init];
            self.backImg.image = [UIImage imageNamed:@"commentbg.png"];
            self.backImg.image = [self.backImg.image stretchableImageWithLeftCapWidth:self.backImg.image.size.width * 0.7
                                                                         topCapHeight:self.backImg.image.size.height * 0.5];
            [self.commentView addSubview:self.backImg];
            
            self.imageView = [[UIImageView alloc] init];
            self.imageView.width = 18;
            self.imageView.top = 15;
            self.imageView.height = 14;
            self.imageView.left = 5;
            self.imageView.image = [UIImage imageNamed:@"favour18x14"];
            [self.commentView addSubview:self.imageView];
            
            UIView *linView = [[UIView alloc] init];
            linView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            linView.left = 0;
            linView.top = self.imageView.bottom + 7;
            linView.height = 0.7;
            linView.width = self.commentView.width;
            [self.commentView addSubview:linView];
            
            if ([self.blogCommnts.Comments count] > 0 || self.blogCommnts.Total > 0) {
                self.llabel = [[UILabel alloc] init];
                self.llabel.textColor = appColor;
                self.llabel.font = [UIFont systemFontOfSize:15];
                self.llabel.top = self.imageView.top;
                self.llabel.left = self.imageView.right + 7;
                self.llabel.width = 250;
                self.llabel.text = [NSString stringWithFormat:@"%@等%d人赞",self.blogCommnts.Detail,self.blogCommnts.Total];
                self.llabel.height = 14;
                [self.commentView addSubview:self.llabel];
                
                //评论内容
                NSString *comments = @"";
                for (int j = 0; j < [self.blogCommnts.Comments count]; j ++) {
                    BlogComments *bc=[self.blogCommnts.Comments objectAtIndex:j];
                    NSString* br = @"";
                    //换行
                    if (j < [self.blogCommnts.Comments count] - 1) {
                        br=@"\n";
                    }
                    if (bc.AtUserId > 0) {
                        comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC  回复 U[%@]U%dI%dIC%dC :%@", bc.Author,bc.OwnerId,i,j,bc.AtNickName,bc.AtUserId,i,bc.ParentId,[self flattenHTML:bc.Body]],br];
                    }else{
                        comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC :%@", bc.Author,bc.OwnerId,i,j,[self flattenHTML:bc.Body]],br];
                    }
                }
                self.commentlale = [self createLableWithText:comments font:[UIFont systemFontOfSize:15] width:280];
                if (self.commentlale != nil) {
                    self.commentlale.top = 41;
                    self.commentlale.left = 10;
                    //重新设置高度
                    self.commentView.height = self.commentlale.height +self.llabel.height + 50;
                    self.backImg.frame = CGRectMake(0, 0, self.commentView.width, self.commentView.height);
                    [self.commentView addSubview:self.commentlale];
                    
                }
                
                self.chatBtn.top = self.creatTime.top;
                self.chatBtn.left = self.creatTime.right + 115;
                //scrollView contentSize:
                CGSize newSize = CGSizeMake(self.view.frame.size.width, self.commentView.bottom + 10);
                [self.scrollView setContentSize:newSize];
                
            }else {
                
                self.commentView.hidden = YES;
                //scrollView contentSize:
                CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
                [self.scrollView setContentSize:newSize];
            }
            
        }
        
    }
}
#pragma mark -- 点赞按钮
#pragma mark --
- (void)clickPraiseButton:(UIButton *)sender
{
    [self showWithStatus:@""];
    [self.netWorkManager clickPraise:[RRTManager manager].loginManager.loginInfo.tokenId
                            ObjectId:self.blogCommnts.ThreadId ObjectTypeId:@"1"
                              UserId:[RRTManager manager].loginManager.loginInfo.userId
                            UserName:[RRTManager manager].loginManager.loginInfo.userName
                             success:^(NSDictionary *data) {
                                 [self dismiss];
                                 [self requestData];//重新刷新界面
                                 [self gotoMainUI];

                                 [self updateView:data];
    } failed:^(NSString *errorMSG) {
        [self showWithTitle:@"亲，你已经点过赞了哦！" withTime:1.5f];
    }];
    [UIView animateWithDuration:0.5f animations:^{
        self.pdView.alpha = 0;
    }];
}

- (void)updateView:(NSDictionary *)data
{
    NSString *mesege = [NSString stringWithFormat:@"%@",[data objectForKey:@"result"]];
    if ([mesege isEqualToString:@"-10"]) {
        [self showWithTitle:@"亲，你已经点过赞了哦！" defaultStr:nil];
    }
}

- (void)gotoMainUI
{
    [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
    
    if (self.block) {
        self.block();
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 评论按钮
#pragma mark --
- (void)clickDicussButton:(UIButton *)sender
{
    self.bReplyToComment = YES;
    [self.inputView.textField becomeFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        self.pdView.alpha = 0;
    }];
}
#pragma mark -- 点击赞/评论按钮
#pragma mark --
- (void)clickButton:(UIButton *)sender
{
    if (self.isAnnimating) {
        return;
    }
    self.isAnnimating = YES;
    if (sender.tag == 0) {
        [UIView animateWithDuration:0.5F animations:^{
            self.pdView.alpha = 1;
            sender.tag = 1;
        } completion:^(BOOL finished) {
            self.isAnnimating = NO;
        }];
    } else{
        [UIView animateWithDuration:0.5F animations:^{
            self.pdView.alpha = 0;
            sender.tag = 0;
        } completion:^(BOOL finished) {
            self.isAnnimating = NO;
        }];
        
    }
}

#pragma mark -- 过滤不相关字符
#pragma mark --
- (NSString *)flattenHTML:(NSString *)html{
    if (html==nil||[html isEqualToString:@""]) {
        return @"";
    }
    NSString *result = @"";
    NSRange arrowTagStartRange = [html rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) {
        NSRange arrowTagEndRange = [html rangeOfString:@">"];
        result = [html stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        return [self flattenHTML:result];    //递归，过滤下一个标签
    }else{
        result = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        result = [result stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];  // 过滤&rdquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"……"];  // 过滤&rdquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];  // 过滤&mdash;等标签
        result = [result stringByReplacingOccurrencesOfString:@"&bull;" withString:@"•"];  // 过滤&mdash;等标签
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];  // 过滤&mdash;等标签
        result = [result stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];  // 过滤&middot;等标签
        result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"ldquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"hellip;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"rdquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"mdash;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#160;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"middot;" withString:@"·"];
        result = [result stringByReplacingOccurrencesOfString:@"    " withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"Isquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"rsquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#183;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#10;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&lt;/p   xmlns=" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#215;" withString:@""];
    }
    return result;
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

#pragma mark emjodelegate

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeUser:
        {
            [self.inputView.textField becomeFirstResponder];
            self.inputView.textField.placeholder = @"输入回复内容";
            NSLog(@"点击了用户:%@",link);
            NSLog(@"用户id为:%d",[MLEmojiLabel getUserid:link]);
            NSLog(@"index为:%d",[MLEmojiLabel getIndex:link]);
            NSLog(@"CommentIndex为:%d",[MLEmojiLabel getCommentID:link]);
            
            self.bReplyToComment = NO;
            self.activityIndex = [MLEmojiLabel getIndex:link];
            self.commentIndex = [MLEmojiLabel getCommentID:link];
        }
            break;
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接:%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话:%@",link);
            break;  
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱:%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥:%@",link);
            break;
    }
    
}
#pragma mark -- 评论请求
#pragma mark --
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //评价
    if (self.bReplyToComment) {
        [self showWithStatus:@""];
        [self.netWorkManager clickComment:self.blogCommnts.ThreadId
                                   UserId:[RRTManager manager].loginManager.loginInfo.userId
                                     Body:self.inputView.textField.text TypeId:@"2"
                                  success:^(NSDictionary *data) {
                                      [self dismiss];
                                      //成功后回调：
                                      [self requestData];
                                      [self gotoMainUI];
                                  } failed:^(NSString *errorMSG) {
                                      [self showErrorWithStatus:errorMSG];
                                  }];
        [self.inputView.textField resignFirstResponder];
        return YES;
    //回复
    } else {
        
        BlogComments *blog = [self.blogCommnts.Comments objectAtIndex:self.commentIndex];
        [self.netWorkManager clickReply:[NSString stringWithFormat:@"%d",blog.CommentedObjectId]
                                 UserId:[RRTManager manager].loginManager.loginInfo.userId
                                   Body:self.inputView.textField.text
                                 TypeId:@"2"
                               ParentId:[NSString stringWithFormat:@"%d",blog.Id]
                                success:^(NSDictionary *data) {
                                    [self requestData];
                                    [self gotoMainUI];

        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
        
        
    }
    [self.inputView.textField resignFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.inputView setHidden:YES];
}

#pragma mark - keyboard show and hide
#pragma mark -
- (void)keyboardShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height + self.inputView.frame.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.inputView setHidden:NO];
                         self.inputView.transform=CGAffineTransformMakeTranslation(0, -ty);
                     }];
    
}

- (void)keyboardHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.inputView setHidden:YES];
                         self.inputView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    [self.inputView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

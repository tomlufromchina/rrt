    //
//  WeiboDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-27.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "WeiboDetailsViewController.h"
#import "ViewControllerIdentifier.h"
#import "UIImageView+WebCache.h"



@interface WeiboDetailsViewController ()

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *headView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *subjectTitile;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UILabel *creatTime;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UILabel *llabel;
@property (nonatomic, strong) UIView *potoview;//放图片
@property (nonatomic, strong) MicroblogDetail *micDetail;
@property (nonatomic, strong) MLEmojiLabel* emjolable;
@property (nonatomic, strong) MLEmojiLabel *commentlale;

@property (nonatomic, strong) UIView *pdView;//评论和赞的视图
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIView *lineView1;

@property(nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) FaceBoard *faceBoard;

//临时变量
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复评论1，还是回复某个人0
@property (nonatomic, assign) int activityIndex;
@property (nonatomic, assign) int commentIndex;

@property (nonatomic, assign) BOOL isAnnimating;

@end

@implementation WeiboDetailsViewController

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
    self.title = @"微博详情";
    self.isAnnimating = NO;
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self initView];
    
}

#pragma mark -- 初始化控件

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
    self.time.font = [UIFont systemFontOfSize:12];
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
#pragma mark -- 界面数据请求

- (void)requestData
{
    [self show];
    [self.netWorkManager weiboDetail:self.weiboID success:^(NSArray *micArray) {
        [self dismiss];
        [self updateUI:micArray];
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}
#pragma mark -- 刷新界面

- (void)updateUI:(NSArray *)data
{
    if ([data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            self.micDetail = data[i];
            NSLog(@"%@",self.micDetail.MicroblogId);
            self.name.text = self.micDetail.Author;
            //        self.time.text = self.micDetail.DateCreated;
            [self.headView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",appHeadImage,[RRTManager manager].loginManager.loginInfo.userId,@".jpg"]] placeholderImage:[UIImage imageNamed:@"default"]];
            //内容：
            NSString *body = [self flattenHTML:self.micDetail.Body];
            self.emjolable = [self createLableWithText:body font:[UIFont systemFontOfSize:15] width:300];
            self.emjolable.top=self.lineView.bottom+10;
            self.emjolable.left = 10;
            [self.scrollView addSubview:self.emjolable];
            //相册View
            self.potoview.height = 0;
            if (self.micDetail.imageArray != nil && [self.micDetail.imageArray count] >0) {
                self.potoview = [[UIView alloc] init];
                self.potoview.top = self.emjolable.bottom +10;
                [self loadPhoto:self.micDetail];//算高度
                [self.scrollView addSubview:self.potoview];
            }else{
                self.potoview.top = self.emjolable.bottom;
            }
            
            //初始化评论界面
            self.creatTime = [[UILabel alloc] init];
            self.creatTime.left = 10;
            self.creatTime.font = [UIFont systemFontOfSize:13];
            self.creatTime.textColor = [UIColor grayColor];
            self.creatTime.height = 20;
            self.creatTime.width = 150;
            self.creatTime.text = self.micDetail.DateCreatedStr;
            [self.scrollView addSubview:self.creatTime];
            
            //评论View
            self.commentView = [[UIView alloc] init];
            self.commentView.left = 10;
            self.commentView.layer.cornerRadius = 2.0f;
            self.commentView.width = 300;
            [self.scrollView addSubview:self.commentView];
            
            self.backImg = [[UIImageView alloc] init];
            self.backImg.image = [UIImage imageNamed:@"commentbg.png"];
            self.backImg.image = [self.backImg.image stretchableImageWithLeftCapWidth:self.backImg.image.size.width * 0.7
                                                                         topCapHeight:self.backImg.image.size.height * 0.5];
            [self.commentView addSubview:self.backImg];
            
            if (self.micDetail.imageArray != nil && [self.micDetail.imageArray count] >0) {
                self.creatTime.top = self.potoview.bottom + 10;
                self.chatBtn.top = self.creatTime.top;
                self.commentView.top = self.creatTime.bottom + 12;
            }else{
                self.creatTime.top = self.emjolable.bottom + 10;
                self.commentView.top = self.creatTime.bottom + 10;
            }
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.width = 18;
            imageView.top = 15;
            imageView.height = 14;
            imageView.left = 5;
            imageView.image = [UIImage imageNamed:@"favour18x14"];
            [self.commentView addSubview:imageView];
            
            UIView *linView = [[UIView alloc] init];
            linView.backgroundColor = [UIColor groupTableViewBackgroundColor    ];
            linView.left = 0;
            linView.top = imageView.bottom + 5;
            linView.height = 0.7;
            linView.width = self.commentView.width;
            [self.commentView addSubview:linView];
            
            self.chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.chatBtn.top = self.creatTime.top;
            self.chatBtn.left = self.creatTime.right + 125;
            self.chatBtn.width = 27;
            self.chatBtn.height = 26;
            [self.chatBtn setImage:[UIImage imageNamed:@"Chat_Message"] forState:UIControlStateNormal];
            [self.chatBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:self.chatBtn];
            
            //评论和赞的背景View
            self.pdView = [[UIView alloc] init];
            self.pdView.left = self.chatBtn.left - 120;
            self.pdView.top = self.creatTime.top ;
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
            
            self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(50, 8, 1, 15)];
            self.lineView1.backgroundColor = [UIColor blackColor];
            [self.pdView addSubview:self.lineView1];
            
            
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
            
            if ([self.micDetail.Comments count] > 0 || self.micDetail.Total > 0) {
                self.llabel = [[UILabel alloc] init];
                self.llabel.textColor = appColor;
                self.llabel.font = [UIFont systemFontOfSize:15];
                self.llabel.top = imageView.top;
                self.llabel.left = imageView.right + 7;
                self.llabel.width = 250;
                self.llabel.text = [NSString stringWithFormat:@"%@等%d人赞",self.micDetail.Detail,self.micDetail.Total];
                self.llabel.height = 14;
                [self.commentView addSubview:self.llabel];
                
                //评论内容
                NSString *comments = @"";
                for (int j = 0; j < [self.micDetail.Comments count]; j ++) {
                    BlogComments *bc = [self.micDetail.Comments objectAtIndex:j];
                    NSString* br=@"";
                    //换行
                    if (j < [self.micDetail.Comments count]-1) {
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
                    self.commentlale.top = 47;
                    self.commentlale.left = 10;
                    //重新设置高度
                    self.commentView.height = self.commentlale.height +self.llabel.height + 50;
                    self.backImg.frame = CGRectMake(0, 0, self.commentView.width, self.commentView.height);
                    [self.commentView addSubview:self.commentlale];
                }
                //scrollView contentSize:
                CGSize newSize = CGSizeMake(self.view.frame.size.width, self.commentView.bottom + 10);
                [self.scrollView setContentSize:newSize];
                
            }else{
                self.commentView.hidden = YES;
                //scrollView contentSize:
                CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
                [self.scrollView setContentSize:newSize];
                
            }
        }
    }
}

- (void)clickButton:(UIButton *)sender
{
    if (self.isAnnimating) {
        return;
    }
    self.isAnnimating = YES;
    if (sender.tag == 0) {
        [UIView animateWithDuration:0.5f animations:^{
            self.pdView.alpha = 1;
            sender.tag = 1;
        } completion:^(BOOL finished) {
            self.isAnnimating = NO;
        }];
    } else{
        [UIView animateWithDuration:0.5f animations:^{
            self.pdView.alpha = 0;
            sender.tag = 0;
        } completion:^(BOOL finished) {
            self.isAnnimating = NO;
        }];
        
    }
}

#pragma mark -- 点赞按钮
#pragma mark --
- (void)clickPraiseButton:(UIButton *)sender
{
    [self show];
//    [self.netWorkManager clickPraise:[RRTManager manager].loginManager.loginInfo.tokenId
//                            ObjectId:self.micDetail.MicroblogId
//                        ObjectTypeId:@"2"
//                              UserId:[RRTManager manager].loginManager.loginInfo.userId
//                            UserName:[RRTManager manager].loginManager.loginInfo.userName
//                             success:^(NSDictionary *data) {
//                                 [self dismiss];
//                                 [self requestData];
//    } failed:^(NSString *errorMSG) {
//        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"亲，你已经点过赞了哦！" ];

        
//    }];
//    [UIView animateWithDuration:0.5f animations:^{
//        self.pdView.alpha = 0;
//    }];
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

#pragma mark emjodelegate

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeUser:
        {
            [self.inputView.textField becomeFirstResponder];
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
    //评论
//    if (self.bReplyToComment) {
//        [self show];
//        [self.netWorkManager clickComment:self.micDetail.MicroblogId
//                                   UserId:[RRTManager manager].loginManager.loginInfo.userId
//                                     Body:self.inputView.textField.text TypeId:@"1"
//                                  success:^(NSDictionary *data) {
//                                      [self dismiss];
//                                      //成功后回调：
//                                      [self requestData];
//                                  } failed:^(NSString *errorMSG) {
//                                      [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                  }];
//        [self.inputView.textField resignFirstResponder];
//        return YES;
//    //回复
//    } else {
//        BlogComments *mic = [self.micDetail.Comments objectAtIndex:self.commentIndex];
//        [self.netWorkManager clickReply:@"www"
//                                 UserId:[RRTManager manager].loginManager.loginInfo.userId
//                                   Body:self.inputView.textField.text
//                                 TypeId:@"1"
//                               ParentId:[NSString stringWithFormat:@"%d",mic.Id]
//                                success:^(NSDictionary *data) {
//                                    [self dismiss];
//                                    [self requestData];
//                                    
//                                } failed:^(NSString *errorMSG) {
//                                    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                }];
//        
//    }
//    [self.inputView.textField resignFirstResponder];
    return YES;
}

#pragma mark -- 计算相片高度和个数

- (void)loadPhoto:(MicroblogDetail *)md
{
    if ([md.imageArray count]>0) {
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        //图片的宽高
        CGFloat width = 70;
        CGFloat height = 70;
        CGFloat margin = 10;//每张图片的间距
        for (int i = 0; i < [md.imageArray count]; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.potoview addSubview:imageView];
            
            // 计算位置：每行三张图片
            int row = i/3; //行
            int column = i%3; //列
            CGFloat x =  column * (width + margin);
            CGFloat y =  row * (height + margin);
            imageView.frame = CGRectMake(x, y, width, height);
            NSString* urlstr=[md.imageArray objectAtIndex:i];
            
            // 下载图片
            [imageView setImageURLStr:urlstr placeholder:placeholder];
            
            // 事件监听
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            //重写手势：PhotoUITapGestureRecognizer
            PhotoUITapGestureRecognizer *tap = [[PhotoUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            tap.md = md;
            tap.img = imageView;
            [imageView addGestureRecognizer:tap];
            
            // 内容模式
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        float vheight = 0;
        int s = (int)[md.imageArray count] / 3;
        int y = (int)[md.imageArray count] % 3;
        if (y > 0) {
            s += 1;
        }
        vheight=s*80;
        //重新设置potoview高度：
        [self.potoview setFrame:CGRectMake(self.emjolable.left + 30, self.emjolable.bottom+10, 237, vheight)];
   }
}
#pragma mark -- 每张相片的手势方法

- (void)tapImage:(PhotoUITapGestureRecognizer *)tap
{
    NSUInteger count = [tap.md.imageArray count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        
        NSString* url=[tap.md.imageArray objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = tap.img; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark -- 过滤相关字符

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
        result = [result stringByReplacingOccurrencesOfString:@"middot;" withString:@"·"];
        result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"ldquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"hellip;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"rdquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"mdash;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#160;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"    " withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"Isquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"rsquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#183;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#10;" withString:@""];
    }
    return result;
}

#pragma mark emjolable

-(MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
    MLEmojiLabel*_emojiLabel = [[MLEmojiLabel alloc]init];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
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

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    [self.inputView setHidden:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

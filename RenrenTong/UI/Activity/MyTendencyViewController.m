//
//  MyTendencyViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-29.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MyTendencyViewController.h"
#import "RecordListViewController.h"
#import "WeiboListingViewController.h"
#import "PhotosTableViewController.h"
#import "RecordDetailCell.h"
#import "MJRefresh.h"
#import "InputView.h"
#import "FaceBoard.h"

@interface MyTendencyViewController ()<InputViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate,RecordDetailCellDelegate>
{
    NSString *_headerURL;
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) MyDynamic *myDynamic;
@property (nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) FaceBoard *faceBoard;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray* emjoalablearray;
@property (nonatomic, strong) NSMutableArray* commentlablearray;

//临时变量
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复还是评论  评论某人1，回复某个人0
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int activityIndex;
@property (nonatomic, assign) int commentIndex;
@property (nonatomic, strong) NSString *typeId;


@end

@implementation MyTendencyViewController

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
    self.title = @"我的动态";
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainTableView addGestureRecognizer:tapGesture];
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    [self viewDidLoadInit];
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark viewDidLoadInit
-(void)viewDidLoadInit
{
    self.pageIndex = 1;
    self.pageSize = 10;
    
//    [self.mainTableView registerNib:[UINib nibWithNibName:@"ActivityHeaderCell" bundle:nil]
//         forCellReuseIdentifier:@"ActivityHeaderCell"];
    
    self.emjoalablearray = [[NSMutableArray alloc] init];
    self.commentlablearray = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:appColor];
    
    //init inputView
    self.inputView = [[InputView alloc] init];
    self.inputView.delegate = self;
    self.inputView.textField.delegate = self;
    CGRect rect = self.inputView.frame;
    self.inputView.frame = CGRectMake(rect.origin.x,
                                      self.view.frame.size.height,
                                      rect.size.width,
                                      rect.size.height);
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
    
    //register keyboard note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadData];
    
}
#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark loadData
-(void)loadData{
    [self show];
    
    [self.netWorkManager myDynamic:[RRTManager manager].loginManager.loginInfo.userId
                            typeId:0
                         PageIndex:self.pageIndex
                          PageSize:self.pageSize
                           success:^(NSMutableArray *MyDynamic) {
        [self dismiss];
        [self updateView:MyDynamic];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
    
    [self.netWorkManager getUIData:[RRTManager manager].loginManager.loginInfo.tokenId
                           success:^(NSMutableArray *data) {
                               if (data) {
                                   [self dismiss];
                                   
                                   _headerURL = [data[0] objectForKey:@"PictureUrl"];
                                   
                                   NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
                                   ActivityHeaderCell *cell = (ActivityHeaderCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
                                   
                                   [cell.avatarImgView setImageWithURL:[NSURL URLWithString:_headerURL]
                                                      placeholderImage:[UIImage imageNamed:@"default.png"]
                                                               options:SDWebImageRefreshCached];
                               }
                           } failed:^(NSString *errorMSG) {
                               [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                               
                           }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
}

- (void)updateView:(NSMutableArray *)data
{
    if (data) {
        for(int i = 0; i < [data count]; i ++) {
            MyDynamic *obj = [data objectAtIndex:i];
            switch (obj.applicationid) {
                case 1001://微博
                    obj.Body = [self flattenHTML:obj.Body];
                    [_emjoalablearray addObject:[self createLableWithText:obj.Body font:[UIFont systemFontOfSize:15] width:230]];
                    break;
                case 1002://日志
                    obj.Subject = [self flattenHTML:obj.Subject];
                    obj.Subject = [NSString stringWithFormat:@"%@ 发表了日志《%@》", obj.Author,obj.Subject];
                    obj.Body = [self flattenHTML:obj.Body];
                    if (obj.Body.length>140) {
                        obj.Body = [NSString stringWithFormat:@"%@……",[obj.Body substringWithRange:NSMakeRange(0,140)]];
                    }
                    [_emjoalablearray addObject:[self createLableWithText:obj.Body font:[UIFont systemFontOfSize:15] width:230]];
                    break;
                case 1003://相册
                    obj.dynNew = [self flattenHTML:obj.dynNew];
                    [_emjoalablearray addObject:[self createLableWithText:obj.dynNew font:[UIFont systemFontOfSize:15] width:230]];
                    break;
            }
            //评论
            if ([obj.Comments count]>0) {
                NSString* comment=@"";
                
                for (int j = 0; j < [obj.Comments count]; j ++) {
                    DynamicComments *dic=[obj.Comments objectAtIndex:j];
                    NSString* br = @"";
                    //换行
                    if (j<[obj.Comments count]-1) {
                        br = @"\n";
                    }
                    if (dic.AtUserId > 0) {
                        comment = [NSString stringWithFormat:@"%@%@%@", comment,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC  回复 U[%@]U%dI%dIC%dC :%@", dic.Author,dic.OwnerId,i,j,dic.AtNickName,dic.AtUserId,i,dic.ParentId,[self flattenHTML:dic.Body]],br];
                    }else{
                        comment = [NSString stringWithFormat:@"%@%@%@", comment,[NSString stringWithFormat:@"U[%@]U%dI%dIC%dC :%@", dic.Author,dic.OwnerId,i,j,[self flattenHTML:dic.Body]],br];
                    }
                }
                [_commentlablearray addObject:[self createLableWithText:comment font:[UIFont systemFontOfSize:15] width:220]];
            }else{
                [_commentlablearray addObject:@""];
            }

            [self.dataSource addObject:obj];
        }
        self.pageIndex ++;
        [self.mainTableView reloadData];
    }
}


#pragma mark -- TableViewDelegete
#pragma mark --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 1;
    
    if (section == 1) {
        count = [self.dataSource count];
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 225;
    }else{
        CGFloat height = 45;
        height += ((MLEmojiLabel*)[_emjoalablearray objectAtIndex:indexPath.row]).height;
        MyDynamic* MD = (MyDynamic*)[self.dataSource objectAtIndex:indexPath.row];
        if (MD.hasImage && MD.Photos && MD.applicationid != 1002) {
            int s = (int)[MD.Photos count] / 3;
            int y = (int)[MD.Photos count] % 3;
            if (y>0) {
                s += 1;
            }
            height += s*80 + 10;
        }
        if (MD.applicationid == 1002) {
            //查看全文高度
            float readMoreHeight = 15;
            height += readMoreHeight + 10;
            
            UIFont *font = [UIFont systemFontOfSize:13];
            //设置一个行高上限
            CGSize size = CGSizeMake(230 ,2000);
            
            CGFloat labelheight = [MD.Subject boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
            
            height += labelheight + 33;
        }
        float timerheight = 26;
        height += timerheight;
        if (MD.Total > 0){
            height += 50;
        }else{
            height += 5;
        }
        if ([MD.Comments count] > 0) {
            height += ((MLEmojiLabel*)[_commentlablearray objectAtIndex:indexPath.row]).height+20;
        }
        if (MD.Total > 0 || [MD.Comments count] > 0) {
            height += 10;
        }
        height += 10;
        return height;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        static NSString *cellIdentifier = @"ActivityHeaderCell";
        ActivityHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityHeaderCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//没有点击效果
        }
        
        if (self.dataSource && [self.dataSource count] > 0) {
            MyDynamic *myDnamic = [self.dataSource objectAtIndex:indexPath.row];
            cell.weiboLabel.text = [NSString stringWithFormat:@"%d",myDnamic.microBlogNumber];
            cell.recordLabel.text = [NSString stringWithFormat:@"%d",myDnamic.blogThreadNumber];
            cell.albumLabel.text = [NSString stringWithFormat:@"%d",myDnamic.albumNumber];
        } else {
            cell.weiboLabel.text = [NSString stringWithFormat:@"0"];
            cell.recordLabel.text = [NSString stringWithFormat:@"0"];
            cell.albumLabel.text = [NSString stringWithFormat:@"0"];
        }
        
        [cell.countView setHidden:NO];
        
        [cell.weiboBtn addTarget:self action:@selector(weiboDeatil) forControlEvents:UIControlEventTouchUpInside];
        [cell.recordBtn addTarget:self action:@selector(recDeatil) forControlEvents:UIControlEventTouchUpInside];
        [cell.albumBtn addTarget:self action:@selector(photoDeatil) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
        
    } else{
        static NSString *cellIdentifier = @"RecordDetailCell";
        //自定义cell类
        RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordDetailCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        MyDynamic *myDnamic = self.dataSource[indexPath.row];
        cell.delegate = self;
        cell.selfDyamic = myDnamic;
        //头像
        [cell.headView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%d.jpg",aedudomain,myDnamic.userId]]];
        [cell.headView.layer setMasksToBounds:YES];
        cell.headView.layer.cornerRadius = 2.0;
        cell.headView.layer.cornerRadius = 2.0;
        cell.headView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        cell.headView.height = 35;
        //用户名
        cell.userName.text = myDnamic.OwnerName;
        cell.userName.textColor = appColor;
        cell.subject.frame = CGRectMake(cell.userName.left, cell.headView.bottom, 230, 0);
        cell.creatTimeStr.text = myDnamic.DateCreatedStr;
        cell.creatTimeStr.left = cell.userName.left;
        if (myDnamic.applicationid == 1002) {
            cell.subject.text = myDnamic.Subject;
            CGSize size = CGSizeMake(230,2000);
            CGFloat labelheight = [myDnamic.Subject boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.subject.font} context:nil].size.height;
            cell.subject.frame = CGRectMake(cell.userName.left, cell.headView.bottom, 230, labelheight);
        }
        cell.content = [_emjoalablearray objectAtIndex:indexPath.row];
        if (myDnamic.applicationid == 1002) {
            [cell.moreBtn setHidden:NO];
            cell.content.top = cell.subject.bottom + 10;
            cell.moreBtn.top = cell.content.bottom + 10;
            cell.moreBtn.tag = [myDnamic.ThreadId intValue];
            [cell.moreBtn addTarget:self action:@selector(threadIdDetail:) forControlEvents:UIControlEventTouchUpInside];
            cell.creatTimeStr.top = cell.moreBtn.bottom+10;
        } else {
            [cell.moreBtn setHidden:YES];
            cell.content.top = cell.subject.bottom;
            cell.creatTimeStr.top = cell.content.bottom+10;
        }
        cell.content.left = cell.userName.left;
        [cell addSubview:[_emjoalablearray objectAtIndex:indexPath.row]];
        
        if (myDnamic.hasImage && myDnamic.applicationid != 1002) {
            [self loadPhoto:cell md:myDnamic];
        }
        cell.preseBtn.top = cell.creatTimeStr.top - 5;
        cell.preseBtn.tag = 0;
        cell.praiseAndDiscussView.top = cell.creatTimeStr.top;
        cell.praiseAndDiscussView.clipsToBounds = YES;
        cell.praiseAndDiscussView.frame = CGRectMake(cell.preseBtn.left, cell.preseBtn.top, 0, 30);
        cell.conmentView.top = cell.creatTimeStr.bottom + 10;
        if (myDnamic.Total <= 0 && [myDnamic.Comments count] <= 0) {
            cell.conmentView.hidden = YES;
        } else {
            cell.conmentView.hidden = NO;
            if (myDnamic.Total > 0) {
                cell.conmentView.height = 50;
                cell.prieseviewdetail.frame = CGRectMake(5, 15, 220, 25);
                cell.prieseviewdetail.hidden = NO;
                cell.praiseName.text = [NSString stringWithFormat:@"%@等%d人赞", myDnamic.Detail,myDnamic.Total];
                NSLog(@"%@",cell.praiseName.text);
                cell.praiseName.textColor  = appColor;
            } else {
                cell.prieseviewdetail.frame = CGRectMake(5, 5, 220, 0);
                cell.prieseviewdetail.hidden = YES;
            }
            
            if ([myDnamic.Comments count] > 0) {
                MLEmojiLabel* commentlable = [_commentlablearray objectAtIndex:indexPath.row];
                commentlable.top = cell.prieseviewdetail.bottom+10;
                commentlable.left = 5;
                [cell.conmentView addSubview:commentlable];
                cell.conmentView.height = commentlable.bottom + 10;
                if (myDnamic.Total>0) {
                    cell.prieseviewdetail.frame = CGRectMake(5, 15, 220, 25);
                    cell.prieseviewdetail.hidden = NO;
                }else{
                    cell.prieseviewdetail.frame = CGRectMake(5, 5, 220, 0);
                    cell.prieseviewdetail.hidden = YES;
                }
            }
        }
        return cell;
    }
}
//计算图片高度
-(void)loadPhoto:(RecordDetailCell *)cell md:(MyDynamic*)md{
    if ([md.Photos count]>0) {
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        cell.photoview=[[UIView alloc] init];
        CGFloat width = 70;
        CGFloat height = 70;
        CGFloat margin = 10;
        for (int i = 0; i < [md.Photos count]; i ++) {
            NSDictionary *photo = md.Photos[i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [cell.photoview addSubview:imageView];
            
            // 计算位置
            int row = i/3;
            int column = i%3;
            CGFloat x =  column * (width + margin);
            CGFloat y =  row * (height + margin);
            imageView.frame = CGRectMake(x, y, width, height);
            NSString* urlstr;
            switch (md.applicationid) {
                case 1001://微博
                    urlstr = [photo objectForKey:@"FileName"];
                    break;
                case 1002://日志
                    urlstr = [photo objectForKey:@"FileName"];
                    break;
                case 1003://相册
                    urlstr = [photo objectForKey:@"RelativePath"];
                    break;
                default:
                    urlstr = [photo objectForKey:@"FileName"];
                    break;
            }
            
            // 下载图片
            [imageView setImageURLStr:urlstr placeholder:placeholder];
            
            // 事件监听
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            
            //重写手势满足需求
            PhotoUITapGestureRecognizer *tap = [[PhotoUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            tap.My = md;
            tap.img = imageView;
            [imageView addGestureRecognizer:tap];
            
            // 内容模式
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        float vheight = 0;
        int s = (int)[md.Photos count] / 3;
        int y = (int)[md.Photos count] % 3;
        if (y > 0) {
            s += 1;
        }
        vheight = s*80;
        [cell.photoview setFrame:CGRectMake(cell.userName.left, cell.content.bottom+10, 230, vheight)];
        cell.creatTimeStr.top = cell.photoview.bottom+10;
        [cell addSubview:cell.photoview];
    }
}

- (void)tapImage:(PhotoUITapGestureRecognizer *)tap
{
    NSUInteger count = [tap.My.Photos count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        
        NSString* url;
        switch (tap.My.applicationid) {
            case 1001://微博
                url = [tap.My.Photos[i] objectForKey:@"FileName"];
                break;
            case 1002://日志
                url = [tap.My.Photos[i] objectForKey:@"FileName"];
                break;
            case 1003://相册
                url = [tap.My.Photos[i] objectForKey:@"RelativePath"];
                break;
            default:
                url = [tap.My.Photos[i] objectForKey:@"FileName"];
                break;
        }
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

//日志查看全文
-(void)threadIdDetail:(UIButton*)sender{
    NSLog(@"日志id：%d", sender.tag);
    RecordDetailsController *VC = [[RecordDetailsController alloc] init];
    VC.rid = [NSString stringWithFormat:@"%d",sender.tag];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    __weak MyTendencyViewController *_self = self;
    CommonSuccessBlock block = ^(void){
        [_self headerReresh];
    };
    
    VC.block = block;
    
    
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- 过滤文本方法
#pragma mark --
- (NSString *)flattenHTML:(NSString *)html{
    if (html == nil || [html isEqualToString:@""]) {
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
        result = [result stringByReplacingOccurrencesOfString:@"&lt;/p   xmlns=" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"[attach:1795722]" withString:@""];
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

#pragma mark emjodelegate

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type)
    {
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

#pragma  mark -- RecordDetailCell Delegate
#pragma  mark --
- (void)commentCellClicked:(MyDynamic *)friendDynamicDetail
{
    self.bReplyToComment = YES;
    self.myDynamic = friendDynamicDetail;
    [self.inputView.textField becomeFirstResponder];
    self.inputView.textField.placeholder = @"说点什么吧...";
}

- (void)praiseCellClicked:(MyDynamic *)friendDynamicDetail
{
    self.myDynamic = friendDynamicDetail;
    if ((self.myDynamic.applicationid) == 1001) {
        self.typeId = @"2";//微博
    }else if ((self.myDynamic.applicationid) == 1002){
        self.typeId = @"1";//日志
    }else {
        self.typeId = @"0";//相册动态
    }
    
//    __weak MyTendencyViewController *_self = self;
//    [self.netWorkManager clickPraise:[RRTManager manager].loginManager.loginInfo.tokenId
//                            ObjectId:[NSString stringWithFormat:@"%d",self.myDynamic.sourceId]
//                        ObjectTypeId:self.typeId
//                              UserId:[RRTManager manager].loginManager.loginInfo.userId
//                            UserName:[RRTManager manager].loginManager.loginInfo.userName
//                             success:^(NSDictionary *data) {
//                                 [self dismiss];
//                                 
//                                 [_self headerReresh];
//                             } failed:^(NSString *errorMSG) {
//                                 [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                             }];
}

#pragma mark - UITextField delegate
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    __weak MyTendencyViewController *_self = self;
//    if (self.bReplyToComment) {
//        MyDynamic *fr = self.myDynamic;
//        
//        if ((fr.applicationid) == 1001) {
//            self.typeId = @"1";//微博
//        }else if ((fr.applicationid) == 1002){
//            self.typeId = @"2";//日志
//        }else {
//            [self.netWorkManager albumComment:[RRTManager manager].loginManager.loginInfo.tokenId
//                            CommentedObjectId:[NSString stringWithFormat:@"%d",fr.ActivityId]
//                                      OwnerId:[NSString stringWithFormat:@"%d",fr.OwnerId]
//                                       UserId:[RRTManager manager].loginManager.loginInfo.userId
//                                       Author:[RRTManager manager].loginManager.loginInfo.userName
//                                      subject:@"123"
//                                         body:self.inputView.textField.text
//                                      success:^(NSDictionary *data) {
//                                          [self dismiss];
//                                          [self headerReresh];//重新刷新界面
//                                      } failed:^(NSString *errorMSG) {
//                                          [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                      }];
//            
//            [self.inputView.textField resignFirstResponder];
//            return YES;
//        }
//        
//        [self.netWorkManager clickComment:[NSString stringWithFormat:@"%d",fr.sourceId]
//                                   UserId:[RRTManager manager].loginManager.loginInfo.userId
//                                     Body:self.inputView.textField.text
//                                   TypeId:self.typeId
//                                  success:^(NSDictionary *data) {
//                                    [self dismiss];
//                                    [self headerReresh];//重新刷新界
//                                  } failed:^(NSString *errorMSG) {
//                                      [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                  }];
//       //回复
//    } else {
//        MyDynamic *detail = [self.dataSource objectAtIndex:self.activityIndex];
//        DynamicComments *comment = [detail.Comments objectAtIndex:self.commentIndex];
//        NSString *type = @"";
//        if (detail.applicationid == 1001) {
//            type = @"1";//微博
//        } else if (detail.applicationid == 1002) {
//            type = @"2";//日志
//        } else {
//            [self.netWorkManager albumReply:[RRTManager manager].loginManager.loginInfo.tokenId
//                          CommentedObjectId:[NSString stringWithFormat:@"%d",detail.ActivityId]
//                                    OwnerId:[NSString stringWithFormat:@"%d",detail.OwnerId]
//                                     UserId:[RRTManager manager].loginManager.loginInfo.userId
//                                     Author:[RRTManager manager].loginManager.loginInfo.userName
//                                    subject:@"123"
//                                       body:self.inputView.textField.text
//                                   ToUserId:[NSString stringWithFormat:@"%d", comment.UserId]
//                                 ToUserName:comment.Author
//                                    success:^(NSDictionary *data) {
//                                        [_self dismiss];
//                                        [_self headerReresh];//重新刷新界面
//                                    } failed:^(NSString *errorMSG) {
//                                        [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                    }];
//            
//            [self.inputView.textField resignFirstResponder];
//            return YES;
//            
//        }
//        
//        __weak MyTendencyViewController *_self = self;
//        
//        [self show];
//        [self.netWorkManager clickReply:[NSString stringWithFormat:@"%d", detail.sourceId]
//                                 UserId:[RRTManager manager].loginManager.loginInfo.userId
//                                   Body:_self.inputView.textField.text
//                                 TypeId:type
//                               ParentId:[NSString stringWithFormat:@"%d", comment.Id]
//                                success:^(NSDictionary *data) {
//                                    [_self dismiss];
//                                    [_self headerReresh];//重新刷新界面
//                                } failed:^(NSString *errorMSG) {
//                                    [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
//                                }];
//    }
//    
//    [self.inputView.textField resignFirstResponder];
    return YES;
}

-(void)weiboDeatil{
    
    WeiboListingViewController *vc = [[WeiboListingViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)recDeatil{
    [self.navigationController pushViewController:RecordListVCID
                                   withStoryBoard:ActivityStoryBoardName
                                        withBlock:nil];
}

-(void)photoDeatil{
    [self.navigationController pushViewController:PhotosVCID
                                   withStoryBoard:ActivityStoryBoardName
                                        withBlock:nil];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __weak MyTendencyViewController *_self = self;
    [self show];
    self.pageIndex = 1;
    [self.netWorkManager myDynamic:[RRTManager manager].loginManager.loginInfo.userId
                            typeId:0
                         PageIndex:self.pageIndex
                          PageSize:self.pageSize
                           success:^(NSMutableArray *MyDynamic) {
                               [_self dismiss];
                               [_self.dataSource removeAllObjects];
                               [_self.emjoalablearray removeAllObjects];
                               [_self.commentlablearray removeAllObjects];
                               _self.pageIndex = 1;
                               [_self updateView:MyDynamic];
                               [_self.mainTableView headerEndRefreshing];
                           } failed:^(NSString *errorMSG) {
                               [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                               [_self.mainTableView headerEndRefreshing];
                           }];
}

- (void)footerReresh
{
    __weak MyTendencyViewController *_self = self;
    [self show];
    [self.netWorkManager myDynamic:[RRTManager manager].loginManager.loginInfo.userId
                            typeId:0
                         PageIndex:self.pageIndex
                          PageSize:self.pageSize
                           success:^(NSMutableArray *MyDynamic) {
                               [_self dismiss];
                               [self updateView:MyDynamic];
                               [_self.mainTableView footerEndRefreshing];
                           } failed:^(NSString *errorMSG) {
                               [_self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                               [_self.mainTableView footerEndRefreshing];
                           }];
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
    NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

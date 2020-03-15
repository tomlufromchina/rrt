//
//  FriendTendencyViewController.m
//  RenrenTong
//
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "FriendTendencyViewController.h"
#import "FaceBoard.h"
#import "MJRefresh.h"

enum FTVC_VIEW_TAG {
    starttag=200,//tag值较小的，如0-100为苹果保留使用,故开始值为200，该值不使用
    userfaceimageviewtag,
    message_notice_btn_tag,
    message_notice_lable_tag,
    user_menu_weibo_lab,
    user_menu_rec_lab,
    user_menu_photo_lab
};

@interface FriendTendencyViewController ()<UIActionSheetDelegate,
                                            UITableViewDataSource,
                                            UITableViewDelegate,
                                            MLEmojiLabelDelegate,
                                            WeiboListDelegate,
                                            InputViewDelegate,
                                            UITextFieldDelegate,
                                            FriendTendencyCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *typeId;

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;


@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) UILabel *countlable;
@property(nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) FaceBoard *faceBoard;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray* emjoalablearray;//放动态内容
@property (nonatomic, strong) NSMutableArray* commentlablearray;//放评论内容

//临时变量
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复评论1，还是回复某个人0
@property (nonatomic, strong) FriendDynamicDetail *friendDynamicDetail;
@property (nonatomic, assign) int activityIndex;
@property (nonatomic, assign) int commentIndex;

@end

@implementation FriendTendencyViewController

#pragma mark - viewController lifecycle
#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    
    [self viewDidLoadInit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerReresh)];
    
}

-(void)viewDidLoadInit{
    [self setTitle:@"好友动态"];
    
    self.pageIndex = 1;
    self.pageSize = 10;
    
    //right button
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [rightButton setImage:[UIImage imageNamed:@"normaltitle_plus"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addActions)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityHeaderCell" bundle:nil]
             forCellReuseIdentifier:@"ActivityHeaderCell"];
    
    
//    [self initTableViewHeader];

    self.emjoalablearray = [[NSMutableArray alloc] init];
    self.commentlablearray = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    
    self.netWorkManager = [[NetWorkManager alloc] init];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:appColor];
    
//    self.maintableview.frame = self.view.frame;
    
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
    
//    rect = self.inputView.frame;
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
    
    
    //加载数据
    [self loadData];
}

-(void)setMessageWithCount:(int)msgcount{
    UIButton* messagebtn=(UIButton*)[self.view viewWithTag:message_notice_btn_tag];
    if (msgcount>0) {
        UILabel* messagenoticelable=(UILabel*)[self.view viewWithTag:message_notice_lable_tag];
        messagenoticelable.text=[NSString stringWithFormat:@"%d条消息", msgcount];
        [messagebtn setHidden:NO];
    }else{
        [messagebtn setHidden:YES];
    }
}




#pragma mark - ActionClick
#pragma mark -
- (void)addActions
{
    UICustomActionSheet *actionSheet = [[UICustomActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"写日志",
                                        @"发微博", @"传照片", nil];
    
    for (int i = 0 ; i <= 3; i++) {
        [actionSheet setFont:[UIFont systemFontOfSize:14.0f] forButtonAtIndex:i];
        [actionSheet setColor:appColor forButtonAtIndex:i];
        [actionSheet setTextColor:[UIColor whiteColor] forButtonAtIndex:i];
    }
    [actionSheet setImage:[UIImage imageNamed:@"dynamic_diary.png"] forButtonAtIndex:0];
    [actionSheet setImage:[UIImage imageNamed:@"dynamic_wb.png"] forButtonAtIndex:1];
    [actionSheet setImage:[UIImage imageNamed:@"dynamic_pic.png"] forButtonAtIndex:2];
    
    [actionSheet showInView:self.view];
}


-(void)messageDeatil{
    [self.navigationController pushViewController:MessageListVCID
                                   withStoryBoard:ActivityStoryBoardName
                                        withBlock:nil];
    
    [self setMessageWithCount:0];
}

-(void)weiboDeatil{
    
    WeiboListingViewController *vc = [[WeiboListingViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    vc.delegate = self;
    [self.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//代理方法:（不用了）
- (void)backWeiBoCount:(int)weiboCount
{
    NSNumber *number = [NSNumber numberWithInt:weiboCount];
    self.countlable.text = [NSString stringWithFormat:@"%@",number];
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


#pragma mark - ActionSheetDelegate
#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            __weak FriendTendencyViewController *_self = self;
            CommonSuccessBlock block = ^(void){
                [_self headerReresh];
            };
            
            [self.navigationController pushViewController:SendRecordVCID
                                           withStoryBoard:ActivityStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                SendRecordViewController *vc = (SendRecordViewController*)viewController;
                vc.block = block;
            }];
        }
            break;
        case 1:
        {
            __weak FriendTendencyViewController *_self = self;
            CommonSuccessBlock block = ^(void){
                [_self headerReresh];
            };
            
            [self.navigationController pushViewController:SendWeiboVCID
                                           withStoryBoard:ActivityStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                SendWeiboViewController *vc = (SendWeiboViewController*)viewController;
                vc.block = block;
            }];
        }
            break;
        case 2:
        {
            __weak FriendTendencyViewController *_self = self;
            CommonSuccessBlock block = ^(void){
                [_self headerReresh];
            };
            
            [self.navigationController pushViewController:SendPicVCID
                                           withStoryBoard:ActivityStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                SendPicViewController *vc = (SendPicViewController*)viewController;
                vc.block = block;
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableViewDataSoure And Delegate
#pragma mark -
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
    } else {
        CGFloat height = 45;
        //动态内容高度
        height += ((MLEmojiLabel*)[_emjoalablearray objectAtIndex:indexPath.row]).height;
        FriendDynamicDetail* fr = (FriendDynamicDetail*)[self.dataSource objectAtIndex:indexPath.row];
        if (fr.hasImage && fr.Photos && fr.applicationid != 1002) {
            int s = (int)[fr.Photos count] / 3;
            int y = (int)[fr.Photos count] % 3;
            if (y>0) {
                s+=1;
            }
            height += s*80 + 10;
        }
        if (fr.applicationid == 1002) {
            //查看全文高度
            float readMoreHeight = 15;
            height += readMoreHeight + 10;
            
            UIFont *font = [UIFont systemFontOfSize:13];
            //设置一个行高上限
            CGSize size = CGSizeMake(230 ,20000);
            //标题高度
            CGFloat labelheight=[fr.Subject boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
            
            height += labelheight + 33;
        }
        //时间高度
        float timerheight = 26;
        height += timerheight;
        //赞、评论高度
        if (fr.Total > 0){
            height += 50;
        }else{
            height += 5;
        }
        if ([fr.Comments count] > 0) {
            height += ((MLEmojiLabel*)[_commentlablearray objectAtIndex:indexPath.row]).height+20;
        }
        if (fr.Total > 0 || [fr.Comments count] > 0) {
            height += 10;
        }
        //底部预留10个像素高度
        height += 10;
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"ActivityHeaderCell";
        ActivityHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//没有点击效果
        
        [cell.avatarImgView setImageURLStr:[RRTManager manager].loginManager.loginInfo.userAvatar
                               placeholder:[UIImage imageNamed:@"default.png"]];
        
        [cell.countView setHidden:YES];

        return cell;
    } else {
        static NSString *cellIdentifier = @"FriendTendencyCell";
        //自定义cell类
        FriendTendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTendencyCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;//代理
    
        FriendDynamicDetail* fr = self.dataSource[indexPath.row];
        
        cell.dynamicDetail = fr;
        
        [cell.userface setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.aedu.cn/avatars/%d.jpg", fr.userId]]];
        [cell.userface.layer setMasksToBounds:YES];
        cell.userface.layer.cornerRadius = 2.0;
        cell.userface.layer.cornerRadius = 2.0;
        cell.userface.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
        cell.userface.height = 35;
        cell.username.text = fr.OwnerName;
        cell.username.textColor = appColor;
        cell.subject.frame = CGRectMake(cell.username.left, cell.userface.bottom, 230, 0);
        cell.timer.text = fr.DateCreatedStr;
        cell.timer.left = cell.username.left;
        if (fr.applicationid == 1002) {
            cell.subject.text = fr.Subject;
            CGSize size = CGSizeMake(230,2000);
            CGFloat labelheight = [fr.Subject boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.subject.font} context:nil].size.height;
            cell.subject.frame = CGRectMake(cell.username.left, cell.userface.bottom, 230, labelheight);
        }
        cell.content = [_emjoalablearray objectAtIndex:indexPath.row];
        if (fr.applicationid == 1002) {
            [cell.morebtn setHidden:NO];
            cell.content.top = cell.subject.bottom+10;
            cell.morebtn.top = cell.content.bottom+10;
            cell.morebtn.tag = [fr.ThreadId intValue];
            [cell.morebtn addTarget:self action:@selector(threadIdDetail:) forControlEvents:UIControlEventTouchUpInside];
            cell.timer.top = cell.morebtn.bottom+10;
        }else{
            [cell.morebtn setHidden:YES];
            cell.content.top = cell.subject.bottom;
            cell.timer.top = cell.content.bottom+10;
        }
        cell.content.left = cell.username.left;
        [cell addSubview:[_emjoalablearray objectAtIndex:indexPath.row]];
        if (fr.hasImage&&fr.applicationid != 1002) {
            [self loadPhoto:cell fr:fr];
        }
        cell.prieseshowbtn.top = cell.timer.top - 5;
        cell.prieseshowbtn.tag = 0;
        cell.prieseview.top = cell.timer.top;
        cell.prieseview.clipsToBounds=YES;
        cell.prieseview.frame = CGRectMake(cell.prieseshowbtn.left, cell.prieseshowbtn.top, 0, 30);
        cell.commentview.top = cell.timer.bottom+10;
        if (fr.Total <= 0 && [fr.Comments count] <= 0) {
            cell.commentview.hidden = YES;
        }else{
            cell.commentview.hidden = NO;
            if (fr.Total>0) {
                cell.commentview.height = 50;
                cell.prieseviewdetail.frame = CGRectMake(5, 15, 220, 25);
                cell.prieseviewdetail.hidden = NO;
                cell.prieselable.text=[NSString stringWithFormat:@"%@等%d人赞", fr.Detail,fr.Total];
                cell.prieselable.textColor = appColor;
            }else{
                cell.prieseviewdetail.frame = CGRectMake(5, 5, 220, 0);
                cell.prieseviewdetail.hidden = YES;
            }
            
            if ([fr.Comments count]>0) {
                MLEmojiLabel* commentlable=[_commentlablearray objectAtIndex:indexPath.row];
                commentlable.top=cell.prieseviewdetail.bottom+10;
                commentlable.left=5;
                [cell.commentview addSubview:commentlable];
                cell.commentview.height=commentlable.bottom+10;
                if (fr.Total>0) {
                    cell.prieseviewdetail.frame=CGRectMake(5, 15, 220, 25);
                    cell.prieseviewdetail.hidden=NO;
                }else{
                    cell.prieseviewdetail.frame=CGRectMake(5, 5, 220, 0);
                    cell.prieseviewdetail.hidden=YES;
                }
            }
        }
        return cell;
    }
}




//日志查看全文
-(void)threadIdDetail:(UIButton*)sender{
    NSLog(@"日志id：%d", sender.tag);
    RecordDetailsController *VC = [[RecordDetailsController alloc] init];
    VC.rid=[NSString stringWithFormat:@"%d",sender.tag];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    __block FriendTendencyViewController *_self = self;
    CommonSuccessBlock block = ^(void){
        [_self headerReresh];
    };
    
    VC.block = block;

    
    
    [self.navigationController pushViewController:VC animated:YES];
}
//计算图片高度
-(void)loadPhoto:(FriendTendencyCell *)cell fr:(FriendDynamicDetail*)fr{
    if ([fr.Photos count]>0) {
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        cell.photoview=[[UIView alloc] init];
        CGFloat width = 70;
        CGFloat height = 70;
        CGFloat margin=10;
        for (int i=0; i<[fr.Photos count]; i++) {
            NSDictionary *photo=fr.Photos[i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [cell.photoview addSubview:imageView];
            
            // 计算位置
            int row = i/3;
            int column = i%3;
            CGFloat x =  column * (width + margin);
            CGFloat y =  row * (height + margin);
            imageView.frame = CGRectMake(x, y, width, height);
            NSString* urlstr;
            switch (fr.applicationid) {
                case 1001://微博
                    urlstr=[photo objectForKey:@"FileName"];
                    break;
                case 1002://日志
                    urlstr=[photo objectForKey:@"FileName"];
                    break;
                case 1003://相册
                    urlstr=[photo objectForKey:@"RelativePath"];
                    break;
                default:
                    urlstr=[photo objectForKey:@"FileName"];
                    break;
            }
            
            // 下载图片
            [imageView setImageURLStr:urlstr placeholder:placeholder];
            
            // 事件监听
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            
            //重写手势满足需求
            PhotoUITapGestureRecognizer *tap=[[PhotoUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            tap.fr=fr;
            tap.img=imageView;
            [imageView addGestureRecognizer:tap];
            
            // 内容模式
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        float vheight=0;
        int s=(int)[fr.Photos count]/3;
        int y=(int)[fr.Photos count]%3;
        if (y>0) {
            s+=1;
        }
        vheight=s*80;
        [cell.photoview setFrame:CGRectMake(cell.username.left, cell.content.bottom+10, 230, vheight)];
        cell.timer.top=cell.photoview.bottom+10;
        [cell addSubview:cell.photoview];
    }
}

- (void)tapImage:(PhotoUITapGestureRecognizer *)tap
{
    NSUInteger count = [tap.fr.Photos count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i <   count; i++) {
        // 替换为中等尺寸图片
        
        NSString* url;
        switch (tap.fr.applicationid) {
            case 1001://微博
                url = [tap.fr.Photos[i] objectForKey:@"FileName"];
                break;
            case 1002://日志
                url = [tap.fr.Photos[i] objectForKey:@"FileName"];
                break;
            case 1003://相册
                url = [tap.fr.Photos[i] objectForKey:@"RelativePath"];
                break;
            default:
                url = [tap.fr.Photos[i] objectForKey:@"FileName"];
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

#pragma mark loadData
/****好友动态请求****/
-(void)loadData{
        [self showWithStatus:@""];
        [self.netWorkManager friendsDynamicDetail:[RRTManager manager].loginManager.loginInfo.userId
                                        pageIndex:self.pageIndex
                                         pageSize:self.pageSize
                                          success:^(NSMutableArray *friendDynamic) {
            [self dismiss];
            [self updateView:friendDynamic];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];

}

- (void)updateView:(NSMutableArray *)data
{
    if (data) {
        for (int i=0; i<[data count]; i++) {
            FriendDynamicDetail *obj=[data objectAtIndex:i];
            switch (obj.applicationid) {
                case 1001://微博
                    obj.Body=[self flattenHTML:obj.Body];
                    [_emjoalablearray addObject:[self createLableWithText:obj.Body font:[UIFont systemFontOfSize:15] width:230]];
                    break;
                case 1002://日志
                    obj.Subject=[self flattenHTML:obj.Subject];
                    obj.Subject=[NSString stringWithFormat:@"%@ 发表了日志《%@》", obj.Author,obj.Subject];
                    obj.Body=[self flattenHTML:obj.Body];
                    if (obj.Body.length>140) {
                        obj.Body=[NSString stringWithFormat:@"%@……",[obj.Body substringWithRange:NSMakeRange(0,140)]];
                    }
                    [_emjoalablearray addObject:[self createLableWithText:obj.Body font:[UIFont systemFontOfSize:15] width:230]];
                    break;
                case 1003://相册
                    obj.dynNew=[self flattenHTML:obj.dynNew];
                    [_emjoalablearray addObject:[self createLableWithText:obj.dynNew font:[UIFont systemFontOfSize:15] width:230]];
                    break;
            }
            //评论
            if ([obj.Comments count]>0) {
                NSString* comment=@"";
                
                for (int j = 0; j < [obj.Comments count]; j ++) {
                    DynamicComments *dic = [obj.Comments objectAtIndex:j];
                    NSString* br=@"";
                    //换行
                    if (j < [obj.Comments count] - 1) {
                        br=@"\n";
                    }
                    //通过AtUserId判断评论还是回复
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
        [self.tableView reloadData];
    }
}
#pragma mark - 过滤文字方法
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
        result = [result stringByReplacingOccurrencesOfString:@"&#215;" withString:@""];
        
    }
    return result;
}

#pragma mark emjolable

- (MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
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

#pragma mark - FriendTendencyCell Delegate
#pragma mark -
// 评论
- (void)commentCellClicked:(FriendDynamicDetail*)friendDynamicDetail;
{
    self.bReplyToComment = YES;
    
    self.friendDynamicDetail = friendDynamicDetail;

    [self.inputView.textField becomeFirstResponder];
    self.inputView.textField.placeholder = @"说点什么吧...";
}
// 赞
- (void)praiseCellClicked: (FriendDynamicDetail*)friendDynamicDetail
{
    self.friendDynamicDetail = friendDynamicDetail;
    
    if ((self.friendDynamicDetail.applicationid) == 1001) {
        self.typeId = @"2";//微博
    }else if ((self.friendDynamicDetail.applicationid) == 1002){
        self.typeId = @"1";//日志
    }else {
        self.typeId = @"0";//相册动态
    }
    
    __weak FriendTendencyViewController *_self = self;
    [self.netWorkManager clickPraise:[RRTManager manager].loginManager.loginInfo.tokenId
                            ObjectId:[NSString stringWithFormat:@"%d",self.friendDynamicDetail.sourceId]
                        ObjectTypeId:self.typeId
                              UserId:[RRTManager manager].loginManager.loginInfo.userId
                            UserName:[RRTManager manager].loginManager.loginInfo.userName
                             success:^(NSDictionary *data) {
                                 [self dismiss];
                                 [_self headerReresh];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
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

- (void)showFaceBoard:(BOOL)bShow
{
//    if (bShow) {
//        [self.faceBoard setHidden:NO];
//        CGRect rect = self.faceBoard.frame;
//        CGFloat ty = - rect.size.height;
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             self.tableView.transform = CGAffineTransformMakeTranslation(0, ty);
//                             self.toolView.transform = CGAffineTransformMakeTranslation(0, ty);
//                             self.faceBoard.transform = CGAffineTransformMakeTranslation(0, ty);
//                         }];
//    } else {
//        [self.faceBoard setHidden:YES];
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             self.tableView.transform = CGAffineTransformIdentity;
//                             self.toolView.transform = CGAffineTransformIdentity;
//                             self.faceBoard.transform = CGAffineTransformIdentity;
//                         }];
//    }
}

#pragma mark - UIScrollView delegate
#pragma mark -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self showFaceBoard:NO];
    [self.inputView setHidden:YES];
}

#pragma mark - UITextField delegate
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak FriendTendencyViewController *_self = self;
    if (self.bReplyToComment) {
        // 评论
        FriendDynamicDetail *fr = self.friendDynamicDetail;
        if ((fr.applicationid) == 1001) {
            self.typeId = @"1";//微博
        }else if ((fr.applicationid) == 1002){
            self.typeId = @"2";//日志
        }else {
            // 相册评论
            [self.netWorkManager albumComment:[RRTManager manager].loginManager.loginInfo.tokenId
                            CommentedObjectId:[NSString stringWithFormat:@"%d",fr.ActivityId]
                                      OwnerId:[NSString stringWithFormat:@"%d",fr.ownerid]
                                       UserId:[RRTManager manager].loginManager.loginInfo.userId
                                       Author:[RRTManager manager].loginManager.loginInfo.userName
                                      subject:@"123"
                                         body:self.inputView.textField.text
                                      success:^(NSDictionary *data) {
                [self dismiss];
                [_self headerReresh];//重新刷新界面
            } failed:^(NSString *errorMSG) {
                [self showErrorWithStatus:errorMSG];
            }];
            
            [self.inputView.textField resignFirstResponder];
            return YES;
        }
        
        // 日志微博评论
        [self.netWorkManager clickComment:[NSString stringWithFormat:@"%d",fr.sourceId]
                                   UserId:[RRTManager manager].loginManager.loginInfo.userId
                                     Body:self.inputView.textField.text
                                   TypeId:self.typeId
                                  success:^(NSDictionary *data) {
                                      [self dismiss];
                                      [_self headerReresh];//重新刷新界面
            
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
       // 回复
    } else {
        FriendDynamicDetail *detail = [self.dataSource objectAtIndex:self.activityIndex];
        DynamicComments *comment = [detail.Comments objectAtIndex:self.commentIndex];
        NSString *type = @"";
        if (detail.applicationid == 1001) {
            type = @"1";//微博
        } else if (detail.applicationid == 1002) {
            type = @"2";//日志
        } else {
            // 相册回复
            [self.netWorkManager albumReply:[RRTManager manager].loginManager.loginInfo.tokenId
                          CommentedObjectId:[NSString stringWithFormat:@"%d",detail.ActivityId]
                                    OwnerId:[NSString stringWithFormat:@"%d",detail.ownerid]
                                     UserId:[RRTManager manager].loginManager.loginInfo.userId
                                     Author:[RRTManager manager].loginManager.loginInfo.userName
                                    subject:@"123"
                                       body:self.inputView.textField.text
                                   ToUserId:[NSString stringWithFormat:@"%d", comment.UserId]
                                 ToUserName:comment.Author
                                    success:^(NSDictionary *data) {
                                        [self dismiss];
                                        [_self headerReresh];//重新刷新界面
                                    } failed:^(NSString *errorMSG) {
                                        [self showErrorWithStatus:errorMSG];
                                    }];
            
            [self.inputView.textField resignFirstResponder];
            return YES;

        }
        
        __weak FriendTendencyViewController *_self = self;
        // 日志微博回复
        [self.netWorkManager clickReply:[NSString stringWithFormat:@"%d", detail.sourceId]
                                 UserId:[RRTManager manager].loginManager.loginInfo.userId
                                   Body:self.inputView.textField.text
                                 TypeId:type
                               ParentId:[NSString stringWithFormat:@"%d", comment.Id]
                                success:^(NSDictionary *data) {
                                    [self dismiss];
                                    [_self headerReresh];//重新刷新界面
                                } failed:^(NSString *errorMSG) {
                                    [self showErrorWithStatus:errorMSG];
                                }];
    }

    [self.inputView.textField resignFirstResponder];
    return YES;
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __weak FriendTendencyViewController *_self = self;
    [self.netWorkManager friendsDynamicDetail:[RRTManager manager].loginManager.loginInfo.userId
                                    pageIndex:1
                                     pageSize:self.pageSize
                                      success:^(NSMutableArray *friendDynamic) {
                                          [_self.dataSource removeAllObjects];
                                          [_self.emjoalablearray removeAllObjects];
                                          [_self.commentlablearray removeAllObjects];
                                          _self.pageIndex = 1;
                                          [self updateView:friendDynamic];
                                          
                                          [_self.tableView headerEndRefreshing];
                                      } failed:^(NSString *errorMSG) {
                                          [self showWithTitle:errorMSG withTime:1.5f];
                                          
                                          [_self.tableView headerEndRefreshing];
                                      }];
}

- (void)footerReresh
{
    __weak FriendTendencyViewController *_self = self;

    [self.netWorkManager friendsDynamicDetail:[RRTManager manager].loginManager.loginInfo.userId
                                    pageIndex:self.pageIndex + self.pageSize
                                     pageSize:self.pageSize
                                      success:^(NSMutableArray *friendDynamic) {
                                          _self.pageIndex += _self.pageSize;
                                          
                                          if ([friendDynamic count] == 0) {
                                              [self showWithTitle:@"没有更多的好友动态了哦！" defaultStr:nil];
                                          }
                                          [self updateView:friendDynamic];
                                          
                                          [_self.tableView footerEndRefreshing];
                                      } failed:^(NSString *errorMSG) {
                                          [self showWithTitle:errorMSG withTime:1.5f];
                                          [_self.tableView footerEndRefreshing];
                                      }];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
    [self showFaceBoard:NO];
    [self.inputView setHidden:YES];
}

@end

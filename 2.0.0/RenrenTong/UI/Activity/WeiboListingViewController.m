//
//  WeiboListingViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "WeiboListingViewController.h"
#import "WeiboDetailsViewController.h"
#import "ViewControllerIdentifier.h"
#import "MJRefresh.h"

@interface WeiboListingViewController ()
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, assign) int pageIndex;

@end

@implementation WeiboListingViewController

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
    self.pageIndex = 1;
    emjoalablearray=[[NSMutableArray alloc] init];
    _netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
//    self.mainTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.mainTableView setBackgroundColor:[UIColor clearColor]];
    [self.mainTableView setSeparatorColor:appColor];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    
    [self requestData];
    self.title = @"微博";
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

- (void)requestData
{
    [self showWithStatus:@"正在加载数据..."];
    [self.netWorkManager weiboList:[RRTManager manager].loginManager.loginInfo.userId PageIndex:1 success:^(NSArray *micList) {
        [self dismiss];
        self.pageIndex = self.pageIndex +1;
        [self updateUI:micList];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
}

- (void)updateUI:(NSArray *)data
{
    NSLog(@"%d",[data count]);
    if (data) {
        for (int i=0; i<[data count]; i++) {
            WeiboList *obj=[data objectAtIndex:i];
            obj.body = [self flattenHTML:obj.body];//取出微博内容
            //将遍历的微博内容放进数组中，数组里面的元素的 MLEmojiLabel 对象
            [emjoalablearray addObject:[self createLableWithText:obj.body font:[UIFont systemFontOfSize:13] width:230]];
            [self.dataSource addObject:obj];
        }
        [self.mainTableView reloadData];
    }else{
        [self showErrorWithStatus:@"加载失败"];
    }
}

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
            NSLog(@"点击了用户:%@",link);
            NSLog(@"用户id为:%d",[MLEmojiLabel getUserid:link]);
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

#pragma mark  TableViewDataSoureAndDelegate
#pragma --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0;
    height+=55;
    WeiboList* wl=(WeiboList*)[self.dataSource objectAtIndex:indexPath.row];
    MLEmojiLabel* emjolable=(MLEmojiLabel*)[emjoalablearray objectAtIndex:indexPath.row];
    height+=emjolable.height;//标题的高度
    height += 25;//评论View的高度
    if (wl.ImagesUrl!=nil&&[wl.ImagesUrl count]>0) {
        int s=(int)[wl.ImagesUrl count]/3;
        int y=(int)[wl.ImagesUrl count]%3;
        if (y>0) {
            s+=1;
        }
        float tempheight=s*80;
        height+=tempheight+10;
    }
    height+=20;
    return height+10;//底部留20像素
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"WeiboListCell";
    //自定义cell类
    WeiboListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//小箭头
    }
    WeiboList* WB=self.dataSource[indexPath.row];
    [cell.userface.layer setMasksToBounds:YES];
    cell.userface.layer.cornerRadius = 2.0;
    cell.userface.layer.cornerRadius = 2.0;
    cell.userface.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
    cell.username.textColor=appColor;
    [cell.userface setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.aedu.cn/avatars/%@.jpg", [RRTManager manager].loginManager.loginInfo.userId]]];
    cell.userface.top=20;
    cell.userface.left=20;
    cell.username.top=cell.userface.top;
    cell.username.text = WB.UserName;
    [cell.content removeFromSuperview];//防止重用
    cell.content=nil;
    cell.content = [emjoalablearray objectAtIndex:indexPath.row];
    cell.content.top=cell.userface.bottom;
    cell.content.left=cell.username.left;
    [cell addSubview:cell.content];
    //初始化放图片的View
    cell.potoview.height=0; //存放图片的View
    if (WB.ImagesUrl!=nil&&[WB.ImagesUrl count]>0) {
        cell.potoview.top=cell.content.bottom+10;
        [self loadPhoto:cell fr:WB];
        
    }else{
        cell.potoview.top=cell.content.bottom;
    }
    cell.timer.top=cell.potoview.bottom+10;
    cell.timer.left=cell.content.left;
    cell.timer.text = WB.DateTime;
    cell.praiseView.top = cell.timer.bottom + 10;
    cell.discuss.top = cell.timer.bottom + 10;
    cell.praiseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.discuss.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.praiseView.layer.cornerRadius = 2.0f;
    cell.discuss.layer.cornerRadius = 2.0f;
    cell.praiseLabel.text = [NSString stringWithFormat:@"%@(%d)",@"赞",WB.FavoriteCount];
    cell.discussLabel.text = [NSString stringWithFormat:@"%@(%d)",@"评论",WB.CommentCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeiboDetailsViewController *vc = [[WeiboDetailsViewController alloc] init];
    WeiboList *WL = [self.dataSource objectAtIndex:indexPath.row];
    vc.weiboID = [NSString stringWithFormat:@"%d",WL.MicroblogId];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

-(void)loadPhoto:(WeiboListCell *)cell fr:(WeiboList*)fr{
    if ([fr.ImagesUrl count]>0) {
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        //图片的宽高
        CGFloat width = 70;
        CGFloat height = 70;
        CGFloat margin=10;//每张图片的间距
        for (int i=0; i<[fr.ImagesUrl count]; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [cell.potoview addSubview:imageView];
            
            // 计算位置：每行三张图片
            int row = i/3; //行
            int column = i%3; //列
            CGFloat x =  column * (width + margin);
            CGFloat y =  row * (height + margin);
            imageView.frame = CGRectMake(x, y, width, height);
            NSString* urlstr=[fr.ImagesUrl objectAtIndex:i];
            
            // 下载图片
            [imageView setImageURLStr:urlstr placeholder:placeholder];
            
            // 事件监听
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            //重写手势：PhotoUITapGestureRecognizer
            PhotoUITapGestureRecognizer *tap=[[PhotoUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            tap.wl=fr;
            tap.img=imageView;
            [imageView addGestureRecognizer:tap];
            
            // 内容模式
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        float vheight=0;
        int s=(int)[fr.ImagesUrl count]/3;
        int y=(int)[fr.ImagesUrl count] % 3;
        if (y>0) {
            s+=1;
        }
        vheight=s*80;
        //重新设置potoview高度：
        [cell.potoview setFrame:CGRectMake(cell.username.left, cell.content.bottom+10, 237, vheight)];
    }
}

- (void)tapImage:(PhotoUITapGestureRecognizer *)tap
{
    NSUInteger count = [tap.wl.ImagesUrl count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        
        NSString* url=[tap.wl.ImagesUrl objectAtIndex:i];
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


- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
    [self.delegate backWeiBoCount:self.dataSource.count];//不用了
    
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __block WeiboListingViewController *_self = self;
    [self showWithStatus:@""];
    [self.netWorkManager weiboList:[RRTManager manager].loginManager.loginInfo.userId
                         PageIndex:1
                           success:^(NSArray *micList) {
        [self dismiss];
        [_self.dataSource removeAllObjects];
        [_self updateUI:micList];
        [_self.mainTableView headerEndRefreshing];
    } failed:^(NSString *errorMSG) {
        [_self.mainTableView headerEndRefreshing];
    }];
}

- (void)footerReresh
{
    __block WeiboListingViewController *_self = self;
    [self showWithStatus:@""];
    [self.netWorkManager weiboList:[RRTManager manager].loginManager.loginInfo.userId
                         PageIndex:_self.pageIndex
                           success:^(NSArray *micList) {
        [self dismiss];
        _self.pageIndex = _self.pageIndex +1;
        [self updateUI:micList];
        [_self.mainTableView footerEndRefreshing];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
        [_self.mainTableView footerEndRefreshing];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

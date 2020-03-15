//
//  PersonageDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "PersonageDetailsViewController.h"
#import "MyTendencyViewController.h"
#import "NewActivityCell.h"

@interface PersonageDetailsViewController ()<UITableViewDelegate, UITableViewDataSource,MLEmojiLabelDelegate>

{
    MyselfDetails *dataDetails;
    NewActivity *newActivity;
    
}
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray* emjoalablearray;

@end

@implementation PersonageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";

    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    
    self.emjoalablearray = [[NSMutableArray alloc] init];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑资料"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickEditionButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestData]; 
    
}

- (void)clickEditionButton
{
    [self.navigationController pushViewController:ModificationVCID
                                   withStoryBoard:SettingStoryBoardName
                                        withBlock:nil];
}

#pragma mark -- 数据解析
#pragma mark -- 

- (void)requestData
{
    [self show];
    [self.netWorkManager myselfDetails:[RRTManager manager].loginManager.loginInfo.tokenId
                                UserId:[RRTManager manager].loginManager.loginInfo.userId
                               success:^(MyselfDetails *myselfDict) {
                                   [self dismiss];
                                   [self gotoUpdataUI:myselfDict];
                               } failed:^(NSString *errorMSG) {
                                   [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                   
                               }];
    // 最新动态
    [self.netWorkManager getMyselfActivityDetails:[RRTManager manager].loginManager.loginInfo.userId
                                           typeId:0
                                        pageindex:1
                                         pagesize:10
                                          success:^(NSMutableArray *myselfDict) {
                                              [self dismiss];
                                              [self updateUI:myselfDict];
                                              
                                          } failed:^(NSString *errorMSG) {
                                              [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                          }];
}

#pragma mark -- 最新动态界面刷新

- (void)updateUI:(NSMutableArray *)array
{
    if (array) {
        newActivity = array[0];// 最新的一条动态
        switch (newActivity.TypeId) {
            case 1:// 微博
                newActivity.Body = [self flattenHTML:newActivity.Body];
                [self.emjoalablearray addObject:[self createLableWithText:newActivity.Body font:[UIFont systemFontOfSize:15] width:SCREENWIDTH - 40]];
                
                break;
            case 2:// 日志
                newActivity.Title = [self flattenHTML:newActivity.Title];
                newActivity.Body = [self flattenHTML:newActivity.Body];
                
                [_emjoalablearray addObject:[self createLableWithText:newActivity.Body font:[UIFont systemFontOfSize:15] width:SCREENWIDTH - 40]];
                
                break;
            case 3:// 相册
                newActivity.Body = [self flattenHTML:newActivity.Body];
                [self.emjoalablearray addObject:[self createLableWithText:newActivity.Body font:[UIFont systemFontOfSize:15] width:SCREENWIDTH - 40]];
                
                break;
            default:
                break;
        }
        [self.mainTableView reloadData];
    }
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

#pragma mark -- 刷新界面
#pragma mark --

- (void)gotoUpdataUI:(MyselfDetails *)ND
{
    self.dataSource = [NSArray arrayWithObject:ND];
    dataDetails = [self.dataSource objectAtIndex:0];
    [self.mainTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else if(section == 1){
        return 20;
    } else {
        return 20;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 4;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else if(section == 1){
        return @"个人资料";
    } else{
        return @"最新动态";
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height += 70;
        return height;
    } else if (indexPath.section == 1) {
        height += 40;
        return height;
    } else {
        if (self.emjoalablearray && [self.emjoalablearray count] >0) {
            height += 35;
            // 相册
            if (newActivity.TypeId == 3 && newActivity.ImagesUrlArray && [newActivity.ImagesUrlArray count] >0) {
                int s = (int)[newActivity.ImagesUrlArray count] / 3;
                int y = (int)[newActivity.ImagesUrlArray count] % 3;
                if (y>0) {
                    s += 1;
                }
                height += s*80 + 10;
                height += ((MLEmojiLabel *)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
            }
            // 日志
            if (newActivity.TypeId == 2) {
                UIFont *font = [UIFont systemFontOfSize:15];
                //设置一个行高上限
                CGSize size = CGSizeMake(230 ,2000);
                
                CGFloat labelheight = [newActivity.Title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
                height += labelheight;
                
                height += ((MLEmojiLabel *)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
                
            }
            // 微博
            if (newActivity.TypeId == 1)
            {
               // 不带图片
                if ([newActivity.ImagesUrlArray count] == 0) {
                    height += ((MLEmojiLabel *)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
              // 带图片
                } else {
                    int s = (int)[newActivity.ImagesUrlArray count] / 3;
                    int y = (int)[newActivity.ImagesUrlArray count] % 3;
                    if (y>0) {
                        s += 1;
                    }
                    height += s*80 + 10;
                    
                    height += ((MLEmojiLabel *)[self.emjoalablearray objectAtIndex:indexPath.row]).height;
                }
                
            }
            
        }
        height += 10;
        return height;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonageDetailsHeaderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Login *login = [RRTManager manager].loginManager.loginInfo;
        
        UIImageView *avatarImgView = (UIImageView*)[cell viewWithTag:1];
        
        [avatarImgView.layer setMasksToBounds:YES];
        avatarImgView.layer.cornerRadius = 2.0;
        avatarImgView.layer.cornerRadius = 2.0;
        avatarImgView.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
        avatarImgView.layer.cornerRadius = 10;
        
        UILabel *nameLabel =(UILabel*)[cell viewWithTag:2];
        UIView *rankView = (UIView *)[cell viewWithTag:3];
        rankView.layer.cornerRadius = 5;
        UILabel *rankLabel = (UILabel *)[cell viewWithTag:4];
        rankLabel.text = [NSString stringWithFormat:@"Lv %d",dataDetails.Rank];
        
        NSString *avatarUrl = [NSString stringWithFormat:@"%@%@%@?lq=123456",appHeadImage,[RRTManager manager].loginManager.loginInfo.userId,@".jpg"];
        [avatarImgView setImageWithUrlStr:avatarUrl placholderImage:[UIImage imageNamed:@"default"]];
        
        nameLabel.text = login.userName;
        
        return cell;
        
    } else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonageDetailsCell" forIndexPath:indexPath];
        
        UILabel *label1 = (UILabel*)[cell viewWithTag:1];
        UILabel *label2 = (UILabel*)[cell viewWithTag:2];
        
        switch (indexPath.row) {
            case 0:
                label1.text = @"姓名:";
                label2.text = dataDetails.TrueName;
                
                break;
                
            case 1:
                label1.text = @"地区:";
                label2.text = dataDetails.NowAreaCode;
                
                break;
                
            case 2:
                label1.text = @"性别:";
                if (dataDetails.Sex == 0) {
                    label2.text = @"女";
                } else if (dataDetails.Sex == 1){
                    label2.text = @"男";
                }
                
                break;
                
            case 3:
                label1.text = @"简介:";
                label2.text = dataDetails.Introduction;
                
                break;
                
            default:
                break;
        }
        return cell;
    } else{
        static NSString *cellIdentifier = @"NewActivityCell";
        NewActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewActivityCell" owner:self options:nil] lastObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        // 微博
        if (newActivity.TypeId == 1) {
            if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
                // 不带图片
                if ([newActivity.ImagesUrlArray count] == 0) {
                    
                    cell.content = [_emjoalablearray objectAtIndex:indexPath.row];
                    cell.content.top = cell.subjectTitle.bottom ;
                    cell.content.left = cell.subjectTitle.left + 10;
                    [cell addSubview:[_emjoalablearray objectAtIndex:indexPath.row]];
                    cell.subjectTitle.text = @"发表了最新微博:";
                    cell.subjectTitle.textColor = appColor;
                // 带图片
                } else {
                    cell.subjectTitle.text = @"发表了最新微博:";
                    cell.subjectTitle.textColor = appColor;
                    cell.content = [_emjoalablearray objectAtIndex:indexPath.row];
                    cell.content.top = cell.subjectTitle.bottom ;
                    cell.content.left = cell.subjectTitle.left + 10;
                    
                    [self loadPhoto:cell NA:newActivity];
                }
            }
        }
        // 日志
        if (newActivity.TypeId == 2) {
            cell.subjectTitle.text = [NSString stringWithFormat:@"发表了最新日志:《%@》",newActivity.Title];
            cell.subjectTitle.textColor = appColor;
            CGSize size = CGSizeMake(230,2000);
            CGFloat labelheight = [newActivity.Title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.subjectTitle.font} context:nil].size.height;
            cell.subjectTitle.frame = CGRectMake(10, 10, 230, labelheight);
        }
        if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
            
            cell.content = [_emjoalablearray objectAtIndex:indexPath.row];
            cell.content.top = cell.subjectTitle.bottom + 10;
            cell.content.left = cell.subjectTitle.left + 10;
            [cell addSubview:[_emjoalablearray objectAtIndex:indexPath.row]];
            
        }
        // 相册
        if (newActivity.TypeId == 3 && [newActivity.ImagesUrlArray count] >0) {
            if (self.emjoalablearray && [self.emjoalablearray count] > 0) {
                cell.subjectTitle.frame = CGRectMake(10, 10, 230, 20);
                cell.subjectTitle.text =@"更新了相关相册:";
                cell.subjectTitle.textColor = appColor;
                
                [self loadPhoto:cell NA:newActivity];

            }
        }
        return cell;
        
    }
}

#pragma mark -- 计算图片高度
- (void)loadPhoto:(NewActivityCell *)cell NA:(NewActivity*)NA
{
    if ([NA.ImagesUrlArray count] > 0) {
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        cell.photoview = [[UIView alloc] init];
        CGFloat width = 70;
        CGFloat height = 70;
        CGFloat margin = 10;
        for (int i = 0; i < [NA.ImagesUrlArray count]; i ++) {
            NSString *imageUrl = NA.ImagesUrlArray[i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [cell.photoview addSubview:imageView];
            
            // 计算位置
            int row = i/3;
            int column = i%3;
            CGFloat x =  column * (width + margin);
            CGFloat y =  row * (height + margin);
            imageView.frame = CGRectMake(x, y, width, height);
            NSString* urlstr;
            switch (newActivity.TypeId) {
                case 1:// 微博
                    urlstr = imageUrl;
                    
                    break;
                case 2:// 日志
                    urlstr = imageUrl;
                    
                    break;
                case 3:// 相册
                    urlstr = imageUrl;
                    
                    break;
                    
                default:
                    break;
            }
            
            // 下载图片
            [imageView setImageURLStr:urlstr placeholder:placeholder];
            // 事件监听
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            PhotoUITapGestureRecognizer *tap = [[PhotoUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            tap.NA = NA;
            tap.img = imageView;
            [imageView addGestureRecognizer:tap];
            // 内容模式
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        float vheight = 0;
        int s = (int)[NA.ImagesUrlArray count] / 3;
        int y = (int)[NA.ImagesUrlArray count] % 3;
        if (y > 0) {
            s += 1;
        }
        vheight = s*80;
        [cell.photoview setFrame:CGRectMake(cell.content.left + 20, cell.content.bottom+10, SCREENWIDTH - 40, vheight)];
        // 将图片添加到Cell上
        [cell addSubview:cell.photoview];
        
    }
}

- (void)tapImage:(PhotoUITapGestureRecognizer *)tap
{
    NSUInteger count = [tap.NA.ImagesUrlArray count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString* url;
        switch (tap.NA.TypeId) {
            case 1://微博
                url = tap.NA.ImagesUrlArray[i];
                break;
            case 2://日志
                url = tap.NA.ImagesUrlArray[i];
                break;
            case 3://相册
                url = tap.NA.ImagesUrlArray[i];
                break;
            default:
                url = tap.NA.ImagesUrlArray[i];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        MyTendencyViewController *VC = [[MyTendencyViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self dismiss];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
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

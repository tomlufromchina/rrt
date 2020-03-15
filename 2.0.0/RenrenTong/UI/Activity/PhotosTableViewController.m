//
//  PhotosTableViewController.m
//  RenrenTong
//
//  Created by 司月皓 on 14-7-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "PhotoDetailsController.h"
#import "UIImageView+WebCache.h"
#import "ViewControllerIdentifier.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MLEmojiLabel.h"

@interface PhotosTableViewController ()<MLEmojiLabelDelegate>
{
    UIView *_backView;
    NSMutableArray *_listArray;
    NSMutableArray *_recentArray;
    NSInteger index;//做为cell的标示
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *photoDataSource;
@property (nonatomic, strong) NSMutableArray *pictureDataSource;
@property (nonatomic, strong) MLEmojiLabel* emjolable;

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int column;
@property (nonatomic, assign) int row;

@end

@implementation PhotosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.photoDataSource = [[NSMutableArray alloc] init];
    self.pictureDataSource = [[NSMutableArray alloc] init];
    
    //上拉刷新和下拉加载更多
    [self setupRefresh];
    
    [self initView];
    [self Selectbutton:0];
    
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self enableRefresh:YES action:@selector(headerReresh)];
    [self enableLoadMore:YES action:@selector(footerReresh)];
}

- (void)initView
{
    self.pageIndex = 1;
    self.pageSize = 10;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 250, 44)];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar addSubview:_backView];
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f) ];
    segmentedControl.center = CGPointMake(250/2.0f, 22);
    [segmentedControl insertSegmentWithTitle:@"列表" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"最近" atIndex:1 animated:YES];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
    [_backView addSubview:segmentedControl];
        
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorColor:appColor];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    _backView.hidden = YES;
    [self dismiss];
}

- (void)viewWillAppear:(BOOL)animated{
    _backView.hidden = NO;
}

-(void)Selectbutton:(UISegmentedControl *)Segment
{
    index = Segment.selectedSegmentIndex;
    if (index == 0) {
        //列表
        [self showWithStatus:@""];
        [self.netWorkManager photoList:[RRTManager manager].loginManager.loginInfo.tokenId
                                UserId:[RRTManager manager].loginManager.loginInfo.userId
                              PageSize:10
                             PageIndex:1
                               success:^(NSArray *photoListArray) {
            [self dismiss];
            [self updateUI:photoListArray];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
    }else if (index == 1) {
        //最近
        [self showWithStatus:@""];
        [self.netWorkManager recentlyAblum:[RRTManager manager].loginManager.loginInfo.tokenId
                                 pageIndex:1
                                  pageSize:10
                                  TopCount:4
                                   success:^(NSArray *photoListArray) {
            [self dismiss];
            [self updateUI:photoListArray];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
    }
    [self.photoDataSource removeAllObjects];
    [self.pictureDataSource removeAllObjects];
    [self.tableView reloadData];

}

- (void)updateUI:(NSArray *)data
{
    if ([data count] > 0) {
        if (index == 0) {
            [self.photoDataSource addObjectsFromArray:data];
        }else{
            [self.pictureDataSource addObjectsFromArray:data];
        }
    }
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (index == 0) {
        return [self.photoDataSource count];
    }else{
        return [self.pictureDataSource count];
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (index == 0) {
        return 88;
    }else{
        return 135;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (index == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//没有点击效果
        PhotoList *PL = [self.photoDataSource objectAtIndex:indexPath.row];
        UIImageView *photoView = (UIImageView *)[cell viewWithTag:1];
        UILabel *dcLabel = (UILabel *)[cell viewWithTag:2];
        UILabel *countLabel = (UILabel *)[cell viewWithTag:3];
        NSString *imageUrl = PL.CoverPatch;
        [photoView setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"defaultAlbum.png"]];
        dcLabel.text = PL.AlbumName;
        countLabel.text = PL.DateTime;
        
    }else if(index == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//没有点击效果
        //防止重用问题
        UIView *emjoView = (UIView *)[cell viewWithTag:1000];
        if (emjoView) {
            [emjoView removeFromSuperview];
        }
        RecentlyPhotos *RP = [self.pictureDataSource objectAtIndex:indexPath.row];
        UILabel *time = (UILabel *)[cell viewWithTag:10];
        time.text = RP.mydate;
        UIView *photos1 = (UIView *)[cell viewWithTag:11];
        UIImageView *image1 = (UIImageView *)[cell viewWithTag:13];
        UIImageView *image2 = (UIImageView *)[cell viewWithTag:14];
        UIImageView *image3 = (UIImageView *)[cell viewWithTag:15];
        UIImageView *image4 = (UIImageView *)[cell viewWithTag:16];
        UIView *photos2 = (UIView *)[cell viewWithTag:17];
        UIImageView *image5 = (UIImageView *)[cell viewWithTag:18];
        //描述显示：
        
        NSString* body = [self flattenHTML:RP.todaydes];
        self.emjolable = [self createLableWithText:body font:[UIFont systemFontOfSize:15] width:79];
        
        self.emjolable.top = photos1.top;
        self.emjolable.left = photos1.right + 5;
        self.emjolable.height = 104;
        self.emjolable.tag = 1000;
        [cell addSubview:self.emjolable];
        //多张相片
        if (RP.ImageArray != nil && [RP.ImageArray count] > 0) {
            if ([RP.ImageArray count] >= 4) {
                photos1.hidden = NO;
                photos2.hidden = YES;
                
                [image1 setImageWithURL:[NSURL URLWithString:RP.ImageArray[0]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
                [image2 setImageWithURL:[NSURL URLWithString:RP.ImageArray[1]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
                [image3 setImageWithURL:[NSURL URLWithString:RP.ImageArray[2]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
                [image4 setImageWithURL:[NSURL URLWithString:RP.ImageArray[3]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            } else{
                photos1.hidden = YES;
                photos2.hidden = NO;
                
                [image5 setImageWithURL:[NSURL URLWithString:RP.ImageArray[0]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            }
            
        }
        
    }
    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (index == 0) {
        CommonSuccessBlock block = ^(void){
            [self headerReresh];
        };
        [self.navigationController pushViewController:PhotoDetailVCID
                                       withStoryBoard:ActivityStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
            PhotoDetailsController *vc = (PhotoDetailsController*)viewController;
            vc.photoAlbum = (PhotoList*)[self.photoDataSource objectAtIndex:indexPath.row];
                                                vc.block = block;
        }];
    }else{
        RecentlyPhotos *RP = [self.pictureDataSource objectAtIndex:indexPath.row];
        
        //多张相片
        if (RP.ImageArray && [RP.ImageArray count] > 0) {
            int count = [RP.ImageArray count];
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
            for (int i = 0; i < count; i++) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:[RP.ImageArray objectAtIndex:i]]; // 图片路径
                
                UIImageView *imgView = [[UIImageView alloc] init];
                [imgView setImageWithURL:[NSURL URLWithString:RP.ImageArray[i]]
                        placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];

                photo.srcImageView = imgView; // 来源于哪个UIImageView
                [photos addObject:photo];
            }
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
        }
    }
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
    }
    return result;
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    __block PhotosTableViewController *_self = self;
    
    if (index == 0) {
        [self showWithStatus:@""];
        [self.netWorkManager photoList:[RRTManager manager].loginManager.loginInfo.tokenId UserId:[RRTManager manager].loginManager.loginInfo.userId PageSize:_self.pageSize PageIndex:1 success:^(NSArray *photoListArray) {
            [self dismiss];
            [_self.photoDataSource removeAllObjects];
            _self.pageIndex = 1;
            [_self endRefresh];
            [self updateUI:photoListArray];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:@"刷新失败..."];
            [_self endRefresh];
        }];
        
    }else{
        
        [self showWithStatus:@""];
        [self.netWorkManager recentlyAblum:[RRTManager manager].loginManager.loginInfo.tokenId
                                 pageIndex:1
                                  pageSize:_self.pageSize TopCount:4
                                   success:^(NSArray *photoListArray) {
            [self dismiss];
            _self.pageIndex = 1;
            [_self.pictureDataSource removeAllObjects];
            [_self endRefresh];
            [_self updateUI:photoListArray];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:@"刷新失败..."];
            [_self endRefresh];
        }];

    }
}

- (void)footerReresh
{
    __block PhotosTableViewController *_self = self;
    
    if (index == 0) {
        [self showWithStatus:@""];
        [self.netWorkManager photoList:[RRTManager manager].loginManager.loginInfo.tokenId
                                UserId:[RRTManager manager].loginManager.loginInfo.userId
                              PageSize:self.pageSize
                             PageIndex:self.pageIndex + self.pageSize
                               success:^(NSArray *photoListArray) {
            [self dismiss];
            [self.photoDataSource removeAllObjects];
            _self.pageIndex += _self.pageSize;
            [self updateUI:photoListArray];
            [_self endLoadMore];
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
            [_self endLoadMore];
        }];
        
    }else{
        [self showWithStatus:@""];
        [self.netWorkManager recentlyAblum:[RRTManager manager].loginManager.loginInfo.tokenId pageIndex:self.pageIndex + self.pageSize pageSize:self.pageSize TopCount:4 success:^(NSArray *photoListArray) {
            [self dismiss];
            [self.pictureDataSource removeAllObjects];
            _self.pageIndex += _self.pageSize;
            [_self updateUI:photoListArray];
            [_self endLoadMore];
            
            
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
            [_self endLoadMore];
        }];
    
    }

}

@end

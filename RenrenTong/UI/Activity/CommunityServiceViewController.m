//
//  CommunityServiceViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-17.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "CommunityServiceViewController.h"
#import "CommunityServiceCell.h"
#import "MJRefresh.h"
#import "InputView.h"
#import "FaceBoard.h"

@interface CommunityServiceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) int selectedIndexPath;

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) MyDynamic *myDynamic;
@property (nonatomic, strong) InputView *inputView;

@end

@implementation CommunityServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区动态";
    self.navigationController.navigationBar.translucent = NO;
    self.allLabel.textColor = appColor;
    self.lineView.backgroundColor = appColor;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainTableView addGestureRecognizer:tapGesture];

}

#pragma mark -- 全部按钮响应

- (IBAction)clickAllButton:(UIButton *)sender
{
    self.selectedIndexPath = sender.tag;
    [UIView animateWithDuration:0.3f animations:^{
        self.lineView.left = self.allLabel.left;
    } completion:^(BOOL finished) {
        self.allLabel.textColor = appColor;
        self.weiboLabel.textColor = [UIColor blackColor];
        self.journalLabel.textColor = [UIColor blackColor];
        self.AlbumLabel.textColor = [UIColor blackColor];
    }];
    
}

#pragma mark -- 微博按钮响应

- (IBAction)clickWeiboButton:(UIButton *)sender
{
    self.selectedIndexPath = sender.tag;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineView.left = self.weiboLabel.left;
    } completion:^(BOOL finished) {
        self.weiboLabel.textColor = appColor;
        self.allLabel.textColor = [UIColor blackColor];
        self.journalLabel.textColor = [UIColor blackColor];
        self.AlbumLabel.textColor = [UIColor blackColor];
    }];
    
}

#pragma mark -- 日志按钮响应

- (IBAction)clickJournalButton:(UIButton *)sender
{
   self.selectedIndexPath = sender.tag;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineView.left = self.journalLabel.left;
    } completion:^(BOOL finished) {
        self.journalLabel.textColor = appColor;
        self.allLabel.textColor = [UIColor blackColor];
        self.AlbumLabel.textColor = [UIColor blackColor];
        self.weiboLabel.textColor = [UIColor blackColor];
    }];
}

#pragma mark -- 相册按钮响应

- (IBAction)clickAlbumButton:(UIButton *)sender
{
    self.selectedIndexPath = sender.tag;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineView.left = self.AlbumLabel.left;
    } completion:^(BOOL finished) {
        self.AlbumLabel.textColor = appColor;
        self.allLabel.textColor = [UIColor blackColor];
        self.journalLabel.textColor = [UIColor blackColor];
        self.weiboLabel.textColor = [UIColor blackColor];
    }];
}

#pragma mark -- TableViewDelegete
#pragma mark --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1500;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommunityServiceCell";
    CommunityServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommunityServiceCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//没有点击效果
    }
    cell.praiseAndDiscussView.clipsToBounds = YES;
    return cell;
    
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismiss];
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

//
//  TempViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TempViewController.h"
#import "DynamicCell.h"
#import "PublishCommentView.h"
#import "PublishListAndPraiseView.h"

@interface TempViewController ()<UITableViewDataSource,UITableViewDelegate,DynamicCellDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.pageIndex = 1;
    self.pageSize = 10;
    self.dataSource = [[NSMutableArray alloc] init];

    [self requestData];
}

-(void)requestData
{
    [self show];
    [self.netWorkManager getVisitorModelMessage:@""
                                         userId:[RRTManager manager].loginManager.loginInfo.userId
                                       pageSize:self.pageSize
                                      pageIndex:self.pageIndex
                                        success:^(NSMutableArray *data) {
                                            [self dismiss];
                                            [self updateView:data];
                                        } failed:^(NSString *errorMSG) {
                                            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                        }];
}

- (void)updateView:(NSMutableArray *)data
{
    [self.dataSource removeAllObjects];
    if (data && [data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            [self.dataSource addObject:data[i]];
        }
        [self.mainTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 0.001;
    } else{
        return 1.0f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [[DynamicCell alloc] init];
    
    cell.model = [self.dataSource objectAtIndex:indexPath.section];
    
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DynamicCell";
    //自定义cell类
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DynamicCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = [self.dataSource objectAtIndex:indexPath.section];
    cell.delegate = self;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- DynamicCellDelegete
#pragma mark --

-(void)DynamicPraise:(DynamicCell*)cell
{
    // 另外调班级网点赞接口
    [self.netWorkManager classArticlePraise:cell.model.ObjectId
                                     userId:[RRTManager manager].loginManager.loginInfo.userId
                                    success:^(NSDictionary *data) {
                                         [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"点赞成功"];
                                        [self requestData];
                                     } failed:^(NSString *errorMSG) {
                                         [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                     }];
}
-(void)DynamicComment:(DynamicCell *)cell
{
    [self publishWithParentId:@"0" ObjectId:cell.model.ObjectId];
}
-(void)DynamicMoreComment:(DynamicCell *)cell
{
    NSLog(@"sss");

}
-(void)DynamicReplayComment:(DynamicCell *)cell ReplayID:(NSString*)toUserID
{
    [self publishWithParentId:toUserID ObjectId:cell.model.ObjectId];

}
- (void)publishWithParentId:(NSString *)parentId ObjectId:(NSString *)objectId
{
    [self.netWorkManager classArticleCommentary:objectId
                                         userId:[RRTManager manager].loginManager.loginInfo.userId
                                            pId:parentId
                                    commentText:@"wwwwwww"
                                        success:^(NSDictionary *data) {
                                            [self showImage:[UIImage imageNamed:@""] status:@"评论成功"];
                                            [self requestData];
                                        } failed:^(NSString *errorMSG) {
                                            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                        }];
}

-(void)hidenNavigationBar:(BOOL)isEnd
{
    if (isEnd) {
        self.navigationController.navigationBar.hidden = NO;

    } else{
        self.navigationController.navigationBar.hidden = YES;

    }
}

@end

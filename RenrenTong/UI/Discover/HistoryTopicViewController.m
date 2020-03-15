//
//  HistoryTopicViewController.m
//  RenrenTong
//
//  Created by aedu on 15/4/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "HistoryTopicViewController.h"
#import "HotTopic.h"
#import "MJRefresh.h"
//#import ""
#import "TheHotTopicDetailsViewController.h"


@interface HistoryTopicViewController ()
{
    int pageindex;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property(nonatomic, strong)NSMutableArray *hotTopicArray;

@end


@implementation HistoryTopicViewController

- (NSMutableArray *)hotTopicArray
{
    if (!_hotTopicArray) {
        _hotTopicArray = [NSMutableArray array];
    }
    return _hotTopicArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史话题";
    pageindex = 1;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:tableView];
    [self.mainView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainView addFooterWithTarget:self action:@selector(footerReresh)];
    
    self.netWorkManager = [[NetWorkManager alloc]init];
    [self getRecommendTags];
}
- (void)getRecommendTags
{
    [self show];
    [self.netWorkManager getHistoricalTopicList:@"false"
                                      pageindex:pageindex
                                        success:^(NSMutableArray *data) {
                                            [self.hotTopicArray addObjectsFromArray:[HotTopic objectArrayWithKeyValuesArray:data]] ;
                                            [self dismiss];
                                            [self.mainView reloadData];
                                        } failed:^(NSString *errorMSG) {
                                            [self showImage:nil status:@"没有更多数据"];

                                        }];
}

- (void)gotoUI:(NSMutableArray *)data
{
    
}
- (void)headerReresh
{
    pageindex = 1;
    [self.hotTopicArray removeAllObjects];
    [self getRecommendTags];
    [self.mainView headerEndRefreshing];
}
- (void)footerReresh
{
    pageindex += 1;
    [self getRecommendTags];
    [self.mainView footerEndRefreshing];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hotTopicArray && [self.hotTopicArray count]) {
        return self.hotTopicArray.count;
    } else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [NSString stringWithFormat:@"Cell%d",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
    }
    if (self.hotTopicArray.count >0) {
        HotTopic *hotTopic = [self.hotTopicArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"#%@#",hotTopic.TagName];
        cell.textLabel.textColor = CommentViewTextColor;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"讨论 %d",hotTopic.ItemCount];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:DiscoverStoryBoardName
bundle:nil];
    TheHotTopicDetailsViewController *hTVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
                                              HotTicopDetailsVCID];
    if (self.hotTopicArray && [self.hotTopicArray count]) {
        hTVC.hotTopic = [self.hotTopicArray objectAtIndex:indexPath.row];
    }
    hTVC.tag = 1;
    [self.navigationController pushViewController:hTVC animated:YES];
}

@end

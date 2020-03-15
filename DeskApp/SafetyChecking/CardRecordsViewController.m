//
//  CardRecordsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "CardRecordsViewController.h"
#import "NetWorkManager+Attend.h"

@interface CardRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SwipingCardRecor *SCR;


@end

@implementation CardRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷卡记录";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:appColor];
    self.mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    [self requestData];
    

}

#pragma mark -- 解析数据
#pragma mark --
- (void)requestData
{
    [self show];
    [self.netWorkManager SwipingCardRecordNumber:self.classId
                                     mybegindate:self.beginTime
                                       myenddate:self.endTime
                                         success:^(NSMutableArray *data) {
                                             [self dismiss];
                                             [self gotoUpdataUI:data];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];

    }];
}

#pragma mark -- 刷新界面
#pragma mark --
- (void)gotoUpdataUI:(NSMutableArray *)array
{
    if (array && [array count] > 0) {
        for (int i = 0; i < [array count]; i ++) {
            self.SCR = array[i];
            [self.dataSource addObject:self.SCR];
        }
        [self.mainTableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardRecordsCell"
                                                            forIndexPath:indexPath];
    self.SCR = [self.dataSource objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:3];
    nameLabel.text = self.SCR.UserName;
    timeLabel.text = self.SCR.swingtime;
    typeLabel.text = self.SCR.usertypename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
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

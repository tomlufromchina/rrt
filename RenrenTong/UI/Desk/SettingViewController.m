//
//  SettingViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *identities;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.mainTableView setSeparatorColor:appColor];
    
    self.identities = [[NSArray alloc] initWithObjects:@"老师",@"学生",@"家长",@"家长",@"家长1",@"家长2",@"家长3",nil];
    
    //Add search button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(clickTrueButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    

}

- (void)clickTrueButton
{
    
}

#pragma mark - Table view data source And Delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"设置默认班级考勤";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"
                                                            forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:[self.identities objectAtIndex:0],[self.identities objectAtIndex:1],[self.identities objectAtIndex:2],[self.identities objectAtIndex:3],[self.identities objectAtIndex:4],[self.identities objectAtIndex:5],[self.identities objectAtIndex:6],nil];
    
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex <= 6) {
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:cellPath];
        if (cell) {
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = [self.identities objectAtIndex:buttonIndex];
        }
    }
}

//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//
//    for (UIView *subView in actionSheet.subviews) {
//        UIButton *button = (UIButton*)subView;
//        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//    }
//}


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

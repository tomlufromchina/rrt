//
//  CTGroupViewController.m
//  RenrenTong
//
//  Created by aedu on 15/3/25.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CTGroupViewController.h"
#import "Group.h"
#import "MJExtension.h"
#import "MessageNetService.h"

@interface CTGroupViewController ()
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property(nonatomic, strong)NSMutableArray *groupArray;

@end

@implementation CTGroupViewController
- (NSMutableArray *)groupArray
{
    if (!_groupArray) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的群组";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:tableView];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self getUserGroup];
}
- (void)getUserGroup
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserGroup",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userRole,@"userRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GroupModel *loginModel = [[GroupModel alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
            self.groupArray = (NSMutableArray*)loginModel.msg;
            [self.mainView reloadData];
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        GroupModel *loginModel = [[GroupModel alloc] initWithString:cache error:nil];
        if (loginModel.st == 0) {
            self.groupArray = (NSMutableArray*)loginModel.msg;
            [self.mainView reloadData];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"group";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    GroupModelMsg *group = self.groupArray[indexPath.row];
    [group setGroupphoto];
    cell.textLabel.text = group.GroupName;
    cell.imageView.image = [UIImage imageNamed:group.GroupPhoto];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:ChatVCID
                                   withStoryBoard:MessageStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ChatViewController *vc = (ChatViewController*)viewController;
                                            GroupModelMsg *group = self.groupArray[indexPath.row];
                                            vc.UserId =[NSString stringWithFormat:@"%@",group.GroupId];
                                            vc.UserName=group.GroupName;
                                            vc.groupType = group.GroupType.integerValue;
                                            
                                        }];
}

@end

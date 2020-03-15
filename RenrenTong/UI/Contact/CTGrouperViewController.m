//
//  CTGrouperViewController.m
//  RenrenTong
//
//  Created by aedu on 15/3/25.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CTGrouperViewController.h"
#import "Grouper.h"
#import "MJExtension.h"
#import "FriendCell.h"
#import "PinYin4Objc.h"
#import "ChineseString.h"
#import "ContactDetailViewController.h"
#import "MessageNetService.h"

@interface CTGrouperViewController ()
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property(nonatomic, strong)NSMutableArray *grouperArray;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *dataSoures;
@property (nonatomic, strong) NSMutableArray *teacherArray;
@property (nonatomic, strong) NSMutableArray *OtherArray;

@end

@implementation CTGrouperViewController
- (NSMutableArray *)grouperArray
{
    if (!_grouperArray) {
        _grouperArray = [NSMutableArray array];
    }
    return _grouperArray;
}
- (NSMutableArray *)headerArray
{
    if (!_headerArray) {
        _headerArray = [NSMutableArray array];
    }
    return _headerArray;
}
- (NSMutableArray *)dataSoures
{
    if (!_dataSoures) {
        _dataSoures = [NSMutableArray array];
    }
    return _dataSoures;
}
- (NSMutableArray *)teacherArray
{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}
- (NSMutableArray *)OtherArray
{
    if (!_OtherArray) {
        _OtherArray = [NSMutableArray array];
    }
    return _OtherArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.groupName;
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:tableView];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self getUserGrouper];
}
- (void)getUserGrouper
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserGroup",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userRole,@"userRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GroupModel *loginModel = [[GroupModel alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
            self.grouperArray = (NSMutableArray*)loginModel.msg;
            [self processData];
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
    }];

}
- (void)processData
{
    if(self.groupType != 3)
    {
        for (GroupModelMsg *grouper in self.grouperArray) {
            if (grouper.GroupType.intValue == 4 || grouper.GroupType.intValue == 3) {
                [self.teacherArray addObject:grouper];
            }
            else
            {
                [self.OtherArray addObject:grouper];
            }
        }
    self.dataSoures = [self getChineseStringArr:self.OtherArray];
    }else{
        self.dataSoures = [self getChineseStringArr:self.grouperArray];
    }
    [self.mainView reloadData];
}
#pragma mark - 字母分组
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    [self.headerArray removeAllObjects];
    [self.headerArray addObject:@""];
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        GroupModelMsg *grouper = arrToSort[i];
        chineseString.string=[NSString stringWithString:grouper.GroupName];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
                [outputFormat setToneType:ToneTypeWithoutTone];
                [outputFormat setVCharType:VCharTypeWithV];
                [outputFormat setCaseType:CaseTypeLowercase];
                pinYinResult=[PinyinHelper toHanyuPinyinStringWithNSString:chineseString.string withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        chineseString.group = grouper;
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        if (strchar.length > 0) {
            NSString *sr= [strchar substringToIndex:1];
            if(![self.headerArray containsObject:[sr uppercaseString]])//here I'm checking whether the
            {
                [self.headerArray addObject:[sr uppercaseString]];
                TempArrForGrouping = [[NSMutableArray alloc] init];
                checkValueAtIndex = NO;
            }
            if([self.headerArray containsObject:[sr uppercaseString]])
            {
                [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
                if(checkValueAtIndex == NO)
                {
                    [arrayForArrays addObject:TempArrForGrouping];
                    checkValueAtIndex = YES;
                }
            }
        }
        
    }
    return arrayForArrays;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1 + self.dataSoures.count;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if (section == 0) {
        count = [self.teacherArray count];
    } else {
        NSArray *array = [self.dataSoures objectAtIndex:section -1];
        count = array.count;
    }
    return count;
    
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 0.0;
    return height = (section == 0) ? 0 : 22;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleString = @"";
    if (section == 0) {
        return nil;
    }else{
        titleString = [self.headerArray objectAtIndex:section];
    }
    return titleString;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.headerArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"FriendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        GroupModelMsg *grouper = self.teacherArray[indexPath.row];
        [grouper setGroupphoto];
        int unread =[[IMCache shareIMCache] getSessionBrageFriendID:grouper.GroupId userid:[RRTManager manager].loginManager.loginInfo.userId];
        
        cell.brage.val = unread;
        [cell.icon setImage:[UIImage imageNamed:grouper.GroupPhoto]];
        cell.nameLabel.text = grouper.GroupName;
        
    } else {
    NSUInteger section = [indexPath section] - 1;
    NSUInteger row = [indexPath row];
    ChineseString *str = (ChineseString *) [[self.dataSoures objectAtIndex:section] objectAtIndex:row];
    GroupModelMsg *grouper = str.group;
        [grouper setGroupphoto];
    int unread =[[IMCache shareIMCache] getSessionBrageFriendID:grouper.GroupId userid:[RRTManager manager].loginManager.loginInfo.userId];
    
    cell.brage.val = unread;

    [cell.icon setImage:[UIImage imageNamed:grouper.GroupPhoto]];
    cell.nameLabel.text = grouper.GroupName;
    cell.role.text = grouper.GroupType;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:ContactDetailVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                                GroupModelMsg *grouper = self.teacherArray[indexPath.row];
                                                vc.OUserId =[NSString stringWithFormat:@"%@",grouper.GroupId];
                                            }];
    }
    else
    {
    [self.navigationController pushViewController:ContactDetailVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                                 ChineseString *str = (ChineseString *) [[self.dataSoures objectAtIndex:[indexPath section] - 1] objectAtIndex:[indexPath row]];
                                                GroupModelMsg *grouper = str.ctGrouper;
                                                 vc.OUserId =[NSString stringWithFormat:@"%@",grouper.GroupId];
                                            }];
    }
}

@end
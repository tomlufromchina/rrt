//
//  ContactTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-17.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ViewControllerIdentifier.h"
#import "UIImageView+WebCache.h"
#import "ContactAddTableViewController.h"
#import "ContactGroupViewController.h"
#import "ContactDetailViewController.h"
#import "ChatViewController.h"
#import "ViewControllerIdentifier.h"
#import "FriendCell.h"
#import "PinYin4Objc.h"
#import "ChineseString.h"
#import "FriendDetailViewContriller.h"
#import "MJRefresh.h"
#import "CTGroupViewController.h"

#define SectionNum 27

@interface ContactTableViewController ()
{
}

@property(nonatomic,strong)UISearchBar* searchBar;
@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *dataSoures;
@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation ContactTableViewController
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerReresh];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = appColor;//设置索引字母颜色
    self.allContacts=[[NSMutableArray alloc] init];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    self.title = @"联系人";
    PageIndex=1;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    
    //增加上拉刷新
    [self setupRefresh];
}

- (void)setupRefresh
{
    [self enableRefresh:YES action:@selector(headerReresh)];
    [self enableLoadMore:YES action:@selector(footorMore)];
}

-(void)message:(NSNotification*)notefication{
    [self.tableView reloadData];
}

//请求数据
- (void)requestLinkmanData
{
    [self show];

    [self.netWorkManager AddressBookDetail:[RRTManager manager].loginManager.loginInfo.userId
                                     token:[RRTManager manager].loginManager.loginInfo.tokenId PageIndex:PageIndex
                                   success:^(NSMutableArray *data) {
                                       [self dismiss];
                                       [self updateView:data];
                                       [self endRefresh];
                                   } failed:^(NSString *errorMSG) {
                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       [self endRefresh];
                                   }];
}

#pragma mark - 字母分组
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    [self.headerArray removeAllObjects];
    [self.headerArray addObject:@""];
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        GoodFriend *gf = arrToSort[i];
        chineseString.string=[NSString stringWithString:gf.TrueName];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
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
        chineseString.goodFriend = gf;
        [chineseStringsArray addObject:chineseString];
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
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
    return arrayForArrays;
}


//刷新界面
- (void)updateView:(NSMutableArray *)datum
{
    if (datum.count>0) {
        PageIndex++;
        [self.allContacts removeAllObjects];
        [self.allContacts addObjectsFromArray:datum];
        self.dataSoures = [self getChineseStringArr:self.allContacts];
    }
    [self.tableView reloadData];
}

//刷新界面
- (void)updateMore:(NSMutableArray *)datum
{
    if (datum.count>0 ) {
        
        [self.allContacts addObjectsFromArray:datum];
        PageIndex++;
        self.dataSoures = [self getChineseStringArr:self.allContacts];
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MESSAGE object: nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + self.dataSoures.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if (section == 0) {
        count = 2;
    } else {
        NSArray *array = [self.dataSoures objectAtIndex:section - 1];
        count = [array count];
    }
    return count;
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
        if(indexPath.row == 0)
        {
            cell.icon.image = [UIImage imageNamed:@"new_friends"];
            cell.nameLabel.text = @"新的朋友";
            cell.role.text = @"";
        }else{
            cell.icon.image = [UIImage imageNamed:@"goup"];
            cell.nameLabel.text = @"我的群组";
            cell.role.text = @"";
        }
        
    } else {
        NSUInteger section = [indexPath section] - 1;
        NSUInteger row = [indexPath row];
        ChineseString *str = (ChineseString *) [[self.dataSoures objectAtIndex:section] objectAtIndex:row];
        GetFollowsMsglist *gf = str.goodFriend;
        int unread =[[IMCache shareIMCache] getSessionBrageFriendID:gf.UserId userid:[RRTManager manager].loginManager.loginInfo.userId];
        
        cell.brage.val = unread;
        [cell.icon setImageWithURL:[NSURL URLWithString:gf.PictureUrl]
                  placeholderImage:[UIImage imageNamed:@"default"]];
        cell.nameLabel.text = gf.TrueName;
        cell.role.text = gf.Roles;
    }
    
    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:ContactAddVCID
                                           withStoryBoard:ContactStoryBoardName
                                                withBlock:nil];
        }else if (indexPath.row == 1)
        {
            CTGroupViewController *groupVC = [[CTGroupViewController alloc]init];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
    } else {
        [self.navigationController pushViewController:ContactDetailVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                            ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                                                ChineseString *str = (ChineseString *) [[self.dataSoures objectAtIndex:[indexPath section] - 1] objectAtIndex:[indexPath row]];
                                                GoodFriend *gf = str.goodFriend;
                                                vc.OUserId =[NSString stringWithFormat:@"%@",gf.UserId];
                                            }];
        
//        FriendDetailViewContriller *detailVC = [[FriendDetailViewContriller alloc]init];
//        ChineseString *str = (ChineseString *) [[self.dataSoures objectAtIndex:[indexPath section] - 1] objectAtIndex:[indexPath row]];
//        GoodFriend *gf = str.goodFriend;
//        detailVC.userId =[NSString stringWithFormat:@"%@",gf.UserId];
//        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)updateUI:(NewFriends *)data
{
    [self showSuccessWithStatus:@""];
}
#pragma mark - Utility
- (void)loadData
{
    [self requestLinkmanData];
}
#pragma mark - 上拉刷新
- (void)headerReresh
{
    PageIndex=1;
    [self requestLinkmanData];
//    [self.netWorkManager AddressBookDetail:[RRTManager manager].loginManager.loginInfo.userId
//                                     token:[RRTManager manager].loginManager.loginInfo.tokenId PageIndex:PageIndex
//                                   success:^(NSMutableArray *data) {
//                                       [self updateView:data];
//                                       [self endRefresh];
//                                   } failed:^(NSString *errorMSG) {
//                                       [self endRefresh];
//                                   }];
}

- (void)footorMore
{
   
    [self.netWorkManager AddressBookDetail:[RRTManager manager].loginManager.loginInfo.userId
                                     token:[RRTManager manager].loginManager.loginInfo.tokenId PageIndex:PageIndex
                                   success:^(NSMutableArray *data) {
                                       [self updateMore:data];
                                       [self endLoadMore];
                                   } failed:^(NSString *errorMSG) {
                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                      [self endLoadMore];
                                   }];
}
@end

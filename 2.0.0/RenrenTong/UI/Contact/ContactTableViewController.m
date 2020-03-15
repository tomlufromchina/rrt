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

#define SectionNum 27

@interface ContactTableViewController ()
{
    Contact *_contact;
    UISearchDisplayController *_displayController;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *sectionIndexs;   //好友index：A,B,C.....X,Y,Z,#
@property (nonatomic, strong) NSMutableArray *allKeys;
@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
//@property (nonatomic, strong) UISearchDisplayController *displayController;
//@property (nonatomic, strong) NSMutableArray *srcDataSource;
//@property (nonatomic, strong) NSMutableArray *destDataSource;

@end

@implementation ContactTableViewController

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
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = appColor;//设置索引字母颜色
    
    
    
    self.title = @"联系人";
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(contactDeleted:)
                                                 name: kContactDeleted
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(contactAdded:)
                                                 name: kContactAdded
                                               object: nil];
    
    //增加上拉刷新
    [self setupRefresh];
    
//    _srcDataSource = [[NSMutableArray alloc] init];
//    _destDataSource =[[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)setupRefresh
{
    [self enableRefresh:YES action:@selector(headerReresh)];
}

//请求数据
- (void)requestLinkmanData
{
    [self showWithStatus:@""];
    [self.netWorkManager AddressBookDetail:[RRTManager manager].loginManager.loginInfo.tokenId
                                   success:^(NSDictionary *data) {
        [self dismiss];
        [self updateView:data];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
    }];
}
//刷新界面
- (void)updateView:(NSDictionary *)datum
{
//    [self showSuccessWithStatus:@""];
    
    NSDictionary *friendsDictioanry = [datum objectForKey:@"HY"];

    //排序A,B,C,E,G,.....
    _sectionIndexs = [[friendsDictioanry allKeys]
                                         sortedArrayUsingSelector:@selector(compare:)];
    if (_sectionIndexs && [_sectionIndexs count] >= 2) {
        if ([[_sectionIndexs objectAtIndex:0] isEqualToString:@"#"]) {
            NSMutableArray *tmpArrary = [NSMutableArray arrayWithArray:_sectionIndexs];
            [tmpArrary removeObjectAtIndex:0];
            [tmpArrary addObject:[_sectionIndexs objectAtIndex:0]];
            _sectionIndexs = tmpArrary;
        }
    }
    
    
    self.allKeys = [NSMutableArray arrayWithCapacity:30];
    self.allContacts = [NSMutableArray arrayWithCapacity:30];
    
#if 0
    NSArray *array = [datum objectForKey:@"GZ"];
    if (array) {
        [_allKeys addObject:@"GZ"];
        [_allContacts addObject:array];
    }
    array = [datum objectForKey:@"QL"];
    if (array) {
        [_allKeys addObject:@"QL"];
        [_allContacts addObject:array];
    }
    array = [datum objectForKey:@"FZ"];
    if (array) {
        [_allKeys addObject:@"FZ"];
        [_allContacts addObject:array];
    }
#endif
    
    NSArray *array = nil;
    for (int i = 0; i < [self.sectionIndexs count]; i++) {
        NSString *key = (NSString*)[self.sectionIndexs objectAtIndex:i];
        array = (NSArray*)[friendsDictioanry objectForKey:key];
        [_allKeys addObject:key];
        [_allContacts addObject:array];
    }
    
//    [_srcDataSource removeAllObjects];
//    for (int i = 0; i < [_allContacts count]; i++) {
//        NSArray *secArray = (NSArray*)[_allContacts objectAtIndex:i];
//        
//        for (int j = 0; j < [secArray count]; j++) {
//            Contact *contact = (Contact*)[secArray objectAtIndex:j];
//            //取出全部联系人的名字放到数组中
//            [_srcDataSource addObject:contact.name];
//        }
//    }
    [self.tableView reloadData];
    
    [DataManager addContacts:self.allContacts];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kContactDeleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kContactAdded object:nil];
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 1 + [self.allKeys count];

    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if (tableView != self.tableView) {
        
        //显示searchDiaplayContoroller的结果
//        count = [_destDataSource count];
        
    }else{
        if (section == 0) {
            count = 1;
        } else {
            NSArray *array = (NSArray*)[self.allContacts objectAtIndex:section - 1];
            count = [array count];
        }
    }
    return count;
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 0.0;
    
//    return height = (section == 0) ? 44 : 22;
    return height = (section == 0) ? 0 : 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
    
//       _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width, 44)];
//       _searchBar.backgroundColor = [UIColor clearColor];
//       _searchBar.delegate = self;
//        
//       _displayController = [[UISearchDisplayController alloc] initWithSearchBar:
//                              self.searchBar contentsController:
//                              self];//内容显示在（contentsController那个界面）当前界面。
//        
//       _displayController.delegate = self;
//       _displayController.searchResultsDataSource = self;
//       _displayController.searchResultsDelegate = self;
//    
//        UIView *line1 = [[UIView alloc] init];
//       line1.frame = CGRectMake(0, 43, 320, 1);
//       line1.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1];
//    
//       UIView *sectionView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
//       [sectionView1 setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
//       [sectionView1 addSubview:_searchBar];
//       [sectionView1 addSubview:line1];
//    
//       return sectionView1;
        return nil;
    
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 320, 21)];
        label.backgroundColor = [UIColor clearColor];
        label.font=[UIFont fontWithName:@"Arial" size:13];
        NSString *key = (NSString*)[self.allKeys objectAtIndex:section - 1];
        
        
        if ([key isEqualToString:@"GZ"]) {
            label.text = @"公众号";
        } else if ([key isEqualToString:@"QL"]) {
            label.text = @"群聊";
        } else if ([key isEqualToString:@"FZ"]) {
            label.text = @"分组";
        } else {
            label.text = key;
        }
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 21, 320, 1);
        line.backgroundColor = [UIColor colorWithRed:218.0/255.0
                                               green:218.0/255.0
                                                blue:218.0/255.0
                                               alpha:1];
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       tableView.bounds.size.width,
                                                                       22)];
        [sectionView setBackgroundColor:[UIColor colorWithRed:245.0/255.0
                                                        green:245.0/255.0
                                                         blue:245.0/255.0
                                                        alpha:1]];
        [sectionView addSubview:label];
        [sectionView addSubview:line];
        
        return sectionView;
    }
}

// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexs;
}

//返回section index对应的section
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    return index + 1 + ([self.allKeys count] - [self.sectionIndexs count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView != self.tableView) {
        
//        cell.textLabel.text = [_destDataSource objectAtIndex:indexPath.row];
        
    }else{
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ContactMainCell"
                                                       forIndexPath:indexPath];
            UILabel *name = (UILabel*)[cell viewWithTag:2];
            UIImageView *titleImage = (UIImageView *)[cell viewWithTag:3];
            titleImage.layer.cornerRadius = 2.0f;
            titleImage.hidden = NO;
            name.text = @"新的朋友";
            UIImageView *hiImage = (UIImageView *) [cell viewWithTag:1];
            hiImage.image = [UIImage imageNamed:@"new_friends"];
        } else {
            NSArray *array = (NSArray*)[self.allContacts objectAtIndex:indexPath.section - 1];
            _contact = (Contact*)[array objectAtIndex:indexPath.row];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ContactMainCell"
                                                   forIndexPath:indexPath];
            UIImageView *titleImage = (UIImageView *)[cell viewWithTag:3];
            titleImage.hidden = YES;
            UILabel *name = (UILabel*)[cell viewWithTag:2];
            
            UIImageView *headImage = (UIImageView *)[cell viewWithTag:1];
            [headImage setImageWithURL:[NSURL URLWithString:_contact.avatarUrl]
                      placeholderImage:[UIImage imageNamed:@"default"]];
            
            NSString *key = (NSString*)[self.allKeys objectAtIndex:indexPath.section - 1];
            if ([key isEqualToString:@"GZ"] ||
                [key isEqualToString:@"QL"] ||
                [key isEqualToString:@"FZ"]) {
                name.text = _contact.name;
                [headImage setImageWithURL:[NSURL URLWithString:_contact.avatarUrl]
                          placeholderImage:[UIImage imageNamed:@"default"]];
            } else {
                name.text = _contact.name;
                [headImage setImageWithURL:[NSURL URLWithString:_contact.avatarUrl]
                          placeholderImage:[UIImage imageNamed:@"default"]];
            }
        }
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
        [self.navigationController pushViewController:ContactAddVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:nil];
        
    } else {
        NSString *key = (NSString*)[self.allKeys objectAtIndex:indexPath.section - 1];
        if ([key isEqualToString:@"GZ"]) {
            [self.navigationController pushViewController:ChatVCID
                                           withStoryBoard:MessageStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                ChatViewController *vc = (ChatViewController*)viewController;
                NSArray *array = (NSArray*)[self.allContacts objectAtIndex:indexPath.section - 1];
                Contact *contact = (Contact*)[array objectAtIndex:indexPath.row];
                vc.toStr = [NSString stringWithFormat:@"%@", contact.contactId];
            }];

            
        } else if ([key isEqualToString:@"QL"]) {
            [self.navigationController pushViewController:ChatVCID
                                           withStoryBoard:MessageStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                ChatViewController *vc = (ChatViewController*)viewController;
                NSArray *array = (NSArray*)[self.allContacts objectAtIndex:indexPath.section - 1];
                Contact *contact = (Contact*)[array objectAtIndex:indexPath.row];
                vc.toStr = [NSString stringWithFormat:@"%@", contact.contactId];
            }];
            
        } else if ([key isEqualToString:@"FZ"]) {
            [self.navigationController pushViewController:ContactGroupVCID
                                           withStoryBoard:ContactStoryBoardName
                                                withBlock:nil];
        } else {
            [self.navigationController pushViewController:ContactDetailVCID
                                           withStoryBoard:ContactStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
                //取出联系人对象
                NSArray *array = (NSArray*)[self.allContacts objectAtIndex:indexPath.section - 1];
                Contact *contact = (Contact*)[array objectAtIndex:indexPath.row];
                vc.OUserId = contact.contactId;
                vc.headUrl = contact.avatarUrl;
            }];
        }
    }
}

- (void)updateUI:(NewFriends *)data
{
    [self showSuccessWithStatus:@""];
    
    [self.delegate sendNewFriendObject:data];
}

//#pragma mark --  UISearchBarDelegate
//#pragma mark --
//- (NSPredicate *)searchResult
//{
//    return [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",_displayController.searchBar.text];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//    //得到搜索的结果
//    [_destDataSource removeAllObjects];
//    //得到所有的名字 然后进行过滤操作
//    NSArray *array = [_srcDataSource filteredArrayUsingPredicate:[self searchResult]];
//    //经过滤的数据放入数据源
//    [_destDataSource addObjectsFromArray:array];
//}
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    for(id cc in [_displayController.searchBar subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消"  forState:UIControlStateNormal];
//        }
//    }
//    return YES;
//}

#pragma mark - button action
#pragma mark -

#pragma mark - UISearchBarDelegate
#pragma mark -
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];

    
    //todo:...
}

#pragma mark - Utility
#pragma mark -
- (void)loadData
{
    //读取数据库中的联系人
    NSArray *contacts = [DataManager allContacts];
    if (contacts && [contacts count] > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSPredicate *pre;
        NSArray *array;
        
#if 0
        //公众号
        NSPredicate *pre = [NSPredicate predicateWithFormat:
                            @"SELF.objType == %@", @"1"];
        NSArray *array = [contacts filteredArrayUsingPredicate:pre];
        if (array && [array count] > 0) {
            [dict setObject:array forKey:@"GZ"];
        }
        
        //群聊
        pre = [NSPredicate predicateWithFormat:
               @"SELF.objType == %@", @"2"];
        array = [contacts filteredArrayUsingPredicate:pre];
        if (array && [array count] > 0) {
            [dict setObject:array forKey:@"QL"];
        }
#endif
        
        //好友
        pre = [NSPredicate predicateWithFormat:
               @"SELF.objType == %@", @"3"];
        array = [contacts filteredArrayUsingPredicate:pre];
        if (array && [array count] > 0) {
            NSMutableDictionary *hyDict = [NSMutableDictionary dictionary];
            NSArray *tmpKeys = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G",
                                @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",
                                @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
            for (int i = 0; i < [tmpKeys count]; i++) {
                pre = [NSPredicate predicateWithFormat:
                       @"SELF.py == %@", [tmpKeys objectAtIndex:i]];
                array = [contacts filteredArrayUsingPredicate:pre];
                if (array && [array count] > 0) {
                    [hyDict setObject:array forKey:[tmpKeys objectAtIndex:i]];
                }
            }
            
            [dict setObject:hyDict forKey:@"HY"];
        }

        [self updateView:dict];
    } else {
        [self requestLinkmanData];
    }
}


#pragma mark - NSNotification
#pragma mark -
//删除好友后重新读取联系人数据库
- (void) contactDeleted:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    NSString *userId = (NSString*)[info objectForKey:@"userId"];
    
    [DataManager deleteContact:userId];
    
    [self loadData];
}
//接受好友后回来重新刷新界面。
- (void) contactAdded:(NSNotification*)notification
{
    [self headerReresh];
}

#pragma mark - 上拉刷新
#pragma mark -
- (void)headerReresh
{
    [self.netWorkManager AddressBookDetail:[RRTManager manager].loginManager.loginInfo.tokenId
                                   success:^(NSDictionary *data) {
        [self updateView:data];

        [self endRefresh];
    } failed:^(NSString *errorMSG) {
        [self showErrorWithStatus:errorMSG];
        
        [self endRefresh];
    }];
}

@end

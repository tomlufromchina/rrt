//
//  MyClassArticleViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyClassArticleViewController.h"
#import "MJRefresh.h"
#import "NSDate+Tool.h"
#import "AlbumList.h"
#import "ArcicleDetailViewController.h"
#import "DXPopover.h"

@interface MyClassArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *titleTable;
    UITableView *table;
    UIView *deleteView; //删除操作界面
    UILabel *totleSelectLabel;
    UIButton *deleteButton;//删除按钮
    DXPopover *popover;
    UIButton *titleButton; //标题分类按钮
    
    UIButton *allselect; //是否全选标志
    NSMutableArray *dataArray;//文章数据数组
    NSMutableArray *titleArray;//标题选项数据数组
    NSMutableArray *selectAry;
    BOOL isDelete;//是否删除标志
    NSString *articleCategry;//文章分类标志
    
    BOOL isAuthority; //权限标志
    BOOL isDeleteAll; //是否删除全部
    NSInteger dataPage;
    BOOL isHeadRefresh; //判断是否头更新
    BOOL isFootRefresh; //判断是否根更新
    
    NSInteger tabeldataPage;
    NSMutableArray *currentNextPageAry; //当前下一页缓存数据
    BOOL istableFootRefresh; //判断是否根更新
    BOOL istableHeadRefresh;
    NSString *currentArticleCategry;//当前分类id
}

@end

@implementation MyClassArticleViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //文章分类弹出视图
    popover = [DXPopover popover];
     //文章分类选择点击视图
    UIView *titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(5, 9, 170, 26);
    [titleButton addTarget:self action:@selector(titlebtnClick:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    titleButton.titleLabel.font = [UIFont systemFontOfSize: 18];
    [titleButton setTitle:@"文章" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGSize size = [titleButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    UIImageView *upDownImage = [[UIImageView alloc] initWithFrame:CGRectMake(170/2 + size.width/2 + 10, 12, 15, 10)];
    upDownImage.center = CGPointMake(upDownImage.center.x, titleButton.frame.size.height/2);
    upDownImage.image = [UIImage imageNamed:@"xljt-"];
    upDownImage.tag = 2;
    [titleButton addSubview:upDownImage];
    [titleview addSubview:titleButton];
    self.navigationItem.titleView = titleview;
    //文章删除按钮
    UIButton *_rightButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,50,50)];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightButton setTitle:@"删除" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(deleteArticle:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    selectAry = [[NSMutableArray alloc] init];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem.tag = 1;
    tabeldataPage = 1;
    dataPage = 1;
    articleCategry = @"0";
    currentArticleCategry = articleCategry;
    
    //文章内容tableview视图
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:table];
    [self setupRefresh];
    [self initData];
    [self checkAuthority];
    [self getArticleCategory];
}


#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == titleTable) {
        return titleArray.count;
    }
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == titleTable) {
        return 45;
    }
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == titleTable) {
        static NSString *identifier = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] init];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ArchiveCategoryListItem *item =  [titleArray objectAtIndex:indexPath.row];
        titleCell.textLabel.text = item.CategoryName;
        return titleCell;
    }
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        backView.tag = 1;
        backView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:backView];
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.tag = 2;
        selectButton.frame = CGRectMake(10, 0, 30, 30);
        selectButton.center = CGPointMake(selectButton.center.x, backView.center.y);
        [selectButton setImage:[UIImage imageNamed:@"fxk-"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"fxk2-"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(selectDelete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView insertSubview:selectButton belowSubview:backView];
        
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH - 20, 30)];
        msg.textAlignment = NSTextAlignmentLeft;
        msg.font = [UIFont systemFontOfSize:17];
        msg.textColor = MainTextColor;
        msg.tag = 10;
        [backView addSubview:msg];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(msg.frame), CGRectGetMaxY(msg.frame)+5, 25, 25)];
        imageView.tag = 11;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 25/2;
        [backView addSubview:imageView];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(msg.frame) + 5, 80, 25)];
        name.font = [UIFont systemFontOfSize:14];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = GrayTextColor;
        name.tag = 12;
        [backView addSubview:name];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame) + 15, CGRectGetMaxY(msg.frame) + 5, 120, 25)];
        time.font = name.font;
        time.textAlignment = NSTextAlignmentLeft;
        time.tag = 13;
        time.textColor = name.textColor;
        [backView addSubview:time];
        
        UILabel *readNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 40, CGRectGetMaxY(msg.frame) + 5, 40, 25)];
        readNum.textAlignment = NSTextAlignmentLeft;
        readNum.tag = 14;
        readNum.font = name.font;
        readNum.textColor = name.textColor;
        [backView addSubview:readNum];
        
        UIImageView *eyeImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(readNum.frame) - 25, CGRectGetMaxY(msg.frame) + 20, 20, 10)];
        eyeImage.center = CGPointMake(eyeImage.center.x, readNum.center.y);
        eyeImage.image = [UIImage imageNamed:@"ll-"];
        [backView addSubview:eyeImage];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 79, SCREENWIDTH, 1)];
        lineView.backgroundColor = LineColor;
        lineView.alpha = 0.4;
        [cell.contentView addSubview:lineView];
        
    }
    ArchiveListMsgItem *item = [dataArray objectAtIndex:indexPath.row];
    UIImageView *userImage = (UIImageView*)[cell.contentView viewWithTag:11];
    [userImage setImageWithUrlStr:item.UserPhoto placholderImage:[UIImage imageNamed:@"default"]];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    label.text = item.ArchiveTitle;
    label = (UILabel *)[cell.contentView viewWithTag:12];
    label.text = item.UserName;
    label = (UILabel *)[cell.contentView viewWithTag:13];
    label.text = [NSDate getDateStringByFormatterString:[NSDate getDateByDefaultFormatterString:item.PubTime] Formate:@"M月dd日  H:mm"];
    label = (UILabel *)[cell.contentView viewWithTag:14];
    label.text = [NSString stringWithFormat:@"%d",item.HitCount];
    
    UIButton *selectButton = (UIButton*)[cell.contentView viewWithTag:2];
    
    if (isDelete) {
        UIView *view = (UIView *)[cell.contentView viewWithTag:1];
        view.center = CGPointMake(SCREENWIDTH/2 + 40, view.center.y);
        if ([selectAry containsObject:item.ArchiveId]) {
            selectButton.selected = YES;
            selectButton.hidden = NO;
        }
    }else{
        UIView *view = (UIView *)[cell.contentView viewWithTag:1];
        view.center = CGPointMake(SCREENWIDTH/2, view.center.y);
        selectButton.hidden = YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == titleTable) {
        [popover dismiss];
        titleButton.selected = NO;
        ArchiveCategoryListItem *item = [titleArray objectAtIndex:indexPath.row];
        currentArticleCategry = articleCategry;
        [titleButton setTitle:item.CategoryName forState:UIControlStateNormal];
        CGSize size = [titleButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        UIImageView *upDownImage = (UIImageView*)[titleButton viewWithTag:2];
        upDownImage.frame = CGRectMake(170/2 + size.width/2 + 10, 12, 15, 10);
        upDownImage.center = CGPointMake(upDownImage.center.x, titleButton.frame.size.height/2);
        articleCategry = item.CategoryId;
        [self headerReresh];
    }else{
    if (isDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:2];
        ArchiveListMsgItem *item = [dataArray objectAtIndex:indexPath.row];
        if (!btn.selected) {
            [selectAry addObject:item.ArchiveId];
        }else{
            [selectAry removeObject:item.ArchiveId];
        }
        btn.selected = !btn.selected;
        if (selectAry.count != dataArray.count) {
            if (allselect.selected) {
                allselect.selected = !allselect.selected;
            }
        }
        totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",selectAry.count];
        if (selectAry.count > 0) {
            deleteButton.backgroundColor = theLoginButtonColor;
            deleteButton.userInteractionEnabled = YES;
        }else{
            deleteButton.backgroundColor = [UIColor grayColor];
            deleteButton.userInteractionEnabled = NO;
        }
    }else{
        ArchiveListMsgItem *itemList = [dataArray objectAtIndex:indexPath.row];
        ArcicleDetailViewController *view = [[ArcicleDetailViewController alloc] init];
        view.articleId = itemList.ArchiveId;
        [self.navigationController pushViewController:view animated:YES];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:nil
                                                                    action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
    }
    }
}

#pragma mark -文章分类按钮事件
-(void)titlebtnClick:(UIButton *)sender
{
    if (!titleTable) {
        titleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
        titleTable.delegate = self;
        titleTable.dataSource = self;
    }
    if (!titleArray) {
        titleArray = [[NSMutableArray alloc] init];
    }
    UIView *titleView = self.navigationItem.titleView;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(titleView.frame), CGRectGetMaxY(titleView.frame) + 20);
    // 初始化选择班级列表
    [popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:titleTable inView:self.view];
}

#pragma mark -单个cell删除按钮事件
-(void)selectDelete:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    for (UIView *view = sender.superview; ; view = view.superview) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell*)view;
            NSIndexPath *path = [table indexPathForCell:cell];
            ArchiveListMsgItem *item = [dataArray objectAtIndex:path.row];
            if (sender.selected) {
                [selectAry addObject:item.ArchiveId];
            }else{
                [selectAry removeObject:item.ArchiveId];
            }
            if (selectAry.count != dataArray.count) {
                if (allselect.selected) {
                    allselect.selected = !allselect.selected;
                }
            }
            totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",selectAry.count];
            if (selectAry.count > 0) {
                deleteButton.backgroundColor = theLoginButtonColor;
                deleteButton.userInteractionEnabled = YES;
            }else{
                deleteButton.backgroundColor = [UIColor grayColor];
                deleteButton.userInteractionEnabled = NO;
            }
            break;
        }
    }
}
#pragma mark -导航栏删除按钮事件
-(void)deleteArticle:(UIButton*)sender
{
    if (isAuthority) {
        if (!isDelete) {
            [sender setTitle:@"取消" forState:UIControlStateNormal];
            isDelete = YES;
            [table reloadData];
            [self showDeleteView];
        }else{
            [sender setTitle:@"删除" forState:UIControlStateNormal];
            [selectAry removeAllObjects];
            isDelete = NO;
            [table reloadData];
            [self hideDeleteView];
        }
    }else{
        [self showUploadView:@"没有权限，不能删除图片哦~~"];
    }
}
#pragma mark - 全选删除按钮事件
-(void)selectDeleteAll:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [selectAry removeAllObjects];
        totleSelectLabel.text = @"已选（0）";
        deleteButton.backgroundColor = [UIColor grayColor];
        deleteButton.userInteractionEnabled = NO;
        
    }else{
        [selectAry removeAllObjects];
        for (ArchiveListMsgItem *ietm in dataArray) {
            [selectAry addObject:ietm.ArchiveId];
        }
        totleSelectLabel.text = [NSString stringWithFormat:@"已选（%d）",dataArray.count];
        deleteButton.backgroundColor = theLoginButtonColor;
        deleteButton.userInteractionEnabled = YES;
    }
    [table reloadData];
}
-(void)deleteArticleN:(UIButton*)sender
{
    
    NSString *archiveId = @"";
    NSArray *selectArray = [NSArray arrayWithArray:selectAry];
    for (NSInteger i = 0; i < selectArray.count; i++) {
        if (i  ==  0 ) {
            archiveId = [archiveId stringByAppendingString:[NSString stringWithFormat:@"%@",[selectAry objectAtIndex:i]]];
        }else{
            archiveId = [archiveId stringByAppendingString:[NSString stringWithFormat:@",%@",[selectAry objectAtIndex:i]]];
        }
    }
    sender.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/DeleteArchive",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"archiveId",nil];
    
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        if (selectAry.count == dataArray.count) {
            isDeleteAll = YES;
        }
        allselect.selected = !allselect.selected;
        [selectAry removeAllObjects];
        dataPage = 1;
        [self initData];
        totleSelectLabel.text = @"已选（0）";
        deleteButton.backgroundColor = [UIColor grayColor];
        deleteButton.userInteractionEnabled = NO;
    } fail:^(id errors) {
        [self showUploadView:errors];
        sender.userInteractionEnabled = YES;
    } cache:^(id cache) {
        
    }];
}


#pragma mark - 显示底部删除选择内容视图
-(void)showDeleteView
{
    if (!deleteView) {
        deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 50)];
        deleteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:deleteView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = LineColor;
        [deleteView addSubview:lineView];
        
        allselect = [UIButton buttonWithType:UIButtonTypeCustom];
        allselect.frame = CGRectMake(10, 10, 70, 30);
        [allselect setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [allselect setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [allselect setTitle:@"全选" forState:UIControlStateNormal];
        [allselect setTitle:@"取消" forState:UIControlStateSelected];
        [allselect addTarget:self action:@selector(selectDeleteAll:) forControlEvents:UIControlEventTouchUpInside];
        allselect.layer.masksToBounds = YES;
        allselect.layer.cornerRadius = 3;
        allselect.layer.borderWidth = 1;
        allselect.layer.borderColor = [UIColor greenColor].CGColor;
        [deleteView addSubview:allselect];
        
        totleSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 1, 150, 50)];
        totleSelectLabel.text = @"已选（0）";
        totleSelectLabel.center = CGPointMake(SCREENWIDTH/2, totleSelectLabel.center.y);
        totleSelectLabel.textAlignment = NSTextAlignmentCenter;
        totleSelectLabel.textColor = theLoginButtonColor;
        [deleteView addSubview:totleSelectLabel];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(SCREENWIDTH - 90, 10, 70, 30);
        deleteButton.backgroundColor = [UIColor grayColor];
        deleteButton.userInteractionEnabled = NO;
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteArticleN:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.cornerRadius = 3;
        [deleteView addSubview:deleteButton];
    }
    [UIView animateWithDuration:0.35 animations:^{
        deleteView.center = CGPointMake(deleteView.center.x, deleteView.center.y - deleteView.frame.size.height);
    } completion:^(BOOL finished) {
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, table.frame.size.height - 50);
    }];
}
#pragma mark - 删除底部删除内容视图
-(void)hideDeleteView
{
    table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, table.frame.size.height + 50);
    [UIView animateWithDuration:0.35 animations:^{
        deleteView.center = CGPointMake(deleteView.center.x, deleteView.center.y + deleteView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - tableview 刷新操作
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [table addHeaderWithTarget:self action:@selector(headerReresh)];
    [table addFooterWithTarget:self action:@selector(footerReresh)];
    
    [titleTable addFooterWithTarget:self action:@selector(tatileTableFootReresh)];
    [titleTable addFooterWithTarget:self action:@selector(tatileTableheadReresh)];
}
-(void)tatileTableheadReresh
{
    if (!istableHeadRefresh) {
        tabeldataPage = 1;
        isHeadRefresh = YES;
        [self initData];
    }
}
-(void)tatileTableFootReresh
{
    if (!istableFootRefresh) {
        istableFootRefresh = YES;
        [self getArticleCategory];
    }
}

- (void)headerReresh
{
    if (!isHeadRefresh) {
        dataPage = 1;
        isHeadRefresh = YES;
        [self initData];
    }
}

- (void)footerReresh
{
    if (!isFootRefresh) {
        isFootRefresh = YES;
        [self initData];
    }
}
-(void)endRefresh
{
    if (isHeadRefresh) {
        [table headerEndRefreshing];
        isHeadRefresh = NO;
    }
    if (isFootRefresh){
        [table footerEndRefreshing];
        isFootRefresh = NO;
    }
    if (istableFootRefresh) {
        [titleTable footerEndRefreshing];
        istableFootRefresh = NO;
    }
}
#pragma mark - 网络获取文章内容
-(void)initData
{
    BOOL isChangedCategry = [articleCategry isEqualToString:currentArticleCategry];
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",articleCategry,@"categoryId",[NSNumber numberWithInt:dataPage],@"pageIndex",@"10",@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        NSLog(@"%@",json);
        ArchiveList *list = [[ArchiveList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (dataPage == 1) {
                dataArray=(NSMutableArray*)list.msg.items;
                currentArticleCategry = articleCategry;
            }else{
                if (currentNextPageAry) {
                    [dataArray removeObjectsInArray:currentNextPageAry];
                    currentNextPageAry = nil;
                }
                [dataArray addObjectsFromArray:list.msg.items];
            }
            [table reloadData];
            dataPage++;
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [self showUploadView:erromodel.msg];
            if (!isChangedCategry) {
                currentArticleCategry = articleCategry;
                [dataArray removeAllObjects];
            }
            if (isDeleteAll) {
                [dataArray removeAllObjects];
            }
            [table reloadData];
        }
        [self endRefresh];
    } fail:^(id errors) {
        [self showUploadView:errors];
        if (!isChangedCategry) {
                currentArticleCategry = articleCategry;
                    [dataArray removeAllObjects];
            }
            if (isDeleteAll) {
                    [dataArray removeAllObjects];
            }
            [table reloadData];
        [self endRefresh];
    } cache:^(id cache) {
        ArchiveList *list = [[ArchiveList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (list.msg.items) {
                if (dataPage == 1) {
                    dataArray=(NSMutableArray*)list.msg.items;
                }else{
                    if (currentNextPageAry) {
                        [dataArray removeObjectsInArray:currentNextPageAry];
                        currentNextPageAry = nil;
                    }
                    [dataArray addObjectsFromArray:list.msg.items];
                    currentNextPageAry = (NSMutableArray *)list.msg.items;
                }
                [table reloadData];
            }
        }
    }];
}
#pragma mark - 网络获取文章分类列表
-(void)getArticleCategory
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveCategoryList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",[NSNumber numberWithInt:dataPage],@"pageIndex",@"5",@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        ArchiveCategoryList *list = [[ArchiveCategoryList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (tabeldataPage == 1) {
                titleArray=(NSMutableArray*)list.items;
            }else{
                [titleArray addObjectsFromArray:list.items];
            }
            [titleTable reloadData];
            [self dismiss];
            tabeldataPage++;
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            [titleTable reloadData];
            [self showUploadView:erromodel.msg];
        }
         [self endRefresh];
    } fail:^(id errors) {
        [titleTable reloadData];
        [self showUploadView:errors];
        [self endRefresh];
    } cache:^(id cache) {
        ArchiveCategoryList *list = [[ArchiveCategoryList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (tabeldataPage == 1) {
                titleArray=(NSMutableArray*)list.items;
            }else{
                [titleArray addObjectsFromArray:list.items];
            }
            [titleTable reloadData];
        }
    }];
}
#pragma mark - 判断是否具有权限
-(void)checkAuthority
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetAuthority",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:json error:nil];
        if (result.result == 1 ) {
            for (GetAuthorityItem *item in result.items) {
                if ([item.AuthDes isEqualToString:@"文章管理"] && item.IsOwn) {
                    isAuthority = YES;
                }
            }
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:cache error:nil];
        if (result.result == 1 ) {
            for (GetAuthorityItem *item in result.items) {
                if ([item.AuthDes isEqualToString:@"文章管理"] && item.IsOwn) {
                    isAuthority = YES;
                }
            }
        }
    }];

}
- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = YES;
}
@end

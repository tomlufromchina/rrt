//
//  DeskViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "DeskViewController.h"
#import "WebViewController.h"
#import "MyCollectionCell.h"
#import "ViewControllerIdentifier.h"

NSString *const cellIdentifier = @"cell";

@interface DeskViewController ()
{
    UserOfCombo *_combo;
    int _role;//角色
}

@property (nonatomic, strong) UICollectionView *colletionView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *highImageArray;
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *titleArray;


@end

@implementation DeskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"书桌";
    self.dataSource = [[NSMutableArray alloc] init];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self requestData];
    [self setupCollectionView];
    
}

/******套餐的获取请求*******/
- (void)requestData
{
    [self.netWorkManager getUserOfPackage:[RRTManager manager].loginManager.loginInfo.tokenId success:^(NSArray *data){
        [self dismiss];
        [self updateUI:data];
    } failed:^(NSString *errorMSG) {
//        [self showErrorWithStatus:errorMSG];
    }];

}

- (void)updateUI:(NSArray *)array
{
    _combo = array[0];
    //普通
    self.imageArray = [[NSMutableArray alloc] initWithObjects:@"icon_cjxt",@"icon_pakq",@"icon_bjwz",@"icon_bjdt", nil];
    //高亮
    self.highImageArray = [[NSMutableArray alloc] initWithObjects:@"icon_cjxt_press",@"icon_pakq_press",@"icon_bjwz_press",@"icon_bjdt_press", nil];
    //标题
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"成绩系统",@"看考勤",@"我的博文",@"班级动态", nil];
    
     _role = [[RRTManager manager].loginManager.loginInfo.userRole intValue];

    
    [self.colletionView reloadData];

}

/*****初始化collectionView****/
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 70);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 40, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    
    self.colletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:layout];
    [self.colletionView registerClass:[MyCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.colletionView.backgroundColor = [UIColor whiteColor];
    self.colletionView.dataSource = self;
    self.colletionView.delegate = self;
    [self.view addSubview:self.colletionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.titleImage.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleName.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.titleImage.highlightedImage = [UIImage imageNamed:self.highImageArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *VC = [[WebViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    if (indexPath.row == 0) {
        
        if (_role == 1 || _role == 4) {
            [self validateTheClicked];
        }
        
        if (_role == 2) {
            NSString *URL0 = @"http://pa3.aedu.cn/home/Login?url=http://pa3:8089/parent/pexamlist?pc=1";
                VC.URL = URL0;
                VC.title = @"成绩系统";
            [self.navigationController pushViewController:VC animated:YES];
        } else if (_role == 3){
            NSString *URL01 = @"http://pa3.aedu.cn/teacher/examlist?pc=1";
            VC.URL = URL01;
            VC.title = @"成绩系统";
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }else if (indexPath.row == 1){
        
        if (_role == 1 || _role == 4) {
            [self validateTheClicked];
        }
        
        if (_role == 2) {
            NSString *URL1 = @"http://pa3.aedu.cn/home/Login?url=http://pa3:8089/parent/CardRecive?pc=1";
            VC.URL = URL1;
            VC.title = @"看考勤";
            [self.navigationController pushViewController:VC animated:YES];
        } else if (_role == 3){
            NSString *URL11 = @"http://pa3.aedu.cn/teacher/TCardIndex?pc=1";
            VC.URL = URL11;
            VC.title = @"看考勤";
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }else if (indexPath.row == 2){
        NSString *str = [NSString stringWithFormat:@"http://v.aedu.cn/home/cm?key=blog&durl=http://home.aedu.cn/u/%@/Blog/Home",[RRTManager manager].loginManager.loginInfo.userId];
        NSString *URL2 = str;
        VC.URL = URL2;
        VC.title = @"我的博文";
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (indexPath.row == 3){
        NSString *URL3 = @"http://mclass.aedu.cn/";
        VC.URL = URL3;
        VC.title = @"班级动态";
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 4){
        
    }else if (indexPath.row == 5){
        
    }else if (indexPath.row == 6){
        
    }else if (indexPath.row == 7){
        
    }else if (indexPath.row == 8){
      
    }else if (indexPath.row == 9){
        
    }else if (indexPath.row == 10){
        
    }else if (indexPath.row == 11){
        
    }else if (indexPath.row == 12){
        
    }else if (indexPath.row == 13){
        
    }else if (indexPath.row == 14){
        
    }else if (indexPath.row == 15){
        
    }else if (indexPath.row == 16){
        
    }
}

- (BOOL)validateTheClicked
{
    [self showWithTitle:@"此功能针对家长和老师哦！" defaultStr:nil];
    return NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

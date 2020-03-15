//
//  DeskViewController.m
//  StoryBoard_Test
//
//  Created by 符其彬 on 14-9-24.
//  Copyright (c) 2014年 符其彬. All rights reserved.
//

#import "DeskViewController.h"
#import "WebViewController.h"
#import "NoNavViewController.h"
#import "ATTStatisticsViewController.h"
#import "ParentAttendViewController.h"
#import "TeacherAttendViewController.h"
#import "DeskCell.h"
#import "CommunicationGuardianViewController.h"
#import "AlbumList.h"
#import "ViewControllerIdentifier.h"


@interface DeskViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UserOfCombo *_combo;
    int _role;//角色
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *highImageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) int isPay;
@property (nonatomic, strong) NSUserDefaults *userDefaultes;

@property (nonatomic, strong) NSMutableArray *myClassListArray;//班级名


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
    _userDefaultes = [NSUserDefaults standardUserDefaults];
    _myClassListArray = [[NSMutableArray alloc] init];
    self.title = @"应用";
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    [self.mainCollectionView registerClass:[DeskCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    self.netWorkManager = [[NetWorkManager alloc] init];
    _role = [[RRTManager manager].loginManager.loginInfo.userRole intValue];
    
    [self initView];
//    [self requestData];
    [self requestTeacherRole];
}

- (void)initView
{
    [self setUpNavigation];
    self.titleLabel.text = @"应用";
    self.imageArray = [[NSMutableArray alloc] initWithObjects:@"icon_student_avaluate",@"xuanxk",@"xfxt",@"icon_cjxt-1",@"icon_pakq-1",@"通知书-",@"动态-",@"博文-",@"教育-",nil];
    //高亮
    self.highImageArray = [[NSMutableArray alloc] initWithObjects:@"icon_student_avaluate",@"xuanxk",@"xfxt",@"icon_cjxt-1",@"icon_pakq-1", @"通知书-",@"动态-",@"博文-",@"教育-",nil];
    //标题
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"学生评价",@"选修课",@"消费信息",@"成绩系统",@"平安考勤",@"期末通知书",@"班级动态",@"班级博文",@"教育资讯",nil];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(90, 90);
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 30, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    self.mainCollectionView.collectionViewLayout = layout;

    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT- 64 - 49) collectionViewLayout:layout];
    [self.mainCollectionView registerClass:[DeskCell class] forCellWithReuseIdentifier:@"DeskCell"];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollectionView];
}

#pragma mark -- 获取角色收费状态

- (void)requestTeacherRole
{
    [self.netWorkManager getPayUserRole:[RRTManager manager].loginManager.loginInfo.userId
                               userrole:[RRTManager manager].loginManager.loginInfo.userRole
                                success:^(int data) {
                                    [self updateUserInterFace:data];
                                } failed:^(NSString *errorMSG) {
                                    
                                }];
    
    // 获取班级列表
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetClassList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userRole,@"UserRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:json error:nil];
        if (list.result == 1) {
            self.myClassListArray = (NSMutableArray*)list.items;
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            self.myClassListArray = (NSMutableArray*)list.items;
        }
    }];

}

- (void)updateUserInterFace:(int)roleStr
{
    self.isPay = roleStr;
    [self.mainCollectionView reloadData];
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
    [self.mainCollectionView reloadData];
}
#pragma mark -- UICollectionView DelegeteAndDatasourceMethods
#pragma mark --
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageArray count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeskCell *mycell = (DeskCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DeskCell" forIndexPath:indexPath];
    mycell.menuImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    mycell.menuImageView.highlightedImage = [UIImage imageNamed:self.highImageArray[indexPath.row]];
    mycell.menuImageView.layer.masksToBounds = YES;
    mycell.menuImageView.layer.cornerRadius = mycell.menuImageView.width*0.5;
    mycell.menuName.text = [self.titleArray objectAtIndex:indexPath.row];
    mycell.menuName.font = [UIFont fontWithName:@"ArialMT" size:15.0f];
    //防止重用问题
//    UIView *emjoView = (UIView *)[mycell viewWithTag:103];
//    if (emjoView) {
//        [emjoView removeFromSuperview];
//    }
//    if (indexPath.row == 4) {
//        Brage1 *lxrbrage=[[Brage1 alloc] initWithImage:[UIImage imageNamed:@"numtips"] type:chengji1];
//        lxrbrage.left = 0;
//        lxrbrage.top = 5;
//        lxrbrage.tag = 103;
//        [mycell addSubview:lxrbrage];
//    }
    
    return mycell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
//    if (indexPath.row == 0) {
//        // 统计点击应用数量
//        
//        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:@"37" productId:@"5" version:theAppVersion success:^(NSString *data) {
//            
//        } failed:^(NSString *errorMSG) {
//            
//        }];
//        
//        if (_role == 2) {// 家长
//            if (self.isPay == 1) {
//                
//                [self.navigationController pushViewController:CommunicationGuardianVCID
//                                               withStoryBoard:DeskStoryBoardName withBlock:^(UIViewController *viewController) {
//                                                   CommunicationGuardianViewController *VC = (CommunicationGuardianViewController *)viewController;
//                                                   VC.headType = 0;
//                                               }];
//            } else if (self.isPay == 0){
//                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
//                
//            }
//            
//        } else if ( _role == 3 || _role == 4 || _role == 5 || _role == 6) {// 老师
//            [self.navigationController pushViewController:CommunicationTeacherVCID
//                                           withStoryBoard:DeskStoryBoardName withBlock:nil];
//            
//        } else if (_role == 1){// 学生
//            
//            [self.navigationController pushViewController:TheStudentsVCID
//                                           withStoryBoard:DeskStoryBoardName withBlock:nil];
//        }
//        
//    }
    if (indexPath.row == 0) {
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_OptionalCourse productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        
        NSString *theRole = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
        if ([theRole isEqualToString:@"1"]) {
            NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/assess?isApp=true",aedudomain];
            VC.URL = URL01;
            
            VC.title = @"学生评价";
            [self.navigationController pushViewController:VC animated:YES];
        } else if ([theRole isEqualToString:@"2"]){
//            if (self.isPay == 1) {
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/assess?isapp=true",aedudomain];
                VC.URL = URL01;
                VC.title = @"学生评价";
                [self.navigationController pushViewController:VC animated:YES];
//            } else if(self.isPay == 0){
//                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
//            }
            
        } else if ([theRole isEqualToString:@"3"] || [theRole isEqualToString:@"4"] || [theRole isEqualToString:@"5"] || [theRole isEqualToString:@"6"]){
            NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/assess/plan?isApp=true",aedudomain];
            VC.URL = URL01;
            VC.title = @"学生评价";
            [self.navigationController pushViewController:VC animated:YES];
        }

    }else if (indexPath.row == 1){
        // 统计点击应用数量
        
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_OptionalCourse productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        
        NSString *theRole = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
        if ([theRole isEqualToString:@"1"]) {
            NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/elective?isapp=true",aedudomain];
            VC.URL = URL01;
            
            VC.title = @"选修课";
            [self.navigationController pushViewController:VC animated:YES];
        } else if ([theRole isEqualToString:@"2"]){
            if (self.isPay == 1) {
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/elective?isapp=true",aedudomain];
                VC.URL = URL01;
                VC.title = @"选修课";
                [self.navigationController pushViewController:VC animated:YES];
            } else if(self.isPay == 0){
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
            }
            
        } else if ([theRole isEqualToString:@"3"] || [theRole isEqualToString:@"4"] || [theRole isEqualToString:@"5"] || [theRole isEqualToString:@"6"]){
            NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/elective?isapp=true",aedudomain];
            VC.URL = URL01;
            VC.title = @"选修课";
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        
    }else if (indexPath.row == 2){
        // 统计点击应用数量
        
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_CosumptionInfo productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        
        NSString *theRole = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
        if (self.isPay == 1) {
            if ([theRole isEqualToString:@"1"]) {
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/consume?isapp=true",aedudomain];
                VC.URL = URL01;
            } else if ([theRole isEqualToString:@"2"]){
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/consume?isapp=true",aedudomain];
                VC.URL = URL01;
            } else if ([theRole isEqualToString:@"3"] || [theRole isEqualToString:@"4"] || [theRole isEqualToString:@"5"] || [theRole isEqualToString:@"6"]){
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/consume/index?isapp=true",aedudomain];
                VC.URL = URL01;
            }
            VC.title = @"消费系统";
            [self.navigationController pushViewController:VC animated:YES];
            
        } else if(self.isPay == 0){
            if ([theRole isEqualToString:@"3"] || [theRole isEqualToString:@"4"] || [theRole isEqualToString:@"5"] || [theRole isEqualToString:@"6"]){
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/consume/index?isapp=true",aedudomain];
                VC.URL = URL01;
                VC.title = @"消费系统";
                [self.navigationController pushViewController:VC animated:YES];
            } else{
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
            }
        }
        
    }else if (indexPath.row == 3){
        // 统计点击应用数量
        
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_ResultSystem productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        if (_role == 1) {
            // 判断试用期：
            if (self.isPay == 1) {
                NSString *URL0 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/exam?isapp=true",aedudomain];
                VC.URL = URL0;
                VC.title = @"成绩系统";
                [self.navigationController pushViewController:VC animated:YES];
            } else if(self.isPay == 0){
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
                
                
            }
        } else if (_role == 2) {
            if (self.isPay == 1) {
                NSString *URL0 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/exam?isapp=true",aedudomain];
                VC.URL = URL0;
                VC.title = @"成绩系统";
                [self.navigationController pushViewController:VC animated:YES];
                
            } else if (self.isPay == 0){
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
                
            }
            
        } else if (_role == 3 || _role == 4){
            NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/exam/index?isapp=true",aedudomain];
            VC.URL = URL01;
            VC.title = @"成绩系统";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else if (indexPath.row == 4){
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_SafeChecking productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        
        if (_role == 1) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"此功能针对家长和老师哦！"];
            
        }
        if (_role == 2) {
            
            if (self.isPay == 1) {
                NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/parent/card?isapp=true",aedudomain];
                VC.URL = URL01;
                VC.title = @"平安考勤";
                [self.navigationController pushViewController:VC animated:YES];
            } else if (self.isPay == 0){
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"您的服务功能已到期，请您续交费用才能使用该功能哦！"];
                
            }
        } else if (_role == 3 || _role == 4){
            NSString *URL01 = [NSString stringWithFormat:@"http://phoneweb.%@/teacher/swing/default?isapp=true",aedudomain];
            VC.URL = URL01;
            VC.title = @"考勤记录";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else if (indexPath.row == 5){
        
        // 统计点击应用数量
        
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_TerminalAdviceNote productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        
        WebViewController *wvc = [[WebViewController alloc] init];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:nil
                                                                    action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];

        NSString *theRole = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
        if ([theRole isEqualToString:@"1"]) {
            NSString *myURL = [_userDefaultes stringForKey:@"TheURL2"];
            if (myURL != nil) {
                NSString *str = [NSString stringWithFormat:@"%@%@",myURL,[RRTManager manager].loginManager.loginInfo.tokenId];
                NSString *URL2 = str;
                wvc.URL = URL2;
            } else{
                
                NSString *str = [NSString stringWithFormat:@"http://v.%@/AdviceNote/10001300019/%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId];// 没推送默认
                NSString *URL2 = str;
                wvc.URL = URL2;
            }
            [self.navigationController pushViewController:wvc animated:YES];
            
        } else if ([theRole isEqualToString:@"2"]){
            NSString *myURL = [_userDefaultes stringForKey:@"TheURL"];
            if (myURL != nil) {
                NSString *str = [NSString stringWithFormat:@"%@%@",myURL,[RRTManager manager].loginManager.loginInfo.tokenId];
                NSString *URL2 = str;
                wvc.URL = URL2;
            } else{
                
                NSString *str = [NSString stringWithFormat:@"http://v.%@/AdviceNote/10001300019/%@",aedudomain,[RRTManager manager].loginManager.loginInfo.tokenId];// 没推送默认静态
                NSString *URL2 = str;
                wvc.URL = URL2;
            }
            [self.navigationController pushViewController:wvc animated:YES];
            
        } else if ([theRole isEqualToString:@"3"] || [theRole isEqualToString:@"4"] || [theRole isEqualToString:@"5"] || [theRole isEqualToString:@"6"]){
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"期末通知书只针对学生和家长！"];
        }
        wvc.title = @"期末通知书";
        
    }else if (indexPath.row == 6){
        // 统计点击应用数量
        
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_ClassActivity productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        if ([self.myClassListArray count] > 0) {
            // 判断试用期：
            [self.navigationController pushViewController:MyClassVCID
                                           withStoryBoard:DiscoverStoryBoardName withBlock:nil];
        } else{
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"你还没加入任何班级哦！"];
        }
        
//        WebViewController *wvc = [[WebViewController alloc] init];
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
//                                                                     style:UIBarButtonItemStylePlain
//                                                                    target:nil
//                                                                    action:nil];
//        [self.navigationItem setBackBarButtonItem:backItem];
//
//        NSString *URL3 = [NSString stringWithFormat:@"http://mclass.%@/",aedudomain];
//        wvc.URL = URL3;
//        wvc.title = @"班级动态";
//        [self.navigationController pushViewController:wvc animated:YES];
        
    }else if (indexPath.row == 7){
        // 统计点击应用数量
        
        [self.netWorkManager getBrowseNumber:[RRTManager manager].loginManager.loginInfo.userId ppId:A_ClassArticle productId:@"5" version:theAppVersion success:^(NSString *data) {
            
        } failed:^(NSString *errorMSG) {
            
        }];
        
        WebViewController *wvc = [[WebViewController alloc] init];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:nil
                                                                    action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];

        NSString *str = [NSString stringWithFormat:@"http://v.%@/home/cm?key=blog&durl=http://home.%@/u/%@/Blog/Home",aedudomain,aedudomain,[RRTManager manager].loginManager.loginInfo.userId];
        NSString *URL2 = str;
        wvc.URL = URL2;
        wvc.title = @"班级博文";
        [self.navigationController pushViewController:wvc animated:YES];
        
    }else if (indexPath.row == 8){
        NSString *URL0 = [NSString stringWithFormat:@"http://www.%@/MoblieNews",aedudomain];;
        VC.URL = URL0;
        VC.title = @"教育资讯";
        [self.navigationController pushViewController:VC animated:YES];
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
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"此功能针对家长和老师哦！"];

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

@end

//
//  ModificationViewController.m
//  RenrenTong
//
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ModificationViewController.h"
#import "EditViewController.h"
#import "ModificationCell.h"
#import "ModificationHeaderCell.h"
#import "ModificationFoortCell.h"

#import "QBImagePickerController.h"
#import "ASIFormDataRequest.h"
#import "UIImage+Addition.h"
#import "PersonModel.h"

@interface ModificationViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,ASIHTTPRequestDelegate>

{
    PersonailInformationList *dataDetails;
    NSArray *sexArray;
    
}

@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, assign) NSInteger buttonIdenx;
@property (nonatomic, assign) NSInteger buttonIdenx1;

@property(nonatomic, strong)ASIFormDataRequest *request;
@property (nonatomic, strong) NSMutableArray *zoneArray;
@property (strong, nonatomic) UIImage *userface;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ModificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改资料";
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.zoneArray = [NSMutableArray array];
    self.images = [NSMutableArray array];

    [self requestData];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

}

- (void)gotoMainUI
{
    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 数据请求
- (void)requestData
{
    [self showWithStatus:@""];
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/GetUserById", aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.tokenId],@"ToKen",[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"UserId",nil];

    [HttpUtil GetWithUrl:requestUrl
              parameters:dic
                 success:^(id json) {
                     PersonailInformation *obj = [[PersonailInformation alloc] initWithString:json error:nil];
                     if (obj.st == 0) {
                         [self dismiss];
                         [self gotoUpateUI:obj.msg.list];
                     } else{
                         
                     }
                 } fail:^(id error) {
                     [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:error];
                 } cache:^(id cache) {
                     
                 }];
    [self.netWorkManager getZoneSerialNumbersuccess:^(NSMutableArray *friendDynamic) {
        
        [self zoneData:friendDynamic];
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
    }];
}
#pragma mark -- 获取地区编号数据
- (void)zoneData:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            [self.zoneArray addObject:[data[i] objectForKey:@"AreaCode"]];
        }
    }
}


- (void)gotoUpateUI:(PersonailInformationList *)MD
{
    if (MD) {
        dataDetails = MD;
    }
    [self.mainTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else if(section == 1){
        return 20;
    } else {
        return 20;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 7;
        case 2:
            return 3;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"基本信息";
            break;
        case 2:
            return @"其他";
            break;
            
        default:
            return @"";
            break;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 40.0f;
    if (indexPath.section == 1) {
        height = 40.0f;
    } else if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 2){
        height = 40;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"ModificationHeaderCell";
        ModificationHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ModificationHeaderCell" owner:self options:nil] lastObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UIImageView *hearderView = (UIImageView *)[cell viewWithTag:101];
        
        [hearderView.layer setMasksToBounds:YES];
        hearderView.layer.cornerRadius = 2.0;
        hearderView.layer.cornerRadius = 2.0;
        hearderView.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
        hearderView.layer.cornerRadius = 10;
        [hearderView setImageWithURL:[NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
        
        UIImageView *titleIMG = (UIImageView *)[cell viewWithTag:102];
        titleIMG.hidden = NO;
        
        return cell;
        
    } else if(indexPath.section == 1){
        static NSString *cellIdentifier = @"ModificationCell";
        ModificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ModificationCell" owner:self options:nil] lastObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        UILabel *label1 = (UILabel *)[cell viewWithTag:2];
        UIImageView *titleIMG = (UIImageView *)[cell viewWithTag:8];
        if (indexPath.row == 0) {
            label.text = @"昵称:";
            label1.text = dataDetails.NickName;
            
        } else if (indexPath.row == 1){
            label.text = @"姓名:";
            titleIMG.hidden = YES;
            label1.text = dataDetails.TrueName;
        } else if (indexPath.row == 2){
            label.text = @"性别:";
            if (dataDetails.Sex == 0) {
                label1.text = @"女";
            } else if ([dataDetails.Sex isEqualToString:@"1"]){
                label1.text = @"男";
            }
        } else if (indexPath.row == 3){
            label.text = @"地区:";
            label1.text = dataDetails.NowAreaCode;
        } else if (indexPath.row == 4){
            label.text = @"生日:";
            label1.text = dataDetails.Birthday;
        } else if (indexPath.row == 5){
            label1.text = dataDetails.Introduction;
            label.text = @"简介:";
        } else{
            label.text = @"密码:";
            label1.text = @"******";
        }
        return cell;
    } else {
        static NSString *cellIdentifier = @"ModificationFoortCell";
        ModificationFoortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ModificationFoortCell" owner:self options:nil] lastObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UILabel *label = (UILabel *)[cell viewWithTag:3];
        UILabel *label1 = (UILabel *)[cell viewWithTag:4];
        
        if (indexPath.row == 0) {
            label.text = @"邮箱:";
            label1.text = dataDetails.AccountEmail;
            
        } else if (indexPath.row == 1){
            label.text = @"QQ:";
            label1.text = dataDetails.QQ;
        } else{
            label.text = @"手机:";
            label1.text = dataDetails.AccountMobile;
        }
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.buttonIdenx = indexPath.row;
    self.buttonIdenx1 = indexPath.section;
    if (indexPath.section == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"从相册选取", @"拍照", nil];
        
        [sheet showInView:self.view];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:1];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            [self.navigationController pushViewController:EditVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    EditViewController *VC = (EditViewController *)viewController;
                                                    VC.content = label.text;
                                                    VC.titleUI = @"4 - 30个字符，可输入中文、英文、数字。";
                                                    VC.titleName = @"编辑昵称";
                                                    __block ModificationViewController *_self = self;
                                                    CommonSuccessBlock block = ^(void){
                                                        [_self requestData];
                                                    };
                                                    
                                                    VC.block = block;
                                                }];
            
            
        } else if (indexPath.row == 1){
            // 姓名不能修改
        } else if (indexPath.row == 2){
            
            UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
            sexArray = @[@"男",@"女"];
            for(int i=0;i<[sexArray count];i++)
            {
                NSString *str=[sexArray objectAtIndex:i];
                [sheet addButtonWithTitle:str];
            }
            [sheet addButtonWithTitle:@"取消"];
            sheet.cancelButtonIndex=[sexArray count];
            [sheet showInView:self.view];
            
        } else if (indexPath.row == 3){
            
            TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"" delegate:self];
            [locateView showInView:self.view];
            
        }else if (indexPath.row == 4){
            
            [self showDateAlertWithTag:888];
            
        }else if (indexPath.row == 5){
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:5 inSection:1];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            [self.navigationController pushViewController:EditVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    EditViewController *VC = (EditViewController *)viewController;
                                                    VC.content = label.text;
                                                    VC.titleUI = @"最多可输入140个字符哦。";
                                                    VC.titleName = @"编辑简介";
                                                    
                                                    __block ModificationViewController *_self = self;
                                                    CommonSuccessBlock block = ^(void){
                                                        [_self requestData];
                                                    };
                                                    
                                                    VC.block = block;
                                                    
                                                }];
            
        } else{
            NSLog(@"修改你想要的密码");
            
            [self.navigationController pushViewController:ChangePasswordVCTD
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:nil];
        }
    } else {
        
        if (indexPath.row == 0) {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:2];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:4];
            [self.navigationController pushViewController:EditVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    EditViewController *VC = (EditViewController *)viewController;
                                                    VC.content = label.text;
                                                    VC.titleUI = @"例如：zhang123@aedu.cn";
                                                    VC.titleName = @"编辑邮箱";
                                                    
                                                    __block ModificationViewController *_self = self;
                                                    CommonSuccessBlock block = ^(void){
                                                        [_self requestData];
                                                    };
                                                    
                                                    VC.block = block;
                                                }];
            
            
            
        } else if (indexPath.row == 1){
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:1 inSection:2];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:4];
            [self.navigationController pushViewController:EditVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    EditViewController *VC = (EditViewController *)viewController;
                                                    VC.content = label.text;
                                                    VC.titleUI = @"例如：615800342";
                                                    VC.titleName = @"编辑QQ";
                                                    
                                                    __block ModificationViewController *_self = self;
                                                    CommonSuccessBlock block = ^(void){
                                                        [_self requestData];
                                                    };
                                                    
                                                    VC.block = block;
                                                    
                                                }];
            
        } else {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:2 inSection:2];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:4];
            [self.navigationController pushViewController:EditVCID
                                           withStoryBoard:SettingStoryBoardName
                                                withBlock:^(UIViewController *viewController) {
                                                    EditViewController *VC = (EditViewController *)viewController;
                                                    VC.content = label.text;
                                                    VC.titleUI = @"例如：15982050498";
                                                    VC.titleName = @"编辑手机";
                                                    
                                                    __block ModificationViewController *_self = self;
                                                    CommonSuccessBlock block = ^(void){
                                                        [_self requestData];
                                                    };
                                                    
                                                    VC.block = block;
                                                    
                                                }];
            
        }
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIActionSheet delegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.buttonIdenx1 == 0 && self.buttonIdenx == 0) {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.videoQuality=UIImagePickerControllerQualityTypeLow;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];

        } else if (buttonIndex == 1){
            //拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.videoQuality=UIImagePickerControllerQualityTypeLow;
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
            }else
            {
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"该设备不支持拍照"];

            }
        }
        
    } else if (self.buttonIdenx1 == 1 && self.buttonIdenx == 2){
        if (buttonIndex<[sexArray count]) {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:2 inSection:1];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            if (cell) {
                NSString *str = [sexArray objectAtIndex:buttonIndex];
                label.text = str;
            }
            
            
            if (buttonIndex == 0) {
                NSString *str = [NSString stringWithFormat:@"Gender=%@",@"1"];
                [self dismiss];
                [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                              modificationType:str
                                                       success:^(NSDictionary *friendDynamic) {
                                                           [self dismiss];
                                                           [self gotoMainUI:friendDynamic];
                                                           
                                                       } failed:^(NSString *errorMSG) {
                                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                           
                                                       }];
                
            } else{
                NSString *str = [NSString stringWithFormat:@"Gender=%@",@"2"];
                [self dismiss];
                [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                              modificationType:str
                                                       success:^(NSDictionary *friendDynamic) {
                                                           [self dismiss];
                                                           [self gotoMainUI:friendDynamic];
                                                           
                                                       } failed:^(NSString *errorMSG) {
                                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                           
                                                       }];
                
            }
            
        }
      // 选择地区
    }else if (self.buttonIdenx1 == 1 && self.buttonIdenx == 3){
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        TSLocation *location = locateView.locate;
        NSLog(@"country:%@ city:%@ district:%@ lat:%f lon:%f",location.state, location.city, location.district,location.latitude, location.longitude);
        
        //获取cell上的label
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:3 inSection:1];
        UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%@-%@",location.state,location.city];
        if(buttonIndex == 0) {
            [locateView removeFromSuperview];
            label.text = dataDetails.NowAreaCode;
        }else {
            
            if ([location.state isEqualToString:@"北京市"]) {
                if ([location.city isEqualToString:@"东城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010100"];
                    [self saveArea:str];
                } else if ([location.city isEqualToString:@"西城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010200"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"崇文"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010300"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宣武"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010400"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"朝阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010500"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"丰台"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010600"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"石景山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010700"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"海淀"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010800"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"门头沟"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11010900"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"房山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011100"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"通州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011200"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"顺义"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011300"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"昌平"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011400"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"大兴"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011500"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"怀柔"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011600"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"平谷"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11011700"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"密云"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11022800"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"延庆县"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"11022900"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"天津市"]){
                if ([location.city isEqualToString:@"蓟县"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12022500"];
                    [self saveArea:str];
                } else if ([location.city isEqualToString:@"静海"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12022300"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宁河"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12022100"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宝坻"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12011500"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"武清"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12011400"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"北辰"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12011300"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"津南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12011200"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"西青"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12011100"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"东丽"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12011000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"大港"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010900"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"汉沽"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010800"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"塘沽"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010700"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"红桥"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010600"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"河北"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010500"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"南开"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010400"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"河西"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010300"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"河东"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010200"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"和平"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"12010100"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"河北省"]){
                if ([location.city isEqualToString:@"石家庄"]){
                    if ([location.district isEqualToString:@"长安区"]) {
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13010200"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"桥东区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13010300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"桥西区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13010400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"新华区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13010500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"井陉矿区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13010700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"裕华区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13010800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"井陉县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"正定县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"栾城县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"行唐县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"灵寿县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"高邑县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"深泽县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"赞皇县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13012900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"无极县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13013000"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"平山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13013100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"元氏县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13013200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"赵县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13013300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"辛集市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13018100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"藁城市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13018200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"晋州市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13018300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"新乐市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13018400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"鹿泉市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13018500"];
                        [self saveArea:str];
                    }
                }else if ([location.city isEqualToString:@"唐山"]){
                    if ([location.district isEqualToString:@"路南区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13020200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"路北区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13020300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"古冶区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13020400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"开平区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13020500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"丰南区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13020700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"丰润区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13020800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"滦县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13022300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"滦南县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13022400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"乐亭县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13022500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"迁西县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13022700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"玉田县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13022900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"唐海县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13023000"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"遵化市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13028100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"迁安市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13028300"];
                        [self saveArea:str];
                    }
                }else if ([location.city isEqualToString:@"秦皇岛"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"邯郸"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"邢台"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"保定"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"张家口"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"承德"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"沧州"]){
                    if ([location.district isEqualToString:@"新华区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13090200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"运河区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13090300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"沧县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13092100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"青县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13092200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"东光县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13092300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"海兴县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13092400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"泊头市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13098100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"献县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13092900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"任丘市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13098200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"黄骅市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13098300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"河间市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13098400"];
                        [self saveArea:str];
                    } else{
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13090000"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"廊坊"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"衡水"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"13110000"];
                    [self saveArea:str];
                }

                
            } else if ([location.state isEqualToString:@"山西省"]){
                if ([location.city isEqualToString:@"太原"]){
                    if ([location.district isEqualToString:@"小店区"]) {
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14010500"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"迎泽区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14010600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"古交市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14018100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"杏花岭区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14010700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"尖草坪区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14010800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"万柏林区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14010900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"晋源区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14011000"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"清徐县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14012100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"阳曲县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14012200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"娄烦县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14012300"];
                        [self saveArea:str];
                    }
                }else if ([location.city isEqualToString:@"大同"]){
                    if ([location.city isEqualToString:@"城区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14020200"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"矿区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14020300"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"南郊区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14021100"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"新荣区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14021200"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"阳高县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022100"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"天镇县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022200"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"广灵县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022300"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"灵丘县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022400"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"浑源县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022500"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"左云县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022600"];
                        [self saveArea:str];
                    }else if ([location.city isEqualToString:@"大同县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14022700"];
                        [self saveArea:str];
                    }
                }else if ([location.city isEqualToString:@"阳泉"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"长治"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"晋城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"朔州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"晋中"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"运城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"忻州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"临汾"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"吕梁"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"14110000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"内蒙古自治区"]){
                if ([location.city isEqualToString:@"呼和浩特"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"包头"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"乌海"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"赤峰"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"通辽"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"鄂尔多斯"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"呼伦贝尔"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"巴彦淖尔"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"乌兰察布"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"兴安盟"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15220000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"锡林郭勒"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15250000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"阿拉善盟"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"15290000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"辽宁省"]){
                if ([location.city isEqualToString:@"沈阳市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"大连市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21020000"];
                    [self saveArea:str];
                }if ([location.city isEqualToString:@"鞍山市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"抚顺市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21040000"];
                    [self saveArea:str];
                }if ([location.city isEqualToString:@"本溪市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"丹东市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21060000"];
                    [self saveArea:str];
                }if ([location.city isEqualToString:@"锦州市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"营口市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21080000"];
                    [self saveArea:str];
                }if ([location.city isEqualToString:@"阜新市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"辽阳市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21100000"];
                    [self saveArea:str];
                }if ([location.city isEqualToString:@"盘锦市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"铁岭市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21120000"];
                    [self saveArea:str];
                }if ([location.city isEqualToString:@"朝阳市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21130000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"葫芦岛市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"21140000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"吉林省"]){
                if ([location.city isEqualToString:@"长春市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"吉林市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"延边朝鲜"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22240000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"四平市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"辽源市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"通化市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"白山市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"松原市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"白城市"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22080000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"黑龙江省"]){
                if ([location.city isEqualToString:@"哈尔滨"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"齐齐哈尔"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"鸡西"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"鹤岗"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"大庆"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"伊春"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"佳木斯"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"七台河"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"牡丹江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"黑河"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"绥化"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23120000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"大兴安岭地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"22080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"双鸭山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"23050000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"上海市"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"31000000"];
                [self saveArea:str];
                
            } else if ([location.state isEqualToString:@"江苏省"]){
                if ([location.city isEqualToString:@"南京"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"无锡"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"徐州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"常州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"苏州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"南通"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"连云港"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"淮安"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"盐城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"扬州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"镇江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"泰州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32120000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宿迁"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"32130000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"浙江省"]){
                if ([location.city isEqualToString:@"杭州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宁波"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"温州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"嘉兴"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"湖州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"绍兴"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"金华"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"衢州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"舟山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"台州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"丽水"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"33110000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"安徽省"]){
                if ([location.city isEqualToString:@"合肥"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"芜湖"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"蚌埠"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"淮南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"马鞍山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"淮北"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"铜陵"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"安庆"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"黄山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"滁州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"阜阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34120000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宿州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34130000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"巢湖"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34140000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"六安"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34150000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"亳州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34160000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"池州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34170000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宣城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"34180000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"福建省"]){
                if ([location.city isEqualToString:@"福州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"厦门"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"莆田"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"三明"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"泉州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"漳州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"南平"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"龙岩"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宁德"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"35090000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"江西省"]){
                if ([location.city isEqualToString:@"南昌"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"景德镇"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"萍乡"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"九江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"新余"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"鹰潭"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"赣州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"吉安"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宜春"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"抚州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"上饶"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"36110000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"山东省"]){
                if ([location.city isEqualToString:@"济南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"青岛"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"淄博"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"枣庄"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"东营"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"烟台"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"潍坊"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"济宁"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"泰安"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"威海"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"日照"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"莱芜"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37120000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"临沂"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37130000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"德州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37140000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"聊城"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37150000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"滨州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37160000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"菏泽"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"37170000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"河南省"]){
                if ([location.city isEqualToString:@"郑州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"开封"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"洛阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"平顶山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41040000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"安阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"鹤壁"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"新乡"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"焦作"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"濮阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"许昌"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"漯河"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"三门峡"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41120000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"南阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41130000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"商丘"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41140000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"信阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41150000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"周口"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41160000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"驻马店"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"41170000"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"湖北省"]){
                if ([location.city isEqualToString:@"武汉"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42010000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"黄石"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42020000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"十堰"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"宜昌"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42050000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"襄樊"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"鄂州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42070000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"荆门"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42080000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"孝感"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42090000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"荆州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"黄冈"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42110000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"咸宁"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42120000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"随州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42130000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"恩施"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42280000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"神农架林"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42900000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"仙桃"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"42900400"];
                    [self saveArea:str];
                }
                
            } else if ([location.state isEqualToString:@"湖南省"]){
                if ([location.city isEqualToString:@"长沙"]){
                    if ([location.district isEqualToString:@"芙蓉区"]) {
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43010200"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"天心区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43010300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"岳麓区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43010400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"开福区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43010500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"雨花区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43011100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"长沙县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43012100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"望城县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43012200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"宁乡县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43012400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"浏阳市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43018100"];
                        [self saveArea:str];
                    }
                    
                } else if ([location.city isEqualToString:@"株洲"]){
                    if ([location.district isEqualToString:@"荷塘市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43020200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"芦淞区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43020300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"石峰区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43020400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"天元区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43021100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"株洲县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43022100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"攸县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43022300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"茶陵县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43022400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"炎陵县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43022500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"醴陵市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43028100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"邵阳"]){
                    if ([location.district isEqualToString:@"双清区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43050200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"大祥区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43050300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"北塔区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43051100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"邵东县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"新邵县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"邵阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"隆回县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"洞口县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"绥宁县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"新宁县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"城步苗族自治县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"武冈市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43058100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"衡阳"]){
                    if ([location.district isEqualToString:@"珠晖区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43040500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"雁峰区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43040600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"石鼓区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43040700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"蒸湘区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43040800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"南岳区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43041200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"衡阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43042100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"衡南县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43042200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"衡山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43042300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"衡东县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43042400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"祁东县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43042600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"耒阳市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43048100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"常宁市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43048200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"湘潭"]){
                    if ([location.district isEqualToString:@"雨湖区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43030200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"岳塘区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43030400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"湘潭县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43032100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"湘乡市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43038100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"韶山市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43038200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"岳阳"]){
                    if ([location.district isEqualToString:@"岳阳楼区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43060200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"云溪区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43060300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"君山区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43061100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"岳阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43062100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"华容县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43062300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"湘阴县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43062400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"平江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43062600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"汨罗市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43068100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"临湘市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43068200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"益阳"]){
                    if ([location.district isEqualToString:@"资阳区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43090200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"赫山区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43090300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"南县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43092100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"桃江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43092200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"安化县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43092300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"沅江市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43098100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"娄底"]){
                    if ([location.district isEqualToString:@"娄星区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43130200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"双峰县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43132100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"新化县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43132200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"冷水江市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43138100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"涟源市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43138200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"怀化"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43120000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"永州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43110000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"张家界"]){
                    if ([location.district isEqualToString:@"永定区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43080200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"武陵源区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43081100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"慈利县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43082100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"桑植县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43082200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"郴州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43100000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"湘西土家族苗族"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43310000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"邵阳"]){
                    if ([location.district isEqualToString:@"双清区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43050200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"大祥区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43050300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"北塔区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43051100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"邵东县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"新邵县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"邵阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"隆回县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"洞口县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43052500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"武冈市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43058100"];
                        [self saveArea:str];
                    } else{
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43050000"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"常德"]){
                    if ([location.district isEqualToString:@"武陵区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43070200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"鼎城区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43070300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"安乡县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43072100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"汉寿县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43072200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"澧县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43072300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"临澧县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43072400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"桃源县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43072500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"石门县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43072600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"津市市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"43078100"];
                        [self saveArea:str];
                    }
                    
                }
                
                
            } else if ([location.state isEqualToString:@"广东省"]){
                if ([location.city isEqualToString:@"广州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44010000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"韶关"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44020000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"深圳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44030000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"珠海"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44040000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"汕头"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44050000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"佛山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44060000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"江门"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44070000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"湛江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44080000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"茂名"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44090000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"肇庆"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44120000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"惠州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44130000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"梅州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44140000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"汕尾"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44150000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"河源"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44160000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"阳江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44170000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"清远"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44180000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"东莞"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44190000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"中山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44200000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"潮州"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44510000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"揭阳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44520000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"云浮"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"44530000"];
                    [self saveArea:str];
                    
                }
                
                
            } else if ([location.state isEqualToString:@"广西省"]){
                if ([location.city isEqualToString:@"南宁"]) {
                    if ([location.district isEqualToString:@"兴宁区"]) {
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45010200"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"青秀区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45010300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"江南区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45010500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"西乡塘区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45010700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"良庆区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45010800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"邕宁区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45010900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"武鸣县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45012200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"隆安县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45012300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"马山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45012400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"上林县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45012500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"宾阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45012600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"横县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45012700"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"柳州"]){
                    if ([location.district isEqualToString:@"城中区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45020200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"鱼峰区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45020300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"三江侗族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45022600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"柳南区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45020400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"柳北区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45020500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"柳江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45022100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"柳城县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45022200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"鹿寨县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45022300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"融安县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45022400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"融水苗族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45022500"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"桂林"]){
                    if ([location.district isEqualToString:@"秀峰区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45030200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"叠彩区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45030300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"象山区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45030400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"七星区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45030500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"雁山区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45031100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"阳朔县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"临桂县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"灵川县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"全州县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"兴安县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"永福县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032600"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"灌阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032700"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"龙胜各族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032800"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"资源县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45032900"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"平乐县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45033000"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"荔蒲县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45033100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"恭城瑶族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45033200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"梧州"]){
                    if ([location.district isEqualToString:@"万秀区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45040300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"蝶山区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45040400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"长洲区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45040500"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"苍梧县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45042100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"藤县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45042200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"蒙山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45042300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"岑溪市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45048100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"北海"]){
                    if ([location.district isEqualToString:@"海城区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45050200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"银海区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45050300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"铁山港区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45051200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"合浦县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45052100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"防城港"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45060000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"钦州"]){
                    if ([location.district isEqualToString:@"钦南区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45070200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"钦北区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45070300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"灵山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45072100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"浦北县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45072200"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"贵港"]){
                    if ([location.district isEqualToString:@"港北区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45080200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"港南区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45080300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"覃塘区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45080400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"平南县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45082100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"桂平市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45088100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"玉林"]){
                    if ([location.district isEqualToString:@"玉州区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45090200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"容县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45092100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"陆川县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45092200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"博白县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45092300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"兴业县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45092400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"北流市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45098100"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"百色"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45100000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"贺州"]){
                    if ([location.district isEqualToString:@"八步区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45110200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"昭平县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45112100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"钟山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45112200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"富川瑶族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45112300"];
                        [self saveArea:str];
                    }
                    
                }else if ([location.city isEqualToString:@"河池"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45120000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"来宾"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45130000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"崇左"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"45140000"];
                    [self saveArea:str];
                }
                
                
            } else if ([location.state isEqualToString:@"海南省"]){
                if ([location.city isEqualToString:@"海口"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"46010000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"三亚"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"46020000"];
                    [self saveArea:str];
                    
                }
                
            } else if ([location.state isEqualToString:@"重庆市"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"50000000"];
                [self saveArea:str];
                
            } else if ([location.state isEqualToString:@"四川省"]){
                if ([location.city isEqualToString:@"成都"]) {
                    if ([location.district isEqualToString:@"成华区"]) {
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51010800"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"锦江区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51010400"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"青羊区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51010500"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"金牛区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51010600"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"武侯区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51010700"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"高新区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51010900"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"龙泉驿区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51011200"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"青白江区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51011300"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"温江区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51011500"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"新都区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51011400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"金堂县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51012100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"双流县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51012200"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"郫县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51012400"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"大邑县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51012900"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"蒲江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51013100"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"新津县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51013200"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"都江堰市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51018100"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"彭州市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51018200"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"邛崃市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51018300"];
                        [self saveArea:str];
                        
                    } else if ([location.district isEqualToString:@"崇州市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51018400"];
                        [self saveArea:str];
                        
                    }
                    
                } else if ([location.city isEqualToString:@"宜宾"]){
                    if ([location.district isEqualToString:@"翠屏区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51150200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"宜宾县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"南溪县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"江安县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"长宁县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"高县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"珙县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"筠连县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152700"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"兴文县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152800"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"屏山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51152900"];
                        [self saveArea:str];
                        
                    }

                    
                }else if ([location.city isEqualToString:@"自贡"]){
                    if ([location.district isEqualToString:@"自流井区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51030200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"贡井区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51030300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"大安区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51030400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"沿滩区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51031100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"荣县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51032100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"富顺县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51032200"];
                        [self saveArea:str];
                        
                    }
                    
                } else if ([location.city isEqualToString:@"攀枝花"]){
                    if ([location.district isEqualToString:@"东区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51040200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"西区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51040300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"仁和区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51041100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"米易县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51042100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"盐边县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51042200"];
                        [self saveArea:str];
                        
                    }
                    
                } else if ([location.city isEqualToString:@"泸州"]){
                    if ([location.district isEqualToString:@"江阳区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51050200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"纳溪区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51050300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"龙马潭区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51050400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"泸县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51052100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"合江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51052200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"叙永县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51052400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"古蔺县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51052500"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"德阳"]){
                    if ([location.district isEqualToString:@"旌阳区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51060300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"中江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51062300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"罗江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51062600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"绵竹市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51068300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"广汉市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51068100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"什邡市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51068200"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"绵阳"]){
                    if ([location.district isEqualToString:@"盐亭县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51072300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"安县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51072400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"游仙区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51070400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"三台县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51072200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"涪城区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51070300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"北川羌族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51072600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"梓潼县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51072500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"江油市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51078100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"平武县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51072700"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"广元"]){
                    if ([location.district isEqualToString:@"元坝区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51081100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"市中区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51080200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"旺苍县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51082100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"朝天区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51081200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"苍溪县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51082400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"剑阁县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51082300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"青川县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51082200"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"遂宁"]){
                    if ([location.district isEqualToString:@"船山区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51090300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"安居区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51090400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"蓬溪县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51092100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"射洪县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51092200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"大英县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51092300"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"内江"]){
                    if ([location.district isEqualToString:@"隆昌县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51102800"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"资中县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51102500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"威远县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51102400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"市中区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51100200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"东兴区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51101100"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"乐山"]){
                    if ([location.district isEqualToString:@"峨眉山市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51118100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"马边彝族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51113300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"峨边彝族"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51113200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"市中区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51110200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"沙湾区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51111100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"五通桥区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51111200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"金口河区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51111300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"犍为县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51112300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"井研县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51112400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"夹江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51112600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"沐川县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51112900"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"南充"]){
                    if ([location.district isEqualToString:@"高坪区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51130300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"顺庆区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51130200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"南部县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51132100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"嘉陵区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51130400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"蓬安县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51132300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"营山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51132200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"西充县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51132500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"仪陇县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51132400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"阆中市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51138100"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"眉山"]){
                    if ([location.district isEqualToString:@"青神县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51142500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"洪雅县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51142300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"东坡区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51140200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"丹棱县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51142400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"仁寿县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51142100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"彭山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51142200"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"广安"]){
                    if ([location.district isEqualToString:@"广安区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51160200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"邻水县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51162300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"华莹市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51168100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"武胜县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51162200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"岳池县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51162100"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"达州"]){
                    if ([location.district isEqualToString:@"宣汉县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51172200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"开江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51172300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"大竹县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51172400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"渠县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51172500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"通川区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51170200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"达县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51172100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"万源市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51178100"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"雅安"]){
                    if ([location.district isEqualToString:@"名山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"芦山县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"天全县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"宝兴县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182700"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"荥经县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"雨城区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51180200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"石棉县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"汉源县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51182300"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"巴中"]){
                    if ([location.district isEqualToString:@"巴州区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51190200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"通江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51192100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"平昌县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51192300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"南江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51192200"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"资阳"]){
                    if ([location.district isEqualToString:@"雁江区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51200200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"安岳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51202100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"乐至县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51202200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"简阳市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51208100"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"阿坝"]){
                    if ([location.district isEqualToString:@"汶川县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"理县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"茂县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"松潘县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"九寨沟县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"金川县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"小金县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322700"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"黑水县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322800"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"马尔康县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51322900"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"壤塘县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51323000"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"阿坝县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51323100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"若尔盖县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51323200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"红原县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51323300"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"凉山彝族"]){
                    if ([location.district isEqualToString:@"西昌市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51340100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"木里"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"盐源县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"德昌县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"会理县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"会东县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"宁南县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342700"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"普格县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342800"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"布拖县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51342900"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"金阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343000"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"昭觉县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"喜德县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"冕宁县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"越西县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"甘洛县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"美姑县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"雷波县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51343700"];
                        [self saveArea:str];
                        
                    }
                    
                }else if ([location.city isEqualToString:@"甘孜藏族"]){
                    if ([location.district isEqualToString:@"康定县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"泸定县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"丹巴县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"九龙县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"雅江县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"道孚县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"炉霍县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332700"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"甘孜县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332800"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"新龙县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51332900"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"德格县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333000"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"得荣县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333800"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"白玉县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333100"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"石渠县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333200"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"色达县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333300"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"巴塘县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333500"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"理塘县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333400"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"乡城县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333600"];
                        [self saveArea:str];
                        
                    }else if ([location.district isEqualToString:@"稻城县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"51333700"];
                        [self saveArea:str];
                        
                    }
                    
                }
                
            } else if ([location.state isEqualToString:@"贵州省"]){
                if ([location.city isEqualToString:@"贵阳"]){
                    if ([location.district isEqualToString:@"南明区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52010200"];
                        [self saveArea:str];
                    } else if ([location.district isEqualToString:@"云岩区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52010300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"花溪区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52011100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"乌当区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52011300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"白云区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52230000"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"小河区"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52011400"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"开阳县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52012100"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"息烽县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52012200"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"修文县"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52012300"];
                        [self saveArea:str];
                    }else if ([location.district isEqualToString:@"清镇市"]){
                        NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52018100"];
                        [self saveArea:str];
                    }
                    
                } else if ([location.city isEqualToString:@"六盘水"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52020000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"遵义"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52030000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"安顺"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52040000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"铜仁地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52220000"];
                    [self saveArea:str];
                }else if ([location.city isEqualToString:@"黔西南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52230000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"毕节地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52240000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"黔东南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52260000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"黔南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"52270000"];
                    [self saveArea:str];
                    
                }
                
            } else if ([location.state isEqualToString:@"云南省"]){
                if ([location.city isEqualToString:@"昆明"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53010000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"曲靖"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53030000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"玉溪"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53040000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"保山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53050000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"昭通"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53060000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"丽江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53070000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"思茅"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53080000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"临沧"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53090000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"楚雄"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53230000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"红河"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53250000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"西双版纳"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53280000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"大理"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53290000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"德宏"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53310000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"怒江"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53330000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"迪庆"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53340000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"文山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"53260000"];
                    [self saveArea:str];
                    
                }
                
            } else if ([location.state isEqualToString:@"西藏自治区"]){
                if ([location.city isEqualToString:@"阿里地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54250000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"拉萨"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54010000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"山南地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54220000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"日喀则地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54230000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"那曲地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54240000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"林芝地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54260000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"昌都地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"54210000"];
                    [self saveArea:str];
                    
                }
                
                
            } else if ([location.state isEqualToString:@"陕西省"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",self.zoneArray[26]];
                [self dismiss];
                [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                              modificationType:str
                                                       success:^(NSDictionary *friendDynamic) {
                                                           [self dismiss];
                                                           [self gotoMainUI:friendDynamic];
                                                           
                                                       } failed:^(NSString *errorMSG) {
                                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                           
                                                       }];
                
            } else if ([location.state isEqualToString:@"甘肃省"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",self.zoneArray[27]];
                [self dismiss];
                [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                              modificationType:str
                                                       success:^(NSDictionary *friendDynamic) {
                                                           [self dismiss];
                                                           [self gotoMainUI:friendDynamic];
                                                           
                                                       } failed:^(NSString *errorMSG) {
                                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                           
                                                       }];
                
            } else if ([location.state isEqualToString:@"青海省"]){
                if ([location.city isEqualToString:@"西宁"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63010000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"海东地"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63210000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"海北"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63220000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"黄南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63230000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"海南"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63250000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"果洛"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63260000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"玉树"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63270000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"海西"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"63280000"];
                    [self saveArea:str];
                    
                }
                
            } else if ([location.state isEqualToString:@"宁夏回族自治区"]){
                if ([location.city isEqualToString:@"银川"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"64010000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"石嘴山"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"64020000"];
                    [self saveArea:str];
                    
                } else if ([location.city isEqualToString:@"吴忠"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"64030000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"固原"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"64040000"];
                    [self saveArea:str];
                    
                }else if ([location.city isEqualToString:@"中卫"]){
                    NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"64050000"];
                    [self saveArea:str];
                    
                }
                
                
            } else if ([location.state isEqualToString:@"新疆维吾尔自治区"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"65000000"];
                [self saveArea:str];
                
            } else if ([location.state isEqualToString:@"台湾省"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"71000000"];
                [self saveArea:str];
                
            } else if ([location.state isEqualToString:@"香港特别行政区"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"81000000"];
                [self saveArea:str];

                
            } else if ([location.state isEqualToString:@"澳门特别行政区"]){
                NSString *str = [NSString stringWithFormat:@"NowAreaCode=%@",@"82000000"];
                [self saveArea:str];
                
            } else if ([location.state isEqualToString:@"国外"]){
                [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"哈哈，你不是外国人，不能调皮哦！"];

            }
        }
    }
}

#pragma mark -- 保存地区请求

- (void)saveArea:(NSString *)theAreaCode
{
    [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                  modificationType:theAreaCode
                                           success:^(NSDictionary *friendDynamic) {
                                               [self dismiss];
                                               [self gotoMainUI:friendDynamic];
                                           } failed:^(NSString *errorMSG) {
                                               [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                           }];
}

#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"图片上传失败" ];
    NSLog(@"The error is:%@", theRequest.error);
}


- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
    ErrorModel *result = [[ErrorModel alloc] initWithString:theRequest.responseString error:nil];
    if (result.st.integerValue == 0) {
        // 获取个人信息
        NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserByToKen",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.tokenId,@"Token",[RRTManager manager].loginManager.loginInfo.userId,@"userId",nil];
        [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
            PersonModel *result = [[PersonModel alloc] initWithString:json error:nil];
            if (result.st == 0) {
                [RRTManager manager].loginManager.loginInfo.userAvatar = result.msg.PictureUrl;
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
                
                UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:savedImage,@"savedImage", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:ModificationHeader
                                                                    object:nil
                                                                  userInfo:dict];
                [self performSelector:@selector(showUI) withObject:self afterDelay:0.0f];
            }else{
            }
        } fail:^(id errors) {
        } cache:^(id cache) {
        }];

    }else{
        [self showImage:[UIImage imageNamed:@"error"] status:@"头像修改失败"];
    }
}
- (void)showUI
{
    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"修改成功"];
}

#pragma mark - UIImagePickerControllerDelegate 相机
#pragma mark -
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
            
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //压缩图片
        theImage = [UIImage scaleImage:theImage toScale:0.5];
        
        // 保存图片至本地
        [self saveImage:theImage withName:@"currentImage.png"];
        
        //获取cell上的头像
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
        UIImageView *headerIMG = (UIImageView *)[cell viewWithTag:101];
        headerIMG.frame = CGRectMake(13, 9, 51, 51);
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [headerIMG setImage:savedImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    if (currentImage) {
        NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
        // 获取沙盒目录
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        // 将图片写入文件
        [imageData writeToFile:fullPath atomically:NO];
        [self requestDataImage];
    }
    
}

#pragma mark -- 上传图片请求
- (void)requestDataImage
{
    ASIFormDataRequest *requestReport  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://home.%@/api/PostUserPhoto",aedudomain]]];
    [requestReport setPostValue:[RRTManager manager].loginManager.loginInfo.userId forKey:@"UserId"];
    NSString *Path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    [requestReport setFile:Path forKey:@"File"];
    [requestReport buildPostBody];
    requestReport.delegate = self;
    [requestReport setDidFailSelector:@selector(uploadFailed:)];
    [requestReport setDidFinishSelector:@selector(uploadPicFinished:)];
    [requestReport startAsynchronous];
    [self show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self dismiss];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark -- 日期选择器
- (void)showDateAlertWithTag:(int)tag {
    UIDatePicker* datepicker=[[UIDatePicker alloc] init];
    datepicker.width=SCREENWIDTH-40;
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.tag=2013;
    AttendAlertView* alertView=[[AttendAlertView alloc] init];
    alertView.delegate=self;
    alertView.tag=tag;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"保存", nil]];//添加按钮
    [alertView setContainerView:datepicker];
    [alertView show];
    
}

#pragma mark -- AttendAlertViewDelegate
- (void)customAttendAlertViewButtonTouchUpInside: (AttendAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        int tag=(int)[alertView tag];
        UIDatePicker* datepicker =(UIDatePicker*)[alertView viewWithTag:2013];
        NSDate* date=[datepicker date];
        
        if (tag==888) {
            //获取cell上的label
            NSIndexPath *cellPath = [NSIndexPath indexPathForItem:4 inSection:1];
            UITableViewCell *cell = (UITableViewCell*)[self.mainTableView cellForRowAtIndexPath:cellPath];
            UILabel *label = (UILabel *)[cell viewWithTag:2];
            
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            NSString *locationString = [dateformatter stringFromDate:date];
            label.text = locationString;
            
            NSString *str = [NSString stringWithFormat:@"Birthday=%@",label.text];
            [self dismiss];
            [self.netWorkManager modificationMyselfDetails:[RRTManager manager].loginManager.loginInfo.userId
                                          modificationType:str
                                                   success:^(NSDictionary *friendDynamic) {
                                                       [self dismiss];
                                                       [self gotoMainUI:friendDynamic];
                                                       
                                                   } failed:^(NSString *errorMSG) {
                                                       [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                                       
                                                   }];
            
        }
        

    }
    [alertView close];
}

- (void)gotoMainUI:(NSDictionary *)data
{
    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"修改成功"];

    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

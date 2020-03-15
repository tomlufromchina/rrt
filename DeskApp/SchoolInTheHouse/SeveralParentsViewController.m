//
//  SeveralParentsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SeveralParentsViewController.h"
#import "SendParentsViewController.h"
#import "SeveralParentsCell.h"

#import "NetWorkManager+SchoolAndHouse.h"

@interface SeveralParentsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *groupCounts;
@property (nonatomic, strong) NSMutableArray *groupIdArray;
@property (nonatomic, strong) NSMutableArray *groupMenber;
@property (nonatomic, strong) NSMutableArray *studentId;
@property (nonatomic, strong) NSMutableArray *inSchoolStudent;
@property (nonatomic, strong) NSMutableArray *outSchoolStudent;
@property (nonatomic, strong) NSMutableArray * buttonStatedic;// 防止重用
@property (nonatomic, strong) NSMutableArray *isAllDueArray;
@property (nonatomic, assign) int i;
@property (nonatomic, assign) int isOnCampus;
@property (nonatomic, assign) BOOL isClick;

@property (nonatomic, assign) NSInteger buttonIndex;


@end

@implementation SeveralParentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给个别家长发送";
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.navigationController.navigationBar.translucent = NO;
    
    self.mainCollectionView.collectionViewLayout = [self flowLayout];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickNextButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.groupCounts = [[NSMutableArray alloc] init];
    self.groupIdArray = [[NSMutableArray alloc] init];
    self.groupMenber = [[NSMutableArray alloc] init];
    self.studentId = [[NSMutableArray alloc] init];
    self.inSchoolStudent = [[NSMutableArray alloc] init];
    self.outSchoolStudent = [[NSMutableArray alloc] init];
    self.buttonStatedic = [[NSMutableArray alloc] init];
    self.isAllDueArray = [[NSMutableArray alloc] init];
    
    self.isOnCampus = 0;
    self.allButton.tag = 0;
    self.turnOverButton.tag = 0;
    self.inSchoolButton.tag = 0;
    self.outSchoolButton.tag = 0;
    
    [self requestData];
}

#pragma mark -- 下一步之前判断

- (BOOL)validateTheGoto
{
    if (self.buttonStatedic && [self.buttonStatedic count] > 0) {
        //  全部
        BOOL b = NO;// 先设置全部未选中
        for (int j = 0; j < [self.groupMenber count]; j ++) {
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)j inSection:0];
            NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
                
                b = YES;
                break;
            }
        }
        if (!b) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择发送对象"];

        }
        return b;
        // 在校
        BOOL c = NO;// 先设置全部未选中
        for (int i = 0; i < [self.inSchoolStudent count]; i ++) {
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
            NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
                
                c = YES;
                break;
            }
        }
        if (!c) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择发送对象"];

        }
        return c;
        // 离校
        BOOL d = NO;// 先设置全部未选中
        for (int k = 0; k < [self.outSchoolStudent count]; k ++) {
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)k inSection:0];
            NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
                
                d = YES;
                break;
            }
        }
        if (!d) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择发送对象"];
        }
        return d;
        
    } else{
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请选择发送对象"];
        return NO;
    }
    
//    BOOL b = NO;// 先设置全部未选中
//    for (int i = 0; i < [self.groupMenber count]; i++) {
//        
//        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
//        SeveralParentsCell *cell = (SeveralParentsCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
//        UIButton *chooseButton = cell.groupButton;
//        if (chooseButton.tag == 1) {
//            b = YES;
//            break;
//        }
//    }
//    if (!b) {
//        [self showWithTitle:@"请选择发送对象" withTime:1.5f];
//    }
//    return b;
//    
//    BOOL a = NO;// 先设置全部未选中
//    for (int i = 0; i < [self.inSchoolStudent count]; i++) {
//        
//        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
//        SeveralParentsCell *cell = (SeveralParentsCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
//        UIButton *chooseButton = cell.groupButton;
//        if (chooseButton.tag == 1) {
//            a = YES;
//            break;
//        }
//    }
//    if (!a) {
//        [self showWithTitle:@"请选择发送对象" withTime:1.5f];
//    }
//    return a;
//    
//    BOOL c = NO;// 先设置全部未选中
//    for (int i = 0; i < [self.outSchoolStudent count]; i++) {
//        
//        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
//        SeveralParentsCell *cell = (SeveralParentsCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
//        UIButton *chooseButton = cell.groupButton;
//        if (chooseButton.tag == 1) {
//            c = YES;
//            break;
//        }
//    }
//    if (!c) {
//        [self showWithTitle:@"请选择发送对象" withTime:1.5f];
//    }
//    return c;

}

#pragma mark -- 下一步

- (void)clickNextButton
{
    if ([self validateTheGoto]) {
        [self.navigationController pushViewController:SendParentsVCID
                                       withStoryBoard:DeskStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
                                                SendParentsViewController *VC = (SendParentsViewController *)viewController;
                                                VC.studentId = [[NSMutableArray alloc] init];
                                                for (int j = 0; j < [self.groupMenber count]; j ++) {
                                                    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)j inSection:0];
                                                    NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
                                                    if ([[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
                                                        [VC.studentId addObject:[self.studentId objectAtIndex:j]];
                                                        
                                                    }
                                                }
                                                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                                NSString *myString = [prefs stringForKey:@"keyToLookupString"];
                                                VC.classId = myString;
                                               
                                            }];
        
    }
}

#pragma mark -- 获取教师创建的班级请求
- (void)requestData
{
    [self show];
    [self.netWorkManager getTeacherClassCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                     teacherId:[RRTManager manager].loginManager.loginInfo.userId
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self gotoUpdataUI:data];
        
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
        
    }];
}

#pragma mark -- 教师创建的班级界面刷新
- (void)gotoUpdataUI:(NSMutableArray *)data
{
    if (data) {
        for (int i = 0; i < [data count]; i ++) {
            [self.groupCounts addObject:[data[i] objectForKey:@"ClassAlias"]];
            
            [self.groupIdArray addObject:[data[i] objectForKey:@"ClassId"]];
        }
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
    
}

#pragma mark -- 设置layout
#pragma mark --
- (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(151, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 10;
    return layout;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isOnCampus == 1) {
        if ([self.inSchoolStudent count] > 0) {
            return [self.inSchoolStudent count];
        }
        return [self.inSchoolStudent count];
    } else {
        if ([self.outSchoolStudent count] > 0) {
            return [self.outSchoolStudent count];
        } else if ([self.groupMenber count] > 0){
            return [self.groupMenber count];
        } else {
            return 0;
        }
    }
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeveralParentsCell *cell = (SeveralParentsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SeveralParentsCell" forIndexPath:indexPath];
    
    [cell.groupButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    // 重用问题
    NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"NO" forKey:@"checked"];
//        [self setChecked:NO];
        [cell setTheChecked:NO];
        
    }else {
        [dic setObject:@"YES" forKey:@"checked"];
//        [self setChecked:YES];
        [cell setTheChecked:YES];

    }
   
    
    UILabel *studentName = (UILabel *)[cell viewWithTag:102];
    
    if (self.isOnCampus == 1) {
        if (self.inSchoolStudent && [self.inSchoolStudent count] > 0) {
            CurrentStudent *obj = [self.inSchoolStudent objectAtIndex:indexPath.row];
            if (obj.UserService == -1 || obj.UserService == 1) {
                studentName.textColor = [UIColor redColor];
                cell.groupButton.hidden = YES;
            } else{
                studentName.textColor = [UIColor blackColor];
                cell.groupButton.hidden = NO;
                
            }
            studentName.text = obj.StudentName;
        } else {
            studentName.text = @"";
        }
    } else {
        if (self.outSchoolStudent && [self.outSchoolStudent count] > 0) {
            CurrentStudent *obj = [self.outSchoolStudent objectAtIndex:indexPath.row];
            if (obj.UserService == -1 || obj.UserService == 1) {
                studentName.textColor = [UIColor redColor];
                cell.groupButton.hidden = YES;
            } else{
                studentName.textColor = [UIColor blackColor];
                cell.groupButton.hidden = NO;
                
            }
            studentName.text = obj.StudentName;
        } else {
            studentName.text = @"";
            if (self.groupMenber && [self.groupMenber count] > 0) {
                CurrentStudent *obj =( (ChineseString*)[self.groupMenber objectAtIndex:indexPath.row]).cstu;
                if (obj.UserService == -1 || obj.UserService == 1) {
                    studentName.textColor = [UIColor redColor];
                    cell.groupButton.hidden = YES;
                } else{
                    studentName.textColor = [UIColor blackColor];
                    cell.groupButton.hidden = NO;

                }
                studentName.text = obj.StudentName;
            } else {
                studentName.text = @"";
            }
        }
    }
    NSLog(@"%@",self.buttonStatedic);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeveralParentsCell *cell = (SeveralParentsCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:row];
    
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setTheChecked:YES];
    }else {
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setTheChecked:NO];
    }
    
}

#pragma mark -- collectionViewCellButton相应事件

- (void)clickChooseButton:(UIButton *)sender
{
//    if (sender.tag==0) {
//        sender.tag=1;
//        [sender setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
//        BOOL isallchecked=YES;
//        for (int i = 0; i < [self.groupMenber count]; i++) {
//            NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
//            SeveralParentsCell *cell = (SeveralParentsCell*)[self.mainCollectionView cellForItemAtIndexPath:path];
//            UIButton *chooseButton = cell.groupButton;
//            if (chooseButton.tag==0) {
//                isallchecked=NO;
//                break;
//            }
//        }
//        if (isallchecked) {
//            [self.allButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
//            self.allButton.tag = 1;
//            [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
//            self.turnOverButton.tag = 0;
//            
//        }else{
//            [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
//            self.allButton.tag = 0;
//        }
//    } else {
//        sender.tag=0;
//        [sender setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
//        [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
//        self.allButton.tag = 0;
//        [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
//        self.turnOverButton.tag = 0;
//    }
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:hitPoint];
    SeveralParentsCell *cell = (SeveralParentsCell*)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"YES" forKey:@"checked"];
//        [cell setTheChecked:YES];
        [cell.groupButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];

    }else {
        [dic setObject:@"NO" forKey:@"checked"];
//        [cell setTheChecked:NO];
        [cell.groupButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];

    }
    [self.mainCollectionView reloadData];
    
}

#pragma mark -- 选择班级
- (IBAction)clickControlClassButon:(UIButton *)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
    for(int i = 0; i < [self.groupCounts count]; i++)
    {
        [sheet addButtonWithTitle:self.groupCounts[i]];
    }
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = [self.groupCounts count];
    [sheet showInView:self.view];
}

#pragma mark -- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 重新选择班级的时候将所有的按钮变成未选状态
    
    for (int j = 0; j < [self.groupMenber count]; j ++) {
    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)j inSection:0];
    NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.buttonStatedic addObject:dic];
        
    }
    for (int i = 0; i < [self.inSchoolStudent count]; i ++) {
        
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.buttonStatedic addObject:dic];
        
    }
    for (int i = 0; i < [self.outSchoolStudent count]; i ++) {
        
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:indexPath.row];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.buttonStatedic addObject:dic];
    
    }
    
    self.i = (int)buttonIndex;
    if (buttonIndex < [self.groupCounts count]) {
        
        NSString* theClassName = [self.groupCounts objectAtIndex:buttonIndex];
        self.controlClassLabel.text = theClassName;
        
        long long theClassId = [[self.groupIdArray objectAtIndex:buttonIndex] longLongValue];
        // 将班级id保存
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs setObject:[NSString stringWithFormat:@"%lld",[[self.groupIdArray objectAtIndex:buttonIndex] longLongValue]] forKey:@"keyToLookupString"];
         [prefs synchronize];
        
        [self show];
        [self.netWorkManager getClassStudentCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                           classId:theClassId
                                           success:^(NSMutableArray *data) {
                                               [self dismiss];
                                               [self updateUI:data];
                                               
                                           } failed:^(NSString *errorMSG) {
                                               [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                               
                                               [self.groupMenber removeAllObjects];
                                               [self.inSchoolStudent removeAllObjects];
                                               [self.outSchoolStudent removeAllObjects];
                                               
                                               [self.mainCollectionView reloadData];
                                           }];
    }
}

#pragma mark -- 住校界面数据

- (void)updateUserInterface:(NSMutableArray *)data
{
    if (data) {
        [self.inSchoolStudent removeAllObjects];
        NSMutableArray *tempInSchoolStudent = [[NSMutableArray alloc] init];
        [tempInSchoolStudent addObjectsFromArray:[self chineseCharacterSort1:data]];
        
        for (int j = 0; j < [tempInSchoolStudent count]; j ++) {
            CurrentStudent *obj =( (ChineseString*)[tempInSchoolStudent objectAtIndex:j]).cstu;
            self.isOnCampus = obj.IsOnCampus;
            if (obj.IsOnCampus == 1) {
                
                [self.inSchoolStudent addObject:obj];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:@"NO" forKey:@"checked"];
                [self.buttonStatedic addObject:dic];
            }
        }

        self.isOnCampus = 1;
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
}

#pragma mark -- 走读界面数据
- (void)updateUIForOutSchool:(NSMutableArray *)data
{
    if (data) {
        [self.outSchoolStudent removeAllObjects];
        
        NSMutableArray *tempOutSchoolStudent = [[NSMutableArray alloc] init];
        [tempOutSchoolStudent addObjectsFromArray:[self chineseCharacterSort1:data]];
        
        for (int j = 0; j <[tempOutSchoolStudent count]; j ++) {

            CurrentStudent *obj =( (ChineseString*)[tempOutSchoolStudent objectAtIndex:j]).cstu;
            self.isOnCampus = obj.IsOnCampus;
            
            if (obj.IsOnCampus == 0) {
                [self.outSchoolStudent addObject:obj];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:@"NO" forKey:@"checked"];
                [self.buttonStatedic addObject:dic];

            }
        }
        
        self.isOnCampus = 0;
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
}
#pragma mark -- 全部学生界面数据

- (void)updateUI:(NSMutableArray *)data
{
    if (data) {
        [self.groupMenber removeAllObjects];
        [self.inSchoolStudent removeAllObjects];
        [self.outSchoolStudent removeAllObjects];
        
        
        [self.groupMenber addObjectsFromArray:[self chineseCharacterSort1:data]];
        
        
        for (int j = 0; j < [self.groupMenber count]; j ++) {
            CurrentStudent *obj =( (ChineseString*)[self.groupMenber objectAtIndex:j]).cstu;
            [self.studentId addObject:[NSString stringWithFormat:@"%lld",obj.StudentId]];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"NO" forKey:@"checked"];
            [self.buttonStatedic addObject:dic];
        }
        
        self.isOnCampus = 0;
        self.mainCollectionView.hidden = NO;
        [self.mainCollectionView reloadData];
    }
}

#pragma mark -- 排序
- (NSMutableArray *)chineseCharacterSort:(NSMutableArray *)array
{
    // 排序
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[array objectAtIndex:i]];
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
    }
    return result;
    
}

#pragma mark -- 排序
- (NSMutableArray *)chineseCharacterSort1:(NSMutableArray *)array
{
    // 排序
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        CurrentStudent* cstu=[array objectAtIndex:i];
        chineseString.string=[NSString stringWithString:cstu.StudentName];
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        chineseString.cstu=cstu;
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
    
}

#pragma mark -- 变换cell按钮图片

- (void)setChecked:(BOOL)checked{
    if (checked){
        for (int i = 0; i < [self.groupMenber count]; i++) {
            NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
            SeveralParentsCell *cell = (SeveralParentsCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
            UIButton *chooseButton = cell.groupButton;
            [chooseButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
            
        }
    }else{
        for (int i = 0; i < [self.groupMenber count]; i++) {
            NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
            SeveralParentsCell *cell = (SeveralParentsCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
            UIButton *chooseButton = cell.groupButton;
            [chooseButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark -- 全选
- (IBAction)clickAllButton:(UIButton *)sender {
    [self.allButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.allButton.tag = 1;
    
    [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 0;
    for (int i = 0; i < [self.groupMenber count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:path.row];
        [dic setObject:@"YES" forKey:@"checked"];
        [self setChecked:YES];
        
    }
}

#pragma mark -- 重新选择班级后全部按钮图片恢复正常状态

- (void)allImageViewStateNormal
{
    [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allButton.tag = 0;
    [self.turnOverButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 0;
    [self.outSchoolButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.outSchoolButton.tag = 0;
    [self.inSchoolButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.outSchoolButton.tag = 0;
    
    for (int i = 0; i < [self.groupMenber count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        SeveralParentsCell *cell = (SeveralParentsCell *)[self.mainCollectionView cellForItemAtIndexPath:path];
        UIButton *chooseButton = cell.groupButton;
        [chooseButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        
        chooseButton.tag=0;
    }
    
}
#pragma mark -- 反选
- (IBAction)clickTurnOverButton:(UIButton *)sender {
    [self.turnOverButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.turnOverButton.tag = 1;
    
    [self.allButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.allButton.tag = 0;
    for (int i = 0; i < [self.groupMenber count]; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForRow:(NSInteger)i inSection:0];
        NSMutableDictionary *dic = [self.buttonStatedic objectAtIndex:path.row];
        [dic setObject:@"NO" forKey:@"checked"];
        [self setChecked:NO];
        
    }
}
#pragma mark -- 住校
- (IBAction)clickInschoolButton:(UIButton *)sender {
    [self.inSchoolButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.inSchoolButton.tag = 1;
    [self.outSchoolButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.outSchoolButton.tag = 0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString = [prefs stringForKey:@"keyToLookupString"];
    
    [self show];
    [self.netWorkManager getClassStudentCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                       classId:[myString longLongValue]
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self updateUserInterface:data];
                                           
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
    
}
#pragma mark -- 走读
- (IBAction)clickOutSchoolButton:(UIButton *)sender {
    [self.outSchoolButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    self.outSchoolButton.tag = 0;
    
    [self.inSchoolButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    self.inSchoolButton.tag = 1;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString = [prefs stringForKey:@"keyToLookupString"];
    
    [self show];
    [self.netWorkManager getClassStudentCounts:[RRTManager manager].loginManager.loginInfo.tokenId
                                       classId:[myString longLongValue]
                                       success:^(NSMutableArray *data) {
                                           [self dismiss];
                                           [self updateUIForOutSchool:data];
                                           
                                       } failed:^(NSString *errorMSG) {
                                           [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:errorMSG];
                                       }];
    
}

@end

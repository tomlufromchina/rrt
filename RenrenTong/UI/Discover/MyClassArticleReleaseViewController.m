//
//  MyClassArticleReleaseViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/14.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyClassArticleReleaseViewController.h"
#import "MLTableAlert.h"

@interface MyClassArticleReleaseViewController ()<UITextViewDelegate>
{
    BOOL isEndPublish;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (strong, nonatomic) MLTableAlert *alert;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *categoryArrayId;

@end

@implementation MyClassArticleReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEndPublish = YES;
    self.title = @"写文章";
    self.commentTextView.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.categoryArray = [[NSMutableArray alloc] init];
    self.categoryArrayId = [[NSMutableArray alloc] init];
    [self reqeustData];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self  action:@selector(clickRelease)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 发布
#pragma mark --
- (void)clickRelease
{
    
    if ([self validateTheLogin] && isEndPublish) {
        // 初始化
        isEndPublish = NO;
        self.alert = [MLTableAlert tableAlertWithTitle:@"选择发布类型" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                      {
                          return [self.categoryArray count];
                      }
                                              andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                      {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil)
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          cell.textLabel.text = [self.categoryArray objectAtIndex:indexPath.row];
                          return cell;
                      }];
        
        // 高度
        self.alert.height = 300;
        // 点击cell
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
           
                [self.netWorkManager releaseArticle:self.classId
                                             UserId:[RRTManager manager].loginManager.loginInfo.userId
                                         CategoryId:[self.categoryArrayId objectAtIndex:selectedIndex.row]
                                       ArchiveTitle:self.titleTextField.text
                                        ArchiveText:self.commentTextView.text
                                            success:^(NSString *data) {
                                                [self performSelector:@selector(back) withObject:self afterDelay:0.0f];
                                            } failed:^(NSString *errorMSG) {
                                                isEndPublish = YES;
                                            }];
            
        } andCompletionBlock:^{
            isEndPublish = YES;
        }];
        [self.alert show];
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    self.block();
}

#pragma mark -- 获取发布类别
#pragma mark --

- (void)reqeustData
{
   
    [self.netWorkManager classArticleCategory:self.classId
                                     pagesize:20
                                    pageindex:1
                                      success:^(NSMutableArray *data) {
                                          if (data && [data count] > 0) {
                                              for (int i = 0; i < [data count]; i ++) {
                                                  ReleaseClassArticleList *RCL = data[i];
                                                  [self.categoryArray addObject:RCL.CategoryName];
                                                  [self.categoryArrayId addObject:RCL.CategoryId];
                                              }
                                          }
                                      } failed:^(NSString *errorMSG) {
                                          
                                      }];
    
}

#pragma mark - Ubility
#pragma mark -
- (BOOL)validateTheLogin
{
    if (self.titleTextField.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入日志标题！"];
        
        return NO;
    }
    if (self.commentTextView.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入日志内容！"];
        
        return NO;
    }
    return YES;
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    self.watermarkLabel.hidden = YES;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [self.watermarkLabel setHidden:(textView.text.length == 0) ? NO : YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self dismiss];
}

@end

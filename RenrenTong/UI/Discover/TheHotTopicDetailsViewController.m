//
//  TheHotTopicDetailsViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/22.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TheHotTopicDetailsViewController.h"
#import "VistorModelCell.h"
#import "UIimageView+Animation.h"
#import "NSString+TextSize.h"
#import "MJRefresh.h"
#import "MLEmojiLabel.h"
#import "CUSFlashLabel.h"
#import "commentaryToolView.h"
#import "QBImagePickerController.h"
#import "HistoryTopicViewController.h"
#import "HotTopicSubDetailViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"
#import "UILabel+Tool.h"
#import "UIImage+Addition.h"
#import "ASIFormDataRequest.h"
#import "DynamicCell.h"

@interface TheHotTopicDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,QBImagePickerControllerDelegate,MLEmojiLabelDelegate,VistorModelCellDelegate,commentaryToolViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,DynamicCellDelegate>
{
    NSMutableArray *praiseArray;// 点赞图片仿重用
    int imagecount;
    NSString *allImageUrl;
    NSString *tempToUserID;
    NSString *tempObjectId;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) VisitorModel *visitorModel;
@property (nonatomic, strong) commentaryToolView *toolBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, strong) MLEmojiLabel *hotTopicEmjolable;// 放话题内容
@property (nonatomic, assign) BOOL bReplyToComment; //判断是回复评论1，还是回复某个人0
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) BOOL isFaild;

@property (nonatomic, assign) int activityIndex;
@property (nonatomic, assign) int commentIndex;

@end

@implementation TheHotTopicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.netWorkManager = [[NetWorkManager alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    self.imageUrls = [NSMutableArray array];
    self.selectedImages = [NSMutableArray array];
    self.pageIndex = 1;
    self.pageSize = 10;
    imagecount = 0;
    self.isFaild = NO;
    allImageUrl = @"";

    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self setupRefresh];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.mainTableView addGestureRecognizer:tapGesture];
        
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self initView];
}

- (void)initView
{
    // 重写navigationView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    [imageView setImage:[UIImage imageNamed:@"htl-"]];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((SCREENWIDTH-100) * 0.5, 15, 100, 50);
    label.text = @"话题";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:label];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.frame = CGRectMake(15, 35, 8, 14);
    [backImageView setImage:[UIImage imageNamed:@"theback-"]];
    [view addSubview:backImageView];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 100, 100);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backButton];
    
    CUSFlashLabel *titileLabel = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(15, backImageView.bottom + 5, 200, 50)];
    [titileLabel setSpotlightColor:CommentViewTextColor];
    titileLabel.text = [NSString stringWithFormat:@"#%@#",self.hotTopic.TagName];
    titileLabel.textAlignment = NSTextAlignmentLeft;
    titileLabel.font = [UIFont systemFontOfSize:16.0];
    titileLabel.numberOfLines = 0;
    titileLabel.textColor = [UIColor whiteColor];
    titileLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [titileLabel startAnimating];
    [view addSubview:titileLabel];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.top = label.top;
    nextButton.left = label.right - 10;
    nextButton.width = (SCREENWIDTH-100) * 0.5;
    nextButton.height = 50;
    [nextButton setTitle:@"历史话题" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [nextButton addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextButton];
    [self.view addSubview:view];
    // 初始化tableHeaderView
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    UIView *lineTheView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    lineTheView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:lineTheView];
    self.hotTopicEmjolable = [self createLableWithText:[NSString stringWithFormat:@"导语:%@",[NSString flattenHTML:self.hotTopic.Description]]font:[UIFont systemFontOfSize:15] width:SCREENWIDTH - 20];
    self.hotTopicEmjolable.top = lineTheView.bottom + 10;
    self.hotTopicEmjolable.left = 10;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.hotTopicEmjolable.bottom + 5, SCREENWIDTH, 10)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:lineView];
    [headerView addSubview:self.hotTopicEmjolable];
    headerView.height = self.hotTopicEmjolable.height + 30;

    self.mainTableView.tableHeaderView = headerView;
    // 初始化工具框
    commentaryToolView *toolbar = [[commentaryToolView alloc]init];
    toolbar.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH + 10, 50);
    [self.view addSubview:toolbar];
    self.toolBar = toolbar;
    [self.toolBar.iconBtn setBackgroundImage:[UIImage imageNamed:@"tp-"] forState:UIControlStateNormal];
    [self.toolBar.iconBtn setTitle:nil forState:UIControlStateNormal];
    self.toolBar.procLable.text = @"一起参与话题吧...";
    toolbar.delegate = self;
    [toolbar bringSubviewToFront:self.mainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    self.mainTableView.frame = CGRectMake(0, view.bottom, SCREENWIDTH, SCREENHEIGHT- 150);
    [self requestData];
}
-(MLEmojiLabel*)createLableWithText:(NSString*)text font:(UIFont*)font  width:(int)width{
    MLEmojiLabel*_emojiLabel= [[MLEmojiLabel alloc]init];
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = font;
    _emojiLabel.emojiDelegate = self;
    _emojiLabel.backgroundColor = [UIColor clearColor];
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emojiLabel.isNeedAtAndPoundSign = YES;
    [_emojiLabel setEmojiText:text];
    _emojiLabel.frame = CGRectMake(0, 0, width, 0);
    [_emojiLabel sizeToFit];
    return _emojiLabel;
}
#pragma mark - keyboard show and hide
#pragma mark -
- (void)keyboardShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = 0;
    ty = rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.mainTableView.transform = CGAffineTransformMakeTranslation(0, -ty);
                         self.toolBar.transform = CGAffineTransformMakeTranslation(0, -ty);
                     }];
}

- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.mainTableView.transform = CGAffineTransformIdentity;
                         self.toolBar.transform = CGAffineTransformIdentity;
                     }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 历史话题
#pragma mark --

- (void)nextVC
{
    HistoryTopicViewController *vc = [[HistoryTopicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 数据请求
#pragma mark --

- (void)requestData
{
    [self show];
    
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogByTagId",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.hotTopic.TagId,@"tagId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url
              parameters:dic
                 success:^(id json) {
                     TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
                     if (theMyTendency.st == 0) {
                         [self updateView:[theMyTendency.msg.list mutableCopy]];
                         [self dismiss];
                     }else{
                         ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
                         [self showUploadView:erromodel.msg];
                     }
                 } fail:^(id errors) {
                     [self showUploadView:errors];
                 } cache:^(id cache) {
                     
                 }];
}

- (void)updateView:(NSMutableArray *)data
{
    if (data && [data count] > 0) {
        for (int i = 0; i < [data count]; i ++) {
            [self.dataSource addObject:data[i]];
        }
        self.pageIndex ++;
        [self.mainTableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource count] > 0) {
        return [self.dataSource count];
    } else{
        return 1;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [[DynamicCell alloc] init];
    if (self.dataSource && [self.dataSource count] > 0) {
        cell.model = [self.dataSource objectAtIndex:indexPath.row];
    }
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DynamicCell";
    //自定义cell类
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DynamicCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataSource && [self.dataSource count] > 0) {
        cell.model = [self.dataSource objectAtIndex:indexPath.row];
        cell.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- DynamicCellDelegete
#pragma mark --
// 赞1
-(void)DynamicPraise:(DynamicCell*)cell
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/api/PostPraise",
                            aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.tokenId],@"token",[NSString stringWithFormat:@"%@",cell.model.MicroblogId],@"objectID",[NSString stringWithFormat:@"%d",1],@"typeId",nil];
    
    [HttpUtil PostWithUrl:requestUrl
               parameters:dic
                  success:^(id json) {
                      ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                      if (result.st.intValue == 0) {
                          [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"点赞成功"];
                          cell.model.IsPraise = [NSNumber numberWithInt:1];
                          TheMyTendencyPraiseUsers *pariseUser = [[TheMyTendencyPraiseUsers alloc] init];
                          pariseUser.PictureUrl = [RRTManager manager].loginManager.loginInfo.userAvatar;
                          [cell.model.PraiseUsers addObject:pariseUser];
                          NSIndexPath *path = [self.mainTableView indexPathForCell:cell];
                          [self.dataSource replaceObjectAtIndex:path.section withObject:cell.model];
                          [self.mainTableView reloadData];
                      } else if(result.st.intValue == 1){
                          [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:result.msg];
                      } else{
                          [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:result.msg];
                      }
                      
                  } fail:^(id error) {
                      [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:error];
                  } cache:^(id cache) {
                      
                  }];
}

-(void)DynamicComment:(DynamicCell *)cell
{
    HotTopicSubDetailViewController *VC = [[HotTopicSubDetailViewController alloc] init];
    cell.model.TheTitle = self.hotTopic.TagName;
    VC.model  = cell.model;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)DynamicMoreComment:(DynamicCell *)cell
{
    HotTopicSubDetailViewController *VC = [[HotTopicSubDetailViewController alloc] init];
    cell.model.TheTitle = self.hotTopic.TagName;
    VC.model  = cell.model;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)DynamicReplayComment:(DynamicCell *)cell ReplayID:(NSString*)toUserID
{
    HotTopicSubDetailViewController *VC = [[HotTopicSubDetailViewController alloc] init];
    cell.model.TheTitle = self.hotTopic.TagName;
    VC.model  = cell.model;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- commenttaryViewDelegate
#pragma mark --
-(void)clickCommentaryButon
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    
    [sheet showInView:self.view];
}

- (BOOL)validateTheLogin
{
    if (self.toolBar.textView.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请输入话题内容哦"];
        
        return NO;
    }
    return YES;
}

-(void)clickSendButton
{
    if ([self validateTheLogin]) {
        if (self.imageUrls.count > 0) {
            for (int i = 0; i < _imageUrls.count ; i++) {
                if (self.isFaild) {
                    [self showErrorWithStatus:@"发布失败"];
                    imagecount = 0;
                    [self.imageUrls removeAllObjects];
                    break;
                }
                NSString *Path = _imageUrls[i];
                self.request = [[ASIFormDataRequest alloc] init];
                //上传图片至服务器
                [self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://home.%@/api/PostUploadImages",aedudomain]]]];
                [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.userId forKey:@"userId"];
                [self.request setFile:Path forKey:@"File"];
                [self.request setTimeOutSeconds:20];
                [self.request setDelegate:self];
                [self.request setDidFailSelector:@selector(uploadFailed:)];
                [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
                [self.request startAsynchronous];
                [self show];
            }
        } else{
            [self show];
            NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateMicroblog", aedudomain];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"UserId",[NSString stringWithFormat:@"#%@#%@",self.hotTopic.TagName,self.toolBar.textView.text],@"Body",nil];
            
            [HttpUtil PostWithUrl:requestUrl
                       parameters:dic
                          success:^(id json) {
                              ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                              if (result.st.intValue == 0) {
                                  [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"发表成功"];
                                  [self headerReresh];
                              } else{
                                  [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发表失败"];
                              }
                          } fail:^(id error) {
                              [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发表失败"];
                          } cache:^(id cache) {
                              
                          }];
            
            self.toolBar.textView.text = @"";
            [self.toolBar RecoverFrame];
            if (self.imageUrls.count > 0) {
                [self.toolBar removePicView];
            }
        }
    }
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self dismiss];
    self.isFaild = YES;
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"图片上传失败"];
    
    NSLog(@"The error is:%@", theRequest.error);
}

- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
    imagecount++;
    NSLog(@"%@",theRequest.responseData);
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    NSLog(@"%@",dict);
    int count = (int)[dict objectForKey:@"st"];
    if (count != 0) {
        self.isFaild = YES;
    }
    [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"上传成功"];
    NSDictionary *tenmpDict = [dict objectForKey:@"msg"];
    NSString *tempAllImageUrl = [tenmpDict objectForKey:@"ImageUrl"];
    allImageUrl = [NSString stringWithFormat:@"%@,",tempAllImageUrl];
    allImageUrl = [allImageUrl stringByReplacingCharactersInRange:NSMakeRange(allImageUrl.length - 1, 1) withString:@""];
    if (imagecount == self.imageUrls.count) {
        int HasPhoto = 1;
        [self showWithStatus:@"正在发送..."];
        NSString *requestUrl = [NSString stringWithFormat:@"http://home.%@/Api/PostCreateMicroblog",
                      aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userId],@"UserId",[NSString stringWithFormat:@"#%@#%@",self.hotTopic.TagName,self.toolBar.textView.text],@"Body",[NSString stringWithFormat:@"%d",HasPhoto],@"HasPhoto",allImageUrl,@"ImageUrl",nil];
        [HttpUtil PostWithUrl:requestUrl
                   parameters:dic
                      success:^(id json) {
                          ErrorModel *result = [[ErrorModel alloc] initWithString:json error:nil];
                          if (result.st.intValue == 0) {
                              [self showImage:[UIImage imageNamed:@"confirm-ok72.png"] status:@"发表成功"];
                              [self headerReresh];
                              self.isFaild = NO;
                              self.toolBar.textView.text = @"";
                          } else{
                              [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发表失败"];
                          }
                      } fail:^(id error) {
                          [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"发表失败"];
                      } cache:^(id cache) {
                          
                      }];
        self.toolBar.textView.text = @"";
        [self.toolBar RecoverFrame];
        if (self.imageUrls.count > 0) {
            [self.toolBar removePicView];
        }
        imagecount = 0;
        [self.imageUrls removeAllObjects];
        [self deleteFile:self.imageUrls];
    }
}

#pragma mark -- QBImagePickerControllerDelegate
-(void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }
    NSString *imagePath = [docDir stringByAppendingPathComponent:
                           [NSString stringWithFormat:ActivityPath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    [self.imageUrls removeAllObjects];
    for (int i = 0; i < [assets count]; i++) {
        ALAsset *asset = (ALAsset*)[assets objectAtIndex:i];
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:assetRep.scale
                                     orientation:(UIImageOrientation)assetRep.orientation];
        NSString *imgPath = [imagePath stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"%d.jpg", i]];
        img = [UIImage scaleImage:img toScale:0.2];
        
        NSData *imageData = UIImagePNGRepresentation(img);
        [imageData writeToFile:imgPath atomically:YES];
        [_selectedImages addObject:img];
        [_imageUrls addObject:imgPath];
    }
    [self.toolBar showPicture:_imageUrls];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate 相机
#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageUrls removeAllObjects];
    
    img = [UIImage scaleImage:img toScale:0.2];
    
    NSString *imgPath = [self imageDataToPath:img];
    [_selectedImages addObject:img];
    [_imageUrls addObject:imgPath];
    [self.toolBar showPicture:_imageUrls];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UIActionsheet delegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //从相册中选择
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.maximumNumberOfSelection = 9;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    } else if (buttonIndex == 1){
        //拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: sourceType]) {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"该设备不支持拍照" ];
            
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}

-(NSString*)imageDataToPath:(UIImage*)img
{
    //UIImage 对象转换成本地url
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:ActivityPath]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    NSDate *date = [NSDate date];
    NSTimeInterval name = [date timeIntervalSince1970];
    
    NSString *imgPath = [imagePath stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"%f.png", name]];
    //压缩图片
    img = [UIImage scaleImage:img toScale:0.2];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:imgPath atomically:YES];
    return imgPath;
}

#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainTableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    self.pageIndex = 1;
    
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogByTagId",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.hotTopic.TagId,@"tagId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url
              parameters:dic
                 success:^(id json) {
                     TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
                     if (theMyTendency.st == 0) {
                         [self.dataSource removeAllObjects];
                         [self updateView:[theMyTendency.msg.list mutableCopy]];
                         [self.mainTableView headerEndRefreshing];
                     }else{
                         ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
                         [self showUploadView:erromodel.msg];
                         [self.mainTableView headerEndRefreshing];
                     }
                 } fail:^(id errors) {
                     [self showUploadView:errors];
                     [self.mainTableView headerEndRefreshing];
                 } cache:^(id cache) {
                     
                 }];
}

- (void)footerReresh
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogByTagId",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.hotTopic.TagId,@"tagId",[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",self.pageSize],@"pageSize",[NSString stringWithFormat:@"%d",self.pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url
              parameters:dic
                 success:^(id json) {
                     TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
                     if (theMyTendency.st == 0) {
                         [self updateView:[theMyTendency.msg.list mutableCopy]];
                         [self dismiss];
                         [self.mainTableView footerEndRefreshing];
                     }else{
                         ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
                         [self showUploadView:erromodel.msg];
                         [self.mainTableView footerEndRefreshing];
                     }
                 } fail:^(id errors) {
                     [self showUploadView:errors];
                     [self.mainTableView footerEndRefreshing];
                 } cache:^(id cache) {
                     
                 }];
}

#pragma mark - Tap Gesture
#pragma mark -
- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)hidenNavigationBar:(BOOL)isEnd
{
    if (isEnd) {
        self.navigationController.navigationBar.hidden = YES;
    } else{
        self.navigationController.navigationBar.hidden = YES;
    }
}

@end

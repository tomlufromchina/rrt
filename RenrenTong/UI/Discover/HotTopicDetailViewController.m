//
//  HotTopicDetailViewController.m
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "HotTopicDetailViewController.h"
#import "NSString+TextSize.h"
#import "TopicHeaderView.h"
#import "Microblog.h"
#import "MicroblogFrame.h"
#import "MJExtension.h"
#import "PraiseUsers.h"
#import "CommentCentent.h"
#import "TopicCell.h"
#import "CommentViewController.h"
#import "TopView.h"
#import "BootView.h"
#import "ToolBar.h"
#import "MJRefresh.h"
#import "HistoryTopicViewController.h"
#import "UzysAssetsPickerController.h"
#import "UIImage+Addition.h"
#import "ASIFormDataRequest.h"
#import "QBImagePickerController.h"

@interface HotTopicDetailViewController ()<UITextViewDelegate,ToolBarDelegate,TopViewDelegate,BootViewDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, UzysAssetsPickerControllerDelegate>
{
    int pageIndex;
    int pageSize;
    int imagecount;
    NSString *allImageUrl;
}
@property(nonatomic ,strong)NetWorkManager *netWork;
@property(nonatomic, strong)NSMutableArray *microblogArray;
@property(nonatomic, strong)NSMutableArray *microblogFrameArray;
@property(nonatomic, weak)ToolBar *toolbar;
@property(nonatomic, strong)NSMutableArray *selectedImages;
@property(nonatomic, strong)NSMutableArray *imageUrls;
@property(nonatomic, strong)ASIFormDataRequest *request;
@property(nonatomic, assign)BOOL isFaild;


@end

@implementation HotTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    [self preferredStatusBarStyle];
    self.isFaild = NO;
    pageSize = 20;
    imagecount = 0;
    allImageUrl = @"";
    self.title = @"话题";
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.tag != 1) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史话题" style:UIBarButtonItemStylePlain target:self  action:@selector(historyTopic)];
        self.navigationItem.rightBarButtonItem = rightItem;
      
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    

    
    //register keyboard note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    TopicHeaderView *headerView = [[TopicHeaderView alloc]init];
    headerView.topicName.text = self.hotTopic.TagName;
    headerView.detailString = [NSString flattenHTML:self.hotTopic.Description];
    CGSize textSize = [headerView.detailString sizeWithFont:headerView.topicDetail.font MaxSize:CGSizeMake(SCREENWIDTH - 2 * 15, MAXFLOAT)];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, textSize.height + 55);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 50)];
    self.mainView = tableView;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.tableHeaderView = headerView;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.mainView addFooterWithTarget:self action:@selector(footerReresh)];
    [self.view addSubview:tableView];
    
    ToolBar *toolbar = [[ToolBar alloc]init];
    toolbar.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
    [self.view addSubview:toolbar];
    toolbar.textView.delegate = self;
    self.toolbar = toolbar;
    toolbar.delegate = self;
    [toolbar bringSubviewToFront:tableView];
    
    self.netWork = [[NetWorkManager alloc]init];
    self.microblogArray = [NSMutableArray array];
    self.microblogFrameArray = [NSMutableArray array];
    self.selectedImages = [NSMutableArray array];
    self.imageUrls = [NSMutableArray array];
    [self getMicroblog];
    
}
- (void)headerReresh
{
    [self getMicroblog];
    [self.mainView headerEndRefreshing];
}

- (void)footerReresh
{
    [self show];
    pageIndex ++;
//    [self.netWork GetMicroblogByTagId:self.hotTopic.TagId pageSize:pageSize pageIndex:pageIndex success:^(NSMutableArray *data) {
//        NSArray *array = [NSArray array];
//        array = [Microblog objectArrayWithKeyValuesArray:data];
//        [self.microblogArray addObjectsFromArray:array];
//        [self processData];
//        [self dismiss];
//    } failed:^(NSString *errorMSG) {
//        [self showImage:nil status:@"没有更多数据"];
//    }];
//    [self.mainView footerEndRefreshing];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.mainView.transform = CGAffineTransformMakeTranslation(0, ty);
                         self.toolbar.transform = CGAffineTransformMakeTranslation(0, ty);
                     }];
    
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         self.mainView.transform = CGAffineTransformIdentity;
                         self.toolbar.transform = CGAffineTransformIdentity;
                     }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        self.toolbar.procLable.hidden = YES;
    }else
    {
        self.toolbar.procLable.hidden = NO;
    }
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect textframe = self.toolbar.textView.frame;
    CGFloat y = newSize.height - textframe.size.height;
    if(y != 0)
    {
        textframe.size.height = newSize.height;
        self.toolbar.textView.frame = textframe;
        CGRect frame = self.toolbar.frame;
        frame.origin.y = self.toolbar.frame.origin.y - y;
        frame.size.height = frame.size.height + y;
        self.toolbar.frame = frame;
        self.toolbar.iconBtn.centerY = self.toolbar.textView.centerY;
        self.toolbar.sendBtn.centerY = self.toolbar.textView.centerY;
         self.toolbar.commentlIneImage.frame = CGRectMake(CGRectGetMinX(self.toolbar.textView.frame) - 2, CGRectGetMaxY(self.toolbar.textView.frame) - 5, self.toolbar.textView.frame.size.width + 4, 4);
    }
   
}

- (void)historyTopic
{
    HistoryTopicViewController *vc = [[HistoryTopicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getMicroblog
{
//    [self show];
//    [self.microblogArray removeAllObjects];
//    pageIndex = 1;
//    [self.netWork GetMicroblogByTagId:self.hotTopic.TagId pageSize:20 pageIndex:1 success:^(NSMutableArray *data) {
//        self.microblogArray = (NSMutableArray *)[Microblog objectArrayWithKeyValuesArray:data];
//        [self processData];
//        [self dismiss];
//    } failed:^(NSString *errorMSG) {
//        [self dismiss];
//    }];
}
- (void)processData
{
    [self.microblogFrameArray removeAllObjects];
    for (Microblog *micrblog in self.microblogArray) {
        MicroblogFrame *microblogFrame = [[MicroblogFrame alloc]init];
        if(micrblog.CommentCentent.count > 6)
        {
            micrblog.CommentCentent = [micrblog.CommentCentent subarrayWithRange:NSMakeRange(0, 6)];
        }
        microblogFrame.micBlog = micrblog;
        [self.microblogFrameArray addObject:microblogFrame];
    }
    [self.mainView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MicroblogFrame *microblogFrame = self.microblogFrameArray[indexPath.row];
    return microblogFrame.cellHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.microblogFrameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [TopicCell cellWithTabelView:tableView];
    cell.topView.commentBtn.tag = indexPath.row;
    cell.topView.praiseBtn.tag = 1000 + indexPath.row;
    cell.bootView.moreBtn.tag = indexPath.row;
    cell.topView.delegate = self;
    cell.bootView.delagete = self;
    cell.microblogFrame = self.microblogFrameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getMicroblog];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
- (void)moreComment:(int)tag
{
    [self.view endEditing:YES];
    MicroblogFrame *microblogFrame = self.microblogFrameArray[tag];
    Microblog *microblog = microblogFrame.micBlog;
    CommentViewController *vc = [[CommentViewController alloc]init];
    vc.micBlog = microblog;
    vc.hotTopic = self.hotTopic;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)btnClick:(int)tag
{
    if (tag >= 1000) {
        MicroblogFrame *microblogFrame = self.microblogFrameArray[tag - 1000];
        Microblog *microblog = microblogFrame.micBlog;
        [self.netWork postPraiseWithtoken:[RRTManager manager].loginManager.loginInfo.tokenId objectId:[NSString stringWithFormat:@"%@",microblog.MicroblogId] typeId:1 success:^(NSDictionary *data) {
            [self getMicroblog];
        } failed:^(NSString *errorMSG) {
            
        }];
        
    }else
    {
        [self.view endEditing:YES];
        MicroblogFrame *microblogFrame = self.microblogFrameArray[tag];
        Microblog *microblog = microblogFrame.micBlog;
        CommentViewController *vc = [[CommentViewController alloc]init];
        vc.micBlog = microblog;
        vc.hotTopic = self.hotTopic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)sendBtnClick
{
    [self.view endEditing:YES];
    if (self.toolbar.textView.text.length!=0) {
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
            }
        }
        else
        {
            int HasPhoto = 0;
            NSString *ImageUrl = @"";
            [self.netWork sendWeibo:[RRTManager manager].loginManager.loginInfo.userId
                               body:[NSString stringWithFormat:@"#%@#%@",self.hotTopic.TagName,self.toolbar.textView.text]
                           HasPhoto:HasPhoto
                           ImageUrl:ImageUrl
                            success:^(NSDictionary *data) {
                                [self showSuccessWithStatus:[data objectForKey:@"Message"]];
                                [self getMicroblog];
                                self.isFaild = NO;
            } failed:^(NSString *errorMSG) {
                
            }];
            self.toolbar.textView.text = @"";
            [self textViewDidChange:self.toolbar.textView];
            self.toolbar.procLable.hidden = NO;
            if (self.imageUrls.count > 0) {
                [self.toolbar removePicView];
            }
        }
    }
    else
    {
        [self showErrorWithStatus:@"发送内容为空"];
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
    NSDictionary *tenmpDict = [dict objectForKey:@"msg"];
    NSString *tempAllImageUrl = [tenmpDict objectForKey:@"ImageUrl"];
    allImageUrl = [NSString stringWithFormat:@"%@,",tempAllImageUrl];
    allImageUrl = [allImageUrl stringByReplacingCharactersInRange:NSMakeRange(allImageUrl.length - 1, 1) withString:@""];
    if (imagecount == self.imageUrls.count) {
        int HasPhoto = 1;
        [self.netWork sendWeibo:[RRTManager manager].loginManager.loginInfo.userId
                           body:[NSString stringWithFormat:@"#%@#%@",self.hotTopic.TagName,self.toolbar.textView.text]
                       HasPhoto:HasPhoto
                       ImageUrl:allImageUrl
                        success:^(NSDictionary *data) {
                            
                            [self showSuccessWithStatus:[data objectForKey:@"Message"]];
                            [self getMicroblog];
                            self.isFaild = NO;
                            
        } failed:^(NSString *errorMSG) {
            [self showErrorWithStatus:errorMSG];
        }];
//        self.toolbar.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
        self.toolbar.textView.text = @"";
        [self textViewDidChange:self.toolbar.textView];
//        self.toolbar.textView.frame = CGRectMake(50, 10,  SCREENWIDTH - 110, 30);
//        self.toolbar.sendBtn.frame = CGRectMake(SCREENWIDTH - 55, 10, 50, 30);
        self.toolbar.procLable.hidden = NO;
//        self.toolbar.iconBtn.frame = CGRectMake(5, 5, 40, 40);
        if (self.imageUrls.count > 0) {
            [self.toolbar removePicView];
        }
        imagecount = 0;
        [self.imageUrls removeAllObjects];
        [self deleteFile];
    }
}

- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
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
    [self.toolbar showPicture:_imageUrls];
}
- (void)deleteFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    for (int i = 0; i < _imageUrls.count; i ++) {
        NSString *uniquePath = _imageUrls[i];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (!blHave) {
            NSLog(@" no  have");
            return ;
        }else {
            NSLog(@" have");
            BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
            
            if (blDele) {
                NSLog(@"dele success");
            }else {
                NSLog(@"dele fail");
            }
        }
    }
    

}

// 相册
#pragma mark - QBImagePickerControllerDelegate 相册
#pragma mark -

- (void)chooseImage
{
    //    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    //    picker.delegate = self;
    //    picker.maximumNumberOfSelectionVideo = 0;
    //    picker.maximumNumberOfSelectionPhoto = 9;
    //    [self presentViewController:picker animated:YES completion:^{
    //
    //    }];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    
    [sheet showInView:self.view];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
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
    [self.toolbar showPicture:_imageUrls];
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
    
//    [self.images removeAllObjects];
//    for (UIView *subView in [self.addImageView subviews]) {
//        if ([subView isKindOfClass:[UIImageView class]]) {
//            [subView removeFromSuperview];
//        }
//    }
//    
//    [self.images addObject:img];
//    [self imageDataToPath:img];
//    [self showImages];
    
    [self.imageUrls removeAllObjects];
    
    img = [UIImage scaleImage:img toScale:0.2];
        
    NSString *imgPath = [self imageDataToPath:img];
    [_selectedImages addObject:img];
    [_imageUrls addObject:imgPath];
    [self.toolbar showPicture:_imageUrls];
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
@end

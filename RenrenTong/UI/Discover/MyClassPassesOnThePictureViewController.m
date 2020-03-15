//
//  MyClassPassesOnThePictureViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/5/12.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MyClassPassesOnThePictureViewController.h"
#import "QBImagePickerController.h"
#import "AlbumListViewController.h"
#import "ASIFormDataRequest.h"
#import "VistorModelCell.h"
#import "UIImage+Addition.h"
#import "AlbumList.h"

#import "JSONHTTPClient.h"
#import "AlbumList.h"

@interface MyClassPassesOnThePictureViewController ()<UITextViewDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *imagePathAry;
    NSString *batchID;
    BOOL isEndPublish;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic) NSMutableArray *images;
@property (nonatomic, strong) id selectedAlbum;
@property (nonatomic, assign) NSInteger uploadValue;

@end

@implementation MyClassPassesOnThePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEndPublish = YES;
    self.title = @"传照片";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickRelease)];
    self.navigationItem.rightBarButtonItem = rightItem;
    /**
     * contentTextView
     */
    self.contentTextView.layer.borderColor = LineColor.CGColor;
    self.contentTextView.userInteractionEnabled = YES;
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.layer.cornerRadius = 3;
    self.contentTextView.delegate = self;
    self.images = [NSMutableArray array];
    imagePathAry = [[NSMutableArray alloc] init];
    self.netWorkManager = [[NetWorkManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didTappedBackground:(UIGestureRecognizer*)ges
{
    [self.view endEditing:YES];
}

- (void)keyboardShow:(NSNotification *)note
{
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - 80;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0,ty);
    }];
}

- (void)keyboardHide:(NSNotification *)note
{
    self.view.transform = CGAffineTransformIdentity;
}

- (void)clickRelease
{
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;
    
    //上传照片
    if (!self.images || [self.images count] <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请先选择要上传的照片"];
        
        return;
    }
    if (!self.selectedAlbum) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"请先选择相册"];
        
        return;
    }
    [self show];
    if (!self.isHideRightNavigationButton && isEndPublish) {
        isEndPublish = NO;
        for (NSInteger i = 0; i < self.images.count; i ++) {
            AlbumListItems *item = (AlbumListItems*)self.selectedAlbum;
            
            ASIFormDataRequest *req = [[ASIFormDataRequest alloc] init];
            req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://class.%@/api/PhotoUpload",aedudomain]]];
            [req setPostValue:self.classId forKey:@"classId"];
            [req setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
            
            [req setPostValue:item.AblumId forKey:@"ablumId"];
            batchID = [UUID uuid];
            batchID = [batchID substringToIndex:16];
            [req setPostValue:batchID forKey:@"batch"];
            [req setFile:(NSString*)[imagePathAry objectAtIndex:i] forKey:@"Filedata"];
            
            [req setTimeOutSeconds:20];
            [req setDelegate:self];
            [req setDidFailSelector:@selector(uploadFailed:)];
            [req setDidFinishSelector:@selector(uploadPicFinished:)];
            [req startAsynchronous];
        }
    }
}

#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self dismiss];
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"图片上传失败" ];
    [self back];
    isEndPublish = YES;
}

- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    
    if (!self.isHideRightNavigationButton) {
        NSString *string = [dict objectForKey:@"id"];
        if (string.length > 0 ) {
            // 添加描述
            NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/UpdatePhotoDes",aedudomain];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:string,@"ids",self.contentTextView.text,@"des",nil];
            
            [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
                AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
                if (albumList.result == 1) {
                    self.uploadValue ++;
                    if (self.uploadValue == self.images.count) {
                    }
                }else{
                    ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
                    [self showImage:nil status:erromodel.msg];
                    [self back];
                }
            } fail:^(id errors) {
                [self showImage:nil status:errors];
                [self back];
            } cache:^(id cache) {
            }];
            // 更新班级最新动态
            AlbumListItems *item = (AlbumListItems*)self.selectedAlbum;
            url = [NSString stringWithFormat:@"http://class.%@/api/PhotoLogAdd",aedudomain];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",item.AblumId,@"ablumId",batchID,@"batchId",[RRTManager manager].loginManager.loginInfo.tokenId,@"token",nil];
            [HttpUtil GetWithUrl:url parameters:dic  success:^(id json) {
                             ErrorModel *errors = [[ErrorModel alloc] initWithString:json
                                                                               error:nil];
                             if (errors.error.intValue != 1) {
                                 [self showImage:nil status:errors.msg];
                             }else{
                                 [self dismiss];
                                 [self back];
                             }
                         } fail:^(id errorss) {
                             [self back];
                             [self showImage:nil status:errorss];
                         } cache:^(id cache) {
                             
                         }];
        }else{
            [self showImage:nil status:@"图片上传失败"];
            [self back];

        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    self.block();
}

/**
 *  添加图片
 *
 *  @param sender
 */
- (IBAction)clickAddImageBtn:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    
    [sheet showInView:self.view];
}
/**
 *  点击选择相册
 *
 *  @param sender
 */
- (IBAction)clickPhotoAlum:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:ActivityStoryBoardName bundle:nil];
    
    
    AlbumListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:
                                   AlbumListVCID];
    vc.isHideRightNavigationButton = !self.isHideRightNavigationButton;
    vc.classId = self.classId;
    __block MyClassPassesOnThePictureViewController *_self = self;
    if (self.isHideRightNavigationButton) {
        vc.block =  ^(AlbumListItems* photoList){
            [_self updateAlbum:photoList];
        };
    }else{
        vc.block =  ^(PhotoList* photoList){
            [_self updateAlbum:photoList];
        };
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)updateAlbum:(id)photoList
{
    if (!self.isHideRightNavigationButton) {
        self.selectedAlbum = photoList;
        AlbumListItems *item = (AlbumListItems*)self.selectedAlbum;
        [self.albumButton setTitle:item.AblumName forState:UIControlStateNormal];
    }
}

- (IBAction)clickPhotographButton:(UIButton *)sender
{
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

- (IBAction)clickPhotoAlbumButton:(UIButton *)sender
{
    //从相册中选择
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    imagePickerController.maximumNumberOfSelection = 9 - self.images.count;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - UITextView Delegate
#pragma mark -
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
    textView.inputView = nil;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.placeHolderLabel setHidden:(textView.text.length == 0) ? NO : YES];
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
        imagePickerController.maximumNumberOfSelection = 9 - self.images.count;
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

#pragma mark - QBImagePickerControllerDelegate 相册
#pragma mark -
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    for (UIView *subView in [self.addImageView subviews]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i = 0; i < [assets count]; i++) {
        ALAsset *asset = (ALAsset*)[assets objectAtIndex:i];
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:assetRep.scale
                                     orientation:(UIImageOrientation)assetRep.orientation];
        
        if ([self.images containsObject:img]) {
            NSLog(@"请勿重复选择图片");
        }else{
            [self imageDataToPath:img];
            [self.images addObject:img];
        }
    }
    
    [self showImages];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate 相机
#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    for (UIView *subView in [self.addImageView subviews]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.images addObject:img];
    [self imageDataToPath:img];
    [self showImages];
}

- (void)showImages
{
    if (self.images && [self.images count] > 0) {
        self.addImageBtn.frame = CGRectMake(10, 5, 40, 40);
        
        CGRect rect = self.addImageView.frame;
        
        int num = [self.images count] + 2;
        int lines = num / 4 + ((num % 4 == 0) ? 0 : 1);
        
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 50 * lines);
        self.addImageView.frame = rect;
        
        self.uploadSelectView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, self.uploadSelectView.frame.size.width, self.uploadSelectView.frame.size.height);
        self.footerView.frame = CGRectMake(8, rect.origin.y + rect.size.height + self.uploadSelectView.frame.size.height , SCREENWIDTH - 16, self.contentTextView.frame.size.height);
        for (int i = 0; i < [self.images count]; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [self.images objectAtIndex:i];
            imageView.frame = CGRectMake(10 + (i % 4) * 50, 5 + (i / 4) * 50, 40, 40);
            
            
            [self.addImageView addSubview:imageView];
        }
        int imageCount = [self.images count];
        self.addImageBtn.frame = CGRectMake(10 + (imageCount % 4) * 50, 5 + (imageCount / 4) * 50, 40, 40);
    }
}

-(void)imageDataToPath:(UIImage*)img
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
    [imagePathAry addObject:imgPath];
}

-(void)deleteChaceImages
{
    for (NSString *url in imagePathAry) {
        NSError *error = nil;
        if([[NSFileManager defaultManager] removeItemAtPath:url error:&error]) {
            NSLog(@"文件移除成功");
        } else {
            NSLog(@"error=%@", error);
        }
    }
    [imagePathAry removeAllObjects];
}
-(void)dealloc
{
    [self deleteChaceImages];
}

@end

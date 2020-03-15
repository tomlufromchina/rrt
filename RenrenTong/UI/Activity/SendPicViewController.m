//
//  SendPicViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-10.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SendPicViewController.h"
#import "FaceBoard.h"
#import "QBImagePickerController.h"
#import "AlbumListViewController.h"
#import "WeiBoContactsTableViewController.h"
#import "ASIFormDataRequest.h"
#import "UIImage+Addition.h"
#import "AlbumList.h"
#import "JSONHTTPClient.h"

@interface SendPicViewController () <UITextViewDelegate,
                                        QBImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                        UIImagePickerControllerDelegate,
                                        UIActionSheetDelegate, WeiBoContacts>
{
    NSMutableArray *imagePathAry;
    BOOL isEndPublish;
}


@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *attachBtn;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIView *uploadSelectView;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;

@property (nonatomic) FaceBoard *faceBoard;

@property (nonatomic) NSMutableArray *images;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@property (nonatomic, strong) id selectedAlbum;


@property(nonatomic, strong)ASIFormDataRequest *request;
@property(nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, assign) NSInteger uploadValue;
@property (nonatomic, strong) NSMutableArray *responseIdsAry;



@end

@implementation SendPicViewController

#pragma mark - ViewController lifecycle
#pragma mark -
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
    isEndPublish = YES;
    self.responseIdsAry = [[NSMutableArray alloc] init];
    imagePathAry = [[NSMutableArray alloc] init];
    self.title = @"传照片";
    
    //ios7适配问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Add right button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(uploadImage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.contentTextView.delegate = self;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 2.0;
    
    self.faceBoard = [[FaceBoard alloc] init];
    
    self.faceBoard.inputTextView = self.contentTextView;
    
    self.images = [NSMutableArray array];
    
    self.netWorkManager = [[NetWorkManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - events
#pragma mark -
- (IBAction)faceBtnClicked:(id)sender
{
    [self.contentTextView resignFirstResponder];
    
    self.contentTextView.inputView = self.faceBoard;
    [self.contentTextView becomeFirstResponder];
}

- (IBAction)attachBtnClicked:(id)sender
{
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;
    
    [self.contentTextView becomeFirstResponder];
    
    [self.navigationController pushViewController:WeiBoContactsVCID
                                   withStoryBoard:ActivityStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        WeiBoContactsTableViewController *vc = (WeiBoContactsTableViewController*)viewController;
        vc.delegate = self;
    }];
}

- (IBAction)addImageBtnClicked:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    
    [sheet showInView:self.view];
}

- (void)uploadImage
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
    
    //1. upload the file to http servce
    [self show];
    if (self.isHideRightNavigationButton ) {
        if (isEndPublish) {
            isEndPublish = NO;
            for (NSInteger i = 0; i < self.images.count; i ++) {
                AlbumListItems *item = (AlbumListItems*)self.selectedAlbum;
                
                ASIFormDataRequest *req = [[ASIFormDataRequest alloc] init];
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://class.%@/api/PhotoUpload",aedudomain]]];
                [req setPostValue:self.classId forKey:@"classId"];
                [req setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
                
                [req setPostValue:item.AblumId forKey:@"ablumId"];
                [req setPostValue:@"1" forKey:@"batch"];
                [req setFile:(NSString*)[imagePathAry objectAtIndex:i] forKey:@"Filedata"];
                
                [req setTimeOutSeconds:20];
                [req setDelegate:self];
                [req setDidFailSelector:@selector(uploadFailed:)];
                [req setDidFinishSelector:@selector(uploadPicFinished:)];
                [req startAsynchronous];

        }
        
            
//            UIImage *image = [UIImage imageWithContentsOfFile:[imagePathAry objectAtIndex:i]];
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",[RRTManager manager].loginManager.loginInfo.tokenId,@"token",item.AblumId,@"ablumId",@"1",@"batch",image,@"Filedata", nil];
//            NSString *url = [NSString stringWithFormat:@"http://class.%@/api/PhotoUpload",aedudomain];
//            [JSONHTTPClient postJSONAndPicturesFromURLWithString:url params:dic completion:^(id json, JSONModelError *err) {
//                if (err) {
//                    NSLog(@"err");
//                }
//            }];
        }
        
    }else{
        if (isEndPublish) {
            isEndPublish = NO;
            for (NSInteger i = 0; i < self.images.count; i ++) {
                ASIFormDataRequest *req = [[ASIFormDataRequest alloc] init];
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://home.%@/Api/PostUploadPhoto",aedudomain]]];
                [req setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
                
                if (self.contentTextView.text.length > 0) {
                    [self.request setPostValue:self.contentTextView.text forKey:@"Description"];
                }
                PhotoList *list = (PhotoList*)self.selectedAlbum;
                [req setPostValue:[NSString stringWithFormat:@"%d", list.AlbumId]
                           forKey:@"AlbumsId"];
                [req setFile:(NSString*)[imagePathAry objectAtIndex:i] forKey:@"file"];
                
                [req setTimeOutSeconds:20];
                [req setDelegate:self];
                [req setDidFailSelector:@selector(uploadFailed:)];
                [req setDidFinishSelector:@selector(uploadPicFinished:)];
                [req startAsynchronous];
            }

        }
        
//        [self.request cancel];
//        [self setRequest:[ASIFormDataRequest requestWithURL:
//                      [NSURL URLWithString:[NSString stringWithFormat:@"http://home.%@/Api/PostUploadPhoto",aedudomain]]]];
//        [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.tokenId forKey:@"token"];
//        
//        if (self.contentTextView.text.length > 0) {
//            [self.request setPostValue:self.contentTextView.text forKey:@"Description"];
//        }
//        PhotoList *list = (PhotoList*)self.selectedAlbum;
//        [self.request setPostValue:[NSString stringWithFormat:@"%d", list.AlbumId]
//                            forKey:@"AlbumsId"];
//        [self.request setFile:(NSString*)[imagePathAry objectAtIndex:0] forKey:@"file"];
//        [self.request setTimeOutSeconds:20];
//        [self.request setDelegate:self];
//        [self.request setDidFailSelector:@selector(uploadFailed:)];
//        [self.request setDidFinishSelector:@selector(uploadPicFinished:)];
//        [self.request startAsynchronous];
//        [self showWithStatus:nil];

    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;
}

- (IBAction)selectAlbum:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:ActivityStoryBoardName bundle:nil];
    
    
    AlbumListViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:
                                     AlbumListVCID];
    vc.isHideRightNavigationButton = self.isHideRightNavigationButton;
    vc.classId = self.classId;
    __block SendPicViewController *_self = self;
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

#pragma mark - QBImagePickerControllerDelegate 相册
#pragma mark -
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
//    [self.images removeAllObjects];
//    [self deleteChaceImages];
    
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
    for (UIView *subView in [self.addImageView subviews]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.images addObject:img];
    [self imageDataToPath:img];
    [self showImages];
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

#pragma mark - WeiBoContacts delegate
#pragma mark -
- (void)sendWeiBoContactsName:(NSString *)name
{
    if (self.contentTextView.text.length == 0) {
        NSString *oldText = self.contentTextView.text;
        self.contentTextView.text = [NSString stringWithFormat:@"%@%@%@ ", oldText, @" @",name];
    } else {
        NSString *oldText = self.contentTextView.text;
        self.contentTextView.text = [NSString stringWithFormat:@"%@%@%@ ", oldText, @" @",name];
    }
    self.placeHolderLabel.hidden = YES;
}

#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self dismiss];
    [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"图片上传失败" ];

    NSLog(@"The error is:%@", theRequest.error);
}


- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    isEndPublish = YES;
    if (self.isHideRightNavigationButton) {
        isEndPublish = NO;
    NSString *string = [dict objectForKey:@"id"];
    if (string.length > 0 ) {
        NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoAblumList",aedudomain];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",nil];
        
        [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
            AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
            if (albumList.result == 1) {
                self.uploadValue ++;
                if (self.uploadValue == self.images.count) {
                    [self dismiss];
                    self.block();
                    isEndPublish = YES;
                    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
                }else{
                    [self showImage:nil status:@"详情提交失败"];
                    isEndPublish = YES;
                }
            }
        } fail:^(id errors) {
            [self showImage:nil status:@"详情提交失败"];
            isEndPublish = YES;
        } cache:^(id cache) {
        }];
    
    }else{
        [self showImage:nil status:@"图片上传失败"];
        isEndPublish = YES;
    }
    }else{
        NSNumber *st = [dict objectForKey:@"st"];
        if (st.integerValue == 0) {
            self.uploadValue ++;
            if (self.uploadValue == self.images.count) {
                [self dismiss];
//                self.block();
                [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
            }
        }else{
            isEndPublish = YES;
            [self showImage:nil status:@"照片上传失败"];
        }
       
    }
}


#pragma mark - Ubility
#pragma mark -
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

- (void)updateAlbum:(id)photoList
{
    if (self.isHideRightNavigationButton) {
        self.selectedAlbum = photoList;
        AlbumListItems *item = (AlbumListItems*)self.selectedAlbum;
        [self.albumButton setTitle:item.AblumName forState:UIControlStateNormal];
    }else{
        self.selectedAlbum = photoList;
        PhotoList *list = (PhotoList*)self.selectedAlbum;
        [self.albumButton setTitle:list.AlbumName forState:UIControlStateNormal];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    self.block();
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

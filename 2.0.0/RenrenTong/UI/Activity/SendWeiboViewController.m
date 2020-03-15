//
//  SendWeiboViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "FaceBoard.h"
#import "QBImagePickerController.h"
#import "WeiBoContactsTableViewController.h"
#import "NetWorkManager.h"
#import "ViewControllerIdentifier.h"
#import "ASIFormDataRequest.h"
#import "UIImage+Addition.h"

@interface SendWeiboViewController () <UITextViewDelegate,
                                        QBImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                        UIImagePickerControllerDelegate,
                                        WeiBoContacts,
                                        UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;

@property (nonatomic) FaceBoard *faceBoard;

@property (nonatomic) NSMutableArray *images;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@property(nonatomic, strong)ASIFormDataRequest *request;

@end

@implementation SendWeiboViewController

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

- (void)dealloc
{
    [self.request setDelegate:nil];
	[self.request setUploadProgressDelegate:nil];
	[self.request cancel];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self dismiss];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发微博";
    
    //ios7适配问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _netWorkManager = [[NetWorkManager alloc] init];

    //Add right button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(sendWeibo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.contentTextView.delegate = self;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:200.0/255
                                                             green:200.0/255
                                                              blue:200.0/255
                                                             alpha:1.0].CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 2.0;
    
    self.faceBoard = [[FaceBoard alloc] init];
    
    self.faceBoard.inputTextView = self.contentTextView;
    
    self.images = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Events
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
    
    [self.contentTextView.delegate textViewDidChange:self.contentTextView];
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
//发送按钮
- (void)sendWeibo
{
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;

    if (self.images && [self.images count] > 0) {
        if ([self validataTheSend]) {
            //1. upload the file to http servce
            [self.request cancel];
            [self setRequest:[ASIFormDataRequest requestWithURL:
                              [NSURL URLWithString:@"http://home.aedu.cn/Api/PostUploadImages"]]];
            [self.request setPostValue:[RRTManager manager].loginManager.loginInfo.userId forKey:@"UserId"];
            [self.request setPostValue:@"1" forKey:@"TypeId"];
            [self.request setTimeOutSeconds:20];
            [self.request setDelegate:self];
            [self.request setDidFailSelector:@selector(uploadFailed:)];
            [self.request setDidFinishSelector:@selector(uploadPicFinished:)];

            [self.request setFile:(NSString*)[self.images objectAtIndex:0] forKey:@"file"];
            
            [self.request startAsynchronous];
            [self showWithStatus:nil];
        }
    } else {
        if ([self validataTheSend]) {
            [self showWithStatus:@""];
            [self.netWorkManager sendWeibo:[RRTManager manager].loginManager.loginInfo.userId
                                      body:self.contentTextView.text
                                  HasPhoto:nil
                                  ImageUrl:nil
                                   success:^(NSDictionary *data) {
                [self dismiss];
                [self gotoMainUI];
            } failed:^(NSString *errorMSG) {
                [self showWithTitle:@"发送微博失败" withTime:2.0f];
            }];
        }
    }
}

- (void)gotoMainUI
{
    [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
    self.block();
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contentTextView resignFirstResponder];
    self.contentTextView.inputView = nil;
}

#pragma mark - TextView Delegate
#pragma mark -
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
    textView.inputView = nil;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.placeholderLabel setHidden:(textView.text.length == 0) ? NO : YES];
}

#pragma mark - QBImagePickerController delegate 相册
#pragma mark -
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//相册Done按钮
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    [self.images removeAllObjects];
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
        
        [self.images addObject:img];
    }
    
    [self showImages];
}

//相机、相册Cancel按钮
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
    
    [self.images removeAllObjects];
    for (UIView *subView in [self.addImageView subviews]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.images addObject:img];
    
    [self showImages];
}


#pragma mark - upload file delegate
#pragma mark-
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [self dismiss];
    [self showWithTitle:@"图片上传失败" withTime:2.0f];
    NSLog(@"The error is:%@", theRequest.error);
    
    //	[resultView setText:[NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]];
}


- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
//    [self dismiss];
    
    NSData *deData = theRequest.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:deData
                                                         options:kNilOptions
                                                           error:nil];
    
    int result = [(NSNumber*)[dict objectForKey:@"result"] intValue];
    if (result == 0) {
        NSDictionary *msgDict = (NSDictionary*)[dict objectForKey:@"msg"];
        NSString *url = [msgDict objectForKey:@"ImageUrl"];
        
        if ([self validataTheSend]) {
            [self.netWorkManager sendWeibo:[RRTManager manager].loginManager.loginInfo.userId
                                      body:self.contentTextView.text
                                  HasPhoto:@"1"
                                  ImageUrl:url
                                   success:^(NSDictionary *data) {
                                       [self dismiss];
                                       [self gotoMainUI];
                                   } failed:^(NSString *errorMSG) {
                                       [self showWithTitle:@"发送微博失败" withTime:2.0f];
                                   }];
        }
    } else {
        [self uploadFailed:theRequest];
    }
}

#pragma mark - UIActionSheet delegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.maximumNumberOfSelection = 1;
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    } else if (buttonIndex == 1){
        //拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: sourceType]) {
            [self showWithTitle:@"该设备不支持拍照" withTime:1.0f];
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}

#pragma mark - ubility
#pragma mark -
/*判断内容是否为空*/
- (BOOL)validataTheSend
{
    if (self.contentTextView.text.length <= 0) {
        [self showWithTitle:@"亲，还没输入内容哦！" defaultStr:nil];
        return NO;
    }
    return YES;
}
//显示压缩图片在View上
- (void)showImages
{
    if (self.images && [self.images count] > 0) {
        self.addImageBtn.frame = CGRectMake(10, 5, 40, 40);
        self.addImageLabel.frame = CGRectMake(60, 5, 50, 40);
        
        CGRect rect = self.addImageView.frame;
        
        int num = [self.images count] + 2;
        int lines = num / 4 + ((num % 4 == 0) ? 0 : 1);
        
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 50 * lines);
        self.addImageView.frame = rect;
        
        for (int i = 0; i < [self.images count]; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [self.images objectAtIndex:i];
            imageView.frame = CGRectMake(10 + (i % 4) * 50, 5 + (i / 4) * 50, 40, 40);
            
            
            [self.addImageView addSubview:imageView];
        }
        
        int imageCount = [self.images count];
        
        self.addImageBtn.frame = CGRectMake(10 + (imageCount % 4) * 50, 5 + (imageCount / 4) * 50, 40, 40);
        
        imageCount++;
        self.addImageLabel.frame = CGRectMake(10 + (imageCount % 4) * 50, 5 + (imageCount / 4) * 50, 50, 40);
        
        //UIImage 对象转换成本地url
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* cachesDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:
                               [NSString stringWithFormat:ActivityPath]];
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:[self.images count]];
        for (int i = 0; i < [self.images count]; i++) {
            NSDate *date = [NSDate date];
            NSTimeInterval name = [date timeIntervalSince1970];
            
            NSString *imgPath = [imagePath stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"%f.png", name]];
            
            UIImage *img = [self.images objectAtIndex:i];
            
            //压缩图片
            img = [UIImage scaleImage:img toScale:0.2];
            
            NSData *imgData = UIImagePNGRepresentation(img);
            [imgData writeToFile:imgPath atomically:YES];
            
            [imageUrls addObject:imgPath];
        }
        
        self.images = imageUrls;
    }
}


#pragma mark - WeiBoContacts delegate
#pragma mark -
//代理传过来的值
- (void)sendWeiBoContactsName:(NSString *)name
{
    if (self.contentTextView.text.length == 0) {
        
    } else {
        NSString *oldText = self.contentTextView.text;
        self.contentTextView.text = [NSString stringWithFormat:@"%@%@%@ ", oldText, @" @",name];
    }
}


@end

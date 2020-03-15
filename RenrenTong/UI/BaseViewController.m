//
//  BaseViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "OpenRemoteNotification.h"
@interface BaseViewController ()
{
    UIView *noDataView;
    UILabel *noDatalabel;
    UILabel *noNetWorklabel;
    UIView *loadingView;
    UIActivityIndicatorView *activityView;
    BOOL isLoading;
    BOOL isNavigationBarHiden;
}
@end

@implementation BaseViewController

#pragma mark - ViewController lifeCycle
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
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                                                     selector: @selector(connectionSuccessed)
                                                                         name: CONNECT_SUCCESS
                                                                       object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(connectionFailed)
                                                 name: CONNECT_FAILED
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(authorSuccess:)
                                                 name: LOGIN_SUCCESS
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(authorFailed:)
                                                 name: LOGIN_FAILED
                                               object: nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self openRemoteNotification];
}
-(void)openRemoteNotification{
    @try {
        if ([RRTManager manager].loginManager&&[RRTManager manager].loginManager.loginInfo) {
            NSUserDefaults* nud=  [NSUserDefaults standardUserDefaults];
            BOOL isopenremotenotification= [[nud objectForKey:@"isopenremotenotification"] boolValue];
            if (!isopenremotenotification) {
                [nud setObject:[NSNumber numberWithBool:YES] forKey:@"isopenremotenotification"];
                [nud synchronize];
                NSDictionary* dic = [nud objectForKey:@"remotenotification"];
                if (dic==nil) {
                    [nud removeObjectForKey:@"remotenotification"];
                    [nud removeObjectForKey:@"isopenremotenotification"];
                }
                NSString* Guid=[dic  objectForKey:@"Guid"];
                NetWorkManager* networkmanager=[[NetWorkManager alloc] init];
                [networkmanager getMessageWithGuid:Guid success:^(NSMutableArray *data) {
                    NSArray *array = [NSArray array];
                    array = [ReceiveMessage objectArrayWithKeyValuesArray:data];
                    if(array.count > 0)
                    {
                        if ([array count]==1) {
                            ReceiveMessage *msg =[array objectAtIndex:0];
                            PacketBuilder* packetPacketBuilder =[Packet builder];
                            
                            [packetPacketBuilder setFrom:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
                            [packetPacketBuilder setTo:[msg.RecieveUser objectForKey:@"UserId"]];
                            
                            MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
                            [messagePacketBuilder setGuid:msg.MessageId];
                            [messagePacketBuilder setState:msg.StatusId];
                            [messagePacketBuilder setType:msg.Type];
                            [messagePacketBuilder setAutoid:[msg.LineId intValue]];
                            
                            MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
                            [messageBodyBuilder setType:msg.BodyType];
                            [messageBodyBuilder setContent:msg.MessageContent];
                            [messageBodyBuilder setPictureuri:msg.Pic[0]];
                            [messageBodyBuilder setAudiouri:msg.Audio[0]];
                            [messageBodyBuilder setSender:[msg.PubUser objectForKey:@"UserName"]];
                            [messageBodyBuilder setReceiver:[RRTManager manager].loginManager.loginInfo.userName];
                            [messageBodyBuilder setSendtime:msg.PubTime];
                            [messageBodyBuilder setPushmsgtype:msg.HeadType];
                            [messageBodyBuilder setUrl:msg.Url];
                            [messageBodyBuilder setUrldesc:msg.UrlDescription];
                            [messageBodyBuilder setUrlpic:msg.UrlPicture];
                            [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
                            
                            [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
                            
                            Packet*   pk =[packetPacketBuilder build];
                            [[IMCache shareIMCache] savePacket:pk sessionid:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
                            
                            [nud removeObjectForKey:@"remotenotification"];
                            [nud removeObjectForKey:@"isopenremotenotification"];
                            [nud synchronize];
                            [OpenRemoteNotification openRemoteNotification:pk navigationController:self.navigationController msg:msg];
                        }
                    }
                } failed:^(NSString *errorMSG) {
                    [nud setObject:[NSNumber numberWithBool:NO] forKey:@"isopenremotenotification"];
                    [nud synchronize];
                }];

            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    SDImageCache *imageCache = [SDWebImageManager sharedManager].imageCache;
    NSString *cache = [NSString stringWithFormat:@"%.1fM", imageCache.getSize / (1024 * 1024.0)];
    if (![cache isEqualToString:@"0.0M"]) {
        // clearDisk清文件
        [[SDImageCache sharedImageCache] clearDisk];
        // clearMemory清内存。
        [[SDImageCache sharedImageCache] clearMemory];
        
    } else {
    }
    // Dispose of any resources that can be recreated.
}

#pragma mark - show HUD
#pragma mark -

- (void)show
{
    [SVProgressHUD show];
}

- (void)showImage:(UIImage *)image status:(NSString *)string
{
    [SVProgressHUD showImage:image status:string];
    
}

- (void)showWithStatus:(NSString*)status
{
    [SVProgressHUD showWithStatus:status];
}

- (void)showProgress:(CGFloat)progress
{
    [SVProgressHUD showProgress:progress];
}

- (void)showProgress:(CGFloat)progress status:(NSString*)status
{
    [SVProgressHUD showProgress:progress status:status];
}

- (void)showSuccessWithStatus:(NSString*)string
{
    [SVProgressHUD showSuccessWithStatus:string];
}

- (void)showErrorWithStatus:(NSString *)string
{
    [SVProgressHUD showErrorWithStatus:string];
}

- (void)showWithTitle:(NSString *)title withTime:(NSTimeInterval)time
{
    //    [SVProgressHUD showWithTitle:title withTime:time];
}

- (void)showWithTitle:(NSString *)title defaultStr:(NSString *)defaultStr
{
    //    [SVProgressHUD showWithTitle:title defaultStr:defaultStr];
}

- (void)dismiss
{
    [SVProgressHUD dismiss];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONNECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONNECT_SUCCESS object:nil];
}

-(void)connectionSuccessed{
    Connection * connection=[Connection shareConnection];
    if (![connection isLogin]&&[connection connectionopen]) {
        [connection Auth];
        NSLog(@"%@",@"消息服务器连接成功");
    }
}
-(void)connectionFailed{
    Connection * connection=[Connection shareConnection];
    if (![connection connectionopen]&&![connection isLogin]&&![connection reConnectioning]) {
        [connection reConnect];
    }
}


-(void)authorSuccess:(NSNotification*)notefication{
    //    NSLog(@"%@",[notefication object]);
    if (([notefication object]!=nil)) {
        @try {
            NSData* jsondata = [[notefication object] dataUsingEncoding:NSUTF8StringEncoding];
            id responseJSON = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
            int status=[[responseJSON objectForKey:@"status"] intValue];
            if (status==0) {
                NSLog(@"%@",@"消息服务器登陆成功！");
            }else{
                [self connectionFailed];
            }
        }
        @catch (NSException *exception) {
            [self connectionFailed];
        }
    }else{
        [self connectionFailed];
    }
}

-(void)authorFailed:(NSNotification*)notefication{
    NSLog(@"%@",@"消息服务器登陆失败！！");
    [[Connection shareConnection] setLogin:NO];
    NSLog(@"%@",[notefication object]);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismiss];
}

- (void)deleteFile:(NSMutableArray *)array
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    for (int i = 0; i < array.count; i ++) {
        NSString *uniquePath = array[i];
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


-(void)setUpNavigation
{
    isNavigationBarHiden = YES;
    _navigationCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [_navigationCenterView setBackgroundColor:theLoginButtonColor];
    [self.view addSubview:_navigationCenterView];
    
    //添加标题控件
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navigationCenterView.frame.size.width-200)/2.0, 20, 200, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_navigationCenterView addSubview:_titleLabel];
    
    //添加导航栏左侧按钮
    _navigationLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _navigationLeftButton.backgroundColor = [UIColor clearColor];
    [_navigationLeftButton setFrame:CGRectMake(0, 20, 44, 44)];
    [_navigationLeftButton addTarget:self action:@selector(navigationLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationLeftButton setBackgroundImage:[UIImage imageNamed:@"menu_btn_normal"] forState:UIControlStateNormal];
    [_navigationCenterView addSubview:_navigationLeftButton];
    
    //添加导航栏右侧按钮
    _navigationRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _navigationRightButton.backgroundColor = [UIColor clearColor];
    [_navigationRightButton setFrame:CGRectMake(_navigationCenterView.frame.size.width-44, 30, 24, 24)];
    [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"msg_btn_normal"] forState:UIControlStateNormal];
    [_navigationRightButton addTarget:self action:@selector(navigationRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationCenterView addSubview:_navigationRightButton];
}
-(void)navigationLeftButtonClick:(UIButton*)sender
{
    NSLog(@"复写此方法: navigationLeftButtonClick:");
}

-(void)navigationRightButtonClick:(UIButton*)sender
{
    NSLog(@"复写此方法: navigationRightButtonClick:");
}

-(void)showNoDataView:(NSString*)notifyText
{
    if (notifyText.length == 0) {
        notifyText = @"没有数据哦～～";
    }
    if (!noDataView) {
        noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
        noDataView.backgroundColor = [UIColor redColor];
        [self.view addSubview:noDataView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/3, SCREENWIDTH/3)];
        imageView.image = [UIImage imageNamed:@"Icon_5"];
        imageView.center = CGPointMake(noDataView.frame.size.width/2 , noDataView.frame.size.height/2 - 50);
        imageView.backgroundColor = [UIColor redColor];
        [imageView stopAnimating];
        [noDataView addSubview:imageView];
        
        noDatalabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(imageView.frame) + 10, SCREENWIDTH - 60, 30)];
        noDatalabel.font = [UIFont systemFontOfSize:15];
        noDatalabel.backgroundColor = [UIColor grayColor];
        noDatalabel.numberOfLines = 0;
        noDatalabel.textAlignment = NSTextAlignmentCenter;
        [noDataView addSubview:noDatalabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREENWIDTH/2 -  50, CGRectGetMaxY(noDatalabel.frame), 100, 44);
        [btn addTarget:self action:@selector(showUploadView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"点击刷新" forState:UIControlStateNormal];
        btn.titleLabel.font = noDatalabel.font;
        [noDataView addSubview:btn];
    }
    noDatalabel.text = notifyText;
}
-(void)dismissNoDataView
{
    [UIView animateWithDuration:0.35 delay:0  options:UIViewAnimationOptionBeginFromCurrentState
     | UIViewAnimationCurveLinear animations:^{
         noDataView.alpha = 0;
     } completion:^(BOOL finished) {
         [noDataView removeFromSuperview];
     }];
}
/**
 * 提示界面（）
 *
 *  @param message 提示信息
 */
-(void)showUploadView:(NSString*)message
{
    if (!loadingView) {
        if (isNavigationBarHiden) {
            loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, SCREENWIDTH, 40)];
        } else{
            loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 40)];
        }
        loadingView.backgroundColor = [UIColor colorWithRed:252/255.0 green:243/255.0 blue:188/255.0 alpha:1];
        loadingView.alpha = 1;
        [self.view addSubview:loadingView];
        
        UIImageView *warnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warn"]];
        warnImage.frame = CGRectMake(20, 10, 20, 20);
        [loadingView addSubview:warnImage];
        
        noNetWorklabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(warnImage.frame) + 10, 0, SCREENWIDTH - 70, loadingView.frame.size.height)];
        noNetWorklabel.textColor = MainTextColor;
        noNetWorklabel.textAlignment = NSTextAlignmentLeft;
        noNetWorklabel.font = [UIFont systemFontOfSize:13];
        [loadingView addSubview:noNetWorklabel];
        
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        activityView.center = CGPointMake(CGRectGetMinX(noDatalabel.frame) - 50, loadingView.frame.size.height/2);
        [activityView startAnimating];
        ;
        [loadingView addSubview:activityView];
    }
    if ([message isEqualToString:LoadingMsg] && [message isEqualToString:noNetWorklabel.text]) {
        activityView.alpha = 1;
    }
    noNetWorklabel.text = message;
    if (isLoading) {
        return;
    }
    isLoading = YES;

    [UIView animateWithDuration:0.35 delay:0  options:UIViewAnimationOptionBeginFromCurrentState
     | UIViewAnimationCurveLinear animations:^{
         loadingView.alpha = 1;
         [self.view bringSubviewToFront:loadingView];
         loadingView.frame = CGRectMake(loadingView.frame.origin.x, loadingView.frame.origin.y + 40, loadingView.frame.size.width, loadingView.frame.size.height);
     } completion:^(BOOL finished) {
         if (![message isEqualToString:LoadingMsg]) {
             [self dismissUploadingView];
         }
     }];
}
-(void)dismissUploadingView
{
    [UIView animateWithDuration:0.35 delay:1  options:UIViewAnimationOptionBeginFromCurrentState
      | UIViewAnimationCurveLinear animations:^{
          loadingView.frame = CGRectMake(loadingView.frame.origin.x, loadingView.frame.origin.y - 40, loadingView.frame.size.width, loadingView.frame.size.height);
          loadingView.alpha = 0;
      } completion:^(BOOL finished) {
          [self.view sendSubviewToBack:loadingView];
          isLoading = NO;
      }];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end

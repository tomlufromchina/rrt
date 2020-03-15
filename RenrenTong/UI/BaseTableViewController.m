//
//  BaseTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

#pragma mark - ViewController lifecycle
#pragma mark -
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self openRemoteNotification];
}

-(void)openRemoteNotification{
    @try {
        if ([RRTManager manager].loginManager&&[RRTManager manager].loginManager.loginInfo) {
            NSUserDefaults* nud=  [NSUserDefaults standardUserDefaults];
            NSDictionary* dic = [nud objectForKey:@"remotenotification"];
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
                        [OpenRemoteNotification openRemoteNotification:pk navigationController:self.navigationController msg:msg];
                    }
                }
            } failed:^(NSString *errorMSG) {
                
            }];
        }
    }
    @catch (NSException *exception) {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma mark - refresh and load more
#pragma mark -
- (void)enableRefresh:(BOOL)bRefresh action:(SEL)action
{
    if (bRefresh) {
        [self.tableView addHeaderWithTarget:self action:action];
    } else {
        [self.tableView removeHeader];
    }
}

- (void)enableLoadMore:(BOOL)bLoadMore action:(SEL)action
{
    if (bLoadMore) {
        [self.tableView addFooterWithTarget:self action:action];
    } else {
        [self.tableView removeFooter];
    }
}

- (void)endRefresh
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

- (void)endLoadMore
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

@end

//
//  CommunicationGuardianViewController.m
//  RenrenTong
//
//  Created by aedu on 15/1/30.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CommunicationGuardianViewController.h"
#import "CommunicationGuardianCell.h"
#import "MJRefresh.h"
#import "MessageCell.h"
#import "GuardianDetailsViewController.h"
#import "NetWorkManager+SchoolAndHouse.h"
#import "MJExtension.h"
#import "ReceiveMessage.h"
#import "NoNavViewController.h"
#import "TheMessageRecordViewController.h"


@interface CommunicationGuardianViewController ()
{
    int recpageIndex;
    int recpageSize;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
/**
 *  信息数据
 */
@property (nonatomic, strong) NSMutableArray *messageData;

@property (nonatomic, strong) NSString *userId;


@end

@implementation CommunicationGuardianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (self.theTitle) {
//        self.title = self.theTitle;
//
//    } else{
//        self.title = @"信息列表";
//
//    }
    NSString *roleStr = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
    if ([roleStr isEqualToString:@"1"] ||[roleStr isEqualToString:@"2"] ) {
        self.title = @"家校消息";
    } else{
        self.title = @"学校通知";
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    
        //Add right button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"短信记录"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(msgRecord)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    self.messageData = [NSMutableArray array];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self getMessageData];
    [self setupRefresh];
}

#pragma mark -- 短信记录

- (void)msgRecord
{
    [self.navigationController pushViewController:TheMessageRecordVCID
                                   withStoryBoard:DeskStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            TheMessageRecordViewController *vc = (TheMessageRecordViewController *)viewController;
                                            vc.theMsgType = self.headType;
                                        }];
}

- (void)getMessageData
{
    [self.netWorkManager GetMessagesWithUserId:[RRTManager manager].loginManager.loginInfo.userId
                                      FromOrTo:2
                                      newOrOld:@"true"
                                          type:3
                                       success:^(NSMutableArray *data) {
                                              self.messageData = (NSMutableArray *)[ReceiveMessage objectArrayWithKeyValuesArray:data];
                                              [self processingData:self.messageData];
                                              [self.tableView reloadData];

                                      } failed:^(NSString *errorMSG) {
    
                                      }];
}
#pragma mark -- 刷新
#pragma mark --
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerReresh)];
}

#pragma mark - 上拉刷新和下拉加载
#pragma mark -
- (void)headerReresh
{
    [self.messageData removeAllObjects];
    [self getMessageData];
    [self.tableView headerEndRefreshing];
    
}
- (void)footerReresh
{
    ReceiveMessage *msg = self.messageData.lastObject;
    [self.netWorkManager getMoreMessagesWithUserId:[RRTManager manager].loginManager.loginInfo.userId
                                          HeadType:self.headType FromOrTo:2 newOrOld:@"false"
                                              type:3  LineId:msg.LineId success:^(NSMutableArray *data) {
                                                  NSArray *array = [NSArray array];
                                                  array = [ReceiveMessage objectArrayWithKeyValuesArray:data];
                                                  [self processingData:array];
                                                  [self.messageData addObjectsFromArray:array];
                                                  [self.tableView reloadData];
                                                  
                                              } failed:^(NSString *errorMSG) {
                                                  
                                              }];
    [self.tableView footerEndRefreshing];
    
}


- (void)processingData:(NSArray *)array
{
    for (ReceiveMessage *msg in array) {
        PacketBuilder* packetPacketBuilder =[Packet builder];
        
        [packetPacketBuilder setFrom:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
        [packetPacketBuilder setTo:[RRTManager manager].loginManager.loginInfo.userId];
        
        MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
        [messagePacketBuilder setGuid:msg.MessageId];
        [messagePacketBuilder setState:msg.StatusId];
        [messagePacketBuilder setType:msg.Type];
        
        MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
        [messagePacketBuilder setAutoid:[msg.LineId intValue]];
        [messageBodyBuilder setType:msg.BodyType];
        [messageBodyBuilder setContent:msg.MessageContent];
        [messageBodyBuilder setPictureuri:msg.Pic[0]];
        [messageBodyBuilder setAudiouri:msg.Audio[0]];
        [messageBodyBuilder setSender:[msg.PubUser objectForKey:@"UserName"]];
        [messageBodyBuilder setReceiver:[RRTManager manager].loginManager.loginInfo.userName];
        [messageBodyBuilder setSendtime:msg.PubTime];
        [messageBodyBuilder setPushmsgtype:msg.HeadType];
        [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
        
        [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
        
        Packet* packetMsg =[packetPacketBuilder build];
        [[IMCache shareIMCache] savePacket:packetMsg sessionid:[NSString stringWithFormat:@"%@",[msg.PubUser objectForKey:@"UserId"]]];
    }
    NSMutableArray* unreads=[[IMCache shareIMCache] getUnReadPushPacket:[RRTManager manager].loginManager.loginInfo.userId];
    for (Packet* p in unreads) {
        [[IMCache shareIMCache] updatePacketState:p.message.guid state:3];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageData.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommunicationGuardianCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.messageData count] > 0) {
        ReceiveMessage *msg = self.messageData[indexPath.row];
        if (msg.HeadType == 2) {
            cell.msgIcon.image = [UIImage imageNamed:@"tz"];
            cell.msgLabel.text = @"通知";
        }else if (msg.HeadType == 8)
        {
            cell.msgIcon.image = [UIImage imageNamed:@"zy"];
            cell.msgLabel.text = @"作业";
        }else if (msg.HeadType == 11)
        {
            cell.msgIcon.image = [UIImage imageNamed:@"tz"];
            cell.msgLabel.text = @"通知";
        } else{
            cell.msgIcon.image = [UIImage imageNamed:@"tz"];
            cell.msgLabel.text = @"通知";
        }
        cell.timeLabel.text = msg.MessageContent;
        cell.theTimeLabel.text = msg.PubTime;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GuardianDetailsViewController *deVC = [[GuardianDetailsViewController alloc]init];
    deVC.message = self.messageData[indexPath.row];
    NSLog(@"%@",deVC.message);
    [self.navigationController pushViewController:deVC animated:NO];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self dismiss];
}

@end

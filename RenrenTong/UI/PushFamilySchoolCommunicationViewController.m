//
//  PushFamilySchoolCommunicationViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PushFamilySchoolCommunicationViewController.h"
#import "GuardianDetailsViewController.h"
#import "NetWorkManager+SchoolAndHouse.h"
#import "MJRefresh.h"
#import "MessageCell.h"

@interface PushFamilySchoolCommunicationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int recpageIndex;
    int recpageSize;
}
@property (nonatomic, strong) NetWorkManager *netWorkManager;
@property (nonatomic, strong) NSMutableArray *messageData;

@end

@implementation PushFamilySchoolCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *roleStr = [NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole];
    if ([roleStr isEqualToString:@"1"] ||[roleStr isEqualToString:@"2"] ) {
        self.title = @"家校消息";
    } else{
        self.title = @"学校通知";
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.messageData = [NSMutableArray array];
    self.netWorkManager = [[NetWorkManager alloc] init];
    [self getMessageData];
    [self setupRefresh];
}

#pragma mark -- 获取消息内容

- (void)getMessageData
{
    [self.messageData removeAllObjects];
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
    
}

- (void)footerReresh
{
    
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
//    NSMutableArray* unreads=[[IMCache shareIMCache] getUnReadPushPacket:self.headType userid:[RRTManager manager].loginManager.loginInfo.userId];
//    for (Packet* p in unreads) {
//        [[IMCache shareIMCache] updatePacketState:p.message.guid state:3];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE object:nil];
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
    ReceiveMessage *msg = self.messageData[indexPath.row];
    if (msg.HeadType == 2) {
        cell.msgIcon.image = [UIImage imageNamed:@"ls_chengji"];
    }else if (msg.HeadType == 8)
    {
        cell.msgIcon.image = [UIImage imageNamed:@"ls_zuoye"];
    }else if (msg.HeadType == 11)
    {
        cell.msgIcon.image = [UIImage imageNamed:@"ls_tongzhi"];
    }
    cell.msgLabel.text = msg.MessageContent;
    cell.timeLabel.text = msg.PubTime;
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

@end

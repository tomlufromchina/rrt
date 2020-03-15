//
//  MessageTableViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MessageTableViewController.h"
#import "ViewControllerIdentifier.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "ComtactMessageCell.h"
#import "MessageNetService.h"

@interface MessageTableViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *mostRecentMessages; //最新消息列表
@property (nonatomic, strong) NetWorkManager *net;


@end

@implementation MessageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigation];
    self.titleLabel.text = @"聊天";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.navigationRightButton setTitle:@"联系人" forState:UIControlStateNormal];
    [self.navigationRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationRightButton.frame = CGRectMake(SCREENWIDTH - 60, 20, 50, 44);
    
    
    [self setExtraCellLineHidden:self.tableView];
    nochatview=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH-64, SCREENHEIGHT-64-49)];
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, SCREENWIDTH- 40, 50)];
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.numberOfLines = 0;
    testLabel.textColor = [UIColor lightGrayColor];
    testLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"老师同学和家长都在“联系人”中试试与他们联系一下吧！"];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:16.0]
                          range:NSMakeRange(9, 5)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:theLoginButtonColor
                          range:NSMakeRange(9, 5)];
    testLabel.attributedText = AttributedStr;
    [nochatview addSubview:testLabel];
    
    UIImageView * nochatimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cst-"]];
    nochatimg.frame = CGRectMake((SCREENWIDTH-212) * 0.5, testLabel.bottom + 10, 212, 171);
    [nochatview addSubview:nochatimg];
    
    UILabel *noticeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, nochatimg.bottom + 10, SCREENWIDTH - 40, 50)];
    noticeLabel1.text = @"新增群聊功能哦！";
    noticeLabel1.numberOfLines = 0;
    noticeLabel1.font = [UIFont systemFontOfSize:16];
    noticeLabel1.textColor = [UIColor lightGrayColor];
    noticeLabel1.textAlignment = NSTextAlignmentCenter;
    noticeLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    [nochatview addSubview:noticeLabel1];
    
    UIButton* chatsomebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatsomebtn.frame = CGRectMake(noticeLabel1.left, noticeLabel1.bottom + 5, noticeLabel1.width, 40);
    chatsomebtn.backgroundColor = theLoginButtonColor;
    [chatsomebtn setTitle:@"开始聊天" forState:UIControlStateNormal];
    [chatsomebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chatsomebtn addTarget:self action:@selector(gotoChat:) forControlEvents:UIControlEventTouchUpInside];
    [nochatview  addSubview:chatsomebtn];
    [self.view addSubview:nochatview];
    nochatview.hidden=YES;
    self.mostRecentMessages =  [[IMCache shareIMCache] queryPacketFriendSessionList:[RRTManager manager].loginManager.loginInfo.userId];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    netWorkManager=[[NetWorkManager alloc] init];
    [self getUserGroup];
}
-(void)reloadView:(NSArray*)groupData
{
    for (GroupModelMsg *group in groupData) {
        if (![[IMCache shareIMCache] hasGroupMessage:[RRTManager manager].loginManager.loginInfo.userId groupid:group.GroupId]) {
            PacketBuilder* packetPacketBuilder =[Packet builder];
            
            [packetPacketBuilder setFrom:group.GroupId];
            [packetPacketBuilder setTo:[RRTManager manager].loginManager.loginInfo.userId];
            
            MessagePacketBuilder* messagePacketBuilder=[MessagePacket builder];
            [messagePacketBuilder setGuid:[UUID uuid]];
            [messagePacketBuilder setState:4];
            [messagePacketBuilder setType:MessageTypeGroupChat];
            
            
            MessageBodyBuilder* messageBodyBuilder=[MessageBody builder];
            [messageBodyBuilder setType:MessageContentTypePlain];
            [messageBodyBuilder setContent:@"官方客服：这里是群聊，快来试试吧！"];
            [messageBodyBuilder setSender:@"官方客服"];
            [messageBodyBuilder setReceiver:[RRTManager manager].loginManager.loginInfo.userName];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
            [messageBodyBuilder setSendtime:currentDateStr];
            [messageBodyBuilder setGroupid:group.GroupId];
            [messageBodyBuilder setGroupname:group.GroupName];
            [messageBodyBuilder setGrouptype:group.GroupType];
            [messagePacketBuilder setBodyBuilder:messageBodyBuilder];
            
            [packetPacketBuilder setMessageBuilder:messagePacketBuilder];
            
            Packet* msg =[packetPacketBuilder build];
            [[IMCache shareIMCache] savePacket:msg sessionid:[NSString stringWithFormat:@"%@%@",msg.message.body.groupid,msg.to]];
            [self.mostRecentMessages addObject:msg];
        }
    }
    if (self.mostRecentMessages&&self.mostRecentMessages.count>0) {
        nochatview.hidden=YES;
        [self.tableView reloadData];
    } else {
        nochatview.hidden=NO;
    }

}
- (void)getUserGroup
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetUserGroup",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[RRTManager manager].loginManager.loginInfo.userRole,@"userRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GroupModel *loginModel = [[GroupModel alloc] initWithString:json error:nil];
        if (loginModel.st == 0) {
           [self reloadView:loginModel.msg];
        }
    } fail:^(id errors) {
    } cache:^(id cache) {
    }];
}
/**
 *  大数据统计
 *
 *  @param key BigData
 */
- (void)bigData:(BigData)key
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *theAppVersion = [NSString stringWithFormat:@"v%@",appVersion];
    NSString *url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/RecordAppClick",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[RRTManager manager].loginManager.loginInfo.userId,@"userId",[NSString stringWithFormat:@"%d",key],@"ppId",@"3",@"productId",theAppVersion,@"version",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        //不作任何处理
    } fail:^(id errors) {
        
    } cache:^(id cache) {
        
    }];
}
-(void)navigationRightButtonClick:(UIButton*)sender
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:ContactVCID
                                   withStoryBoard:MainStoryBoardName
                                        withBlock:nil];
    if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
        [self bigData:S_ContactList];
    } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
        [self bigData:P_ContactList];
        
    } else{
        [self bigData:T_ContactList];
        
    }
    
}
-(void)message:(NSNotification*)notefication{
    if (self.mostRecentMessages) {
        [self.mostRecentMessages removeAllObjects];
        [self getUserGroup];
    }
    self.mostRecentMessages =  [[IMCache shareIMCache] queryPacketFriendSessionList:[RRTManager manager].loginManager.loginInfo.userId];
    if (self.mostRecentMessages&&self.mostRecentMessages.count>0) {
        nochatview.hidden=YES;
        [self.tableView reloadData];
    } else {
        nochatview.hidden=NO;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MESSAGE object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBushBaoCun object:nil];
    
}



-(void)gotoChat:(UIButton*)sender{
    [self.navigationController pushViewController:@"ContactTableViewController"
                                   withStoryBoard:MainStoryBoardName
                                        withBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    if (self.mostRecentMessages) {
        [self.mostRecentMessages removeAllObjects];
    }
    self.mostRecentMessages =  [[IMCache shareIMCache] queryPacketFriendSessionList:[RRTManager manager].loginManager.loginInfo.userId];
    if (self.mostRecentMessages&&self.mostRecentMessages.count>0) {
        nochatview.hidden=YES;
        [self.tableView reloadData];
    } else {
        nochatview.hidden=NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mostRecentMessages count];
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 0.0;
    return height = (section == 0) ? 0 : 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactMessageCell";
    ComtactMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ComtactMessageCell" owner:self options:nil] lastObject];
    }
    UIImageView *avatar = (UIImageView*)[cell viewWithTag:1];
    UILabel *name = (UILabel*)[cell viewWithTag:2];
    UILabel *body = (UILabel*)[cell viewWithTag:3];
    UILabel *time = (UILabel*)[cell viewWithTag:4];
    UIView *tip = (UIView*)[cell viewWithTag:5];
    UILabel *tipCount = (UILabel*)[cell viewWithTag:6];
    
    avatar.layer.cornerRadius = 5.0;
    avatar.layer.masksToBounds = YES;
    Packet* packet=[self.mostRecentMessages objectAtIndex:indexPath.row];
    name.top=avatar.top;
    body.bottom=avatar.bottom;
    time.top=avatar.top;
    int unread=0;
    if (packet.message.type==MessageTypeChat) {
        if ([packet.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
            name.text = packet.message.body.receiver;
            [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain,packet.to]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            unread =[[IMCache shareIMCache] getSessionBrageFriendID:packet.to userid:packet.from];
        }else{
            name.text = packet.message.body.sender;
            [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.%@/avatars/%@.jpg",aedudomain,packet.from]] placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
            unread =[[IMCache shareIMCache] getSessionBrageFriendID:packet.from userid:packet.to];
        }
    } else if(packet.message.type==MessageTypeGroupChat){
        name.text = packet.message.body.groupname;
        if ([name.text containsString:@"教师"]) {
            [avatar setImage:[UIImage imageNamed:@"teacher_group"]];
        }else if ([name.text containsString:@"学生"]) {
            [avatar setImage:[UIImage imageNamed:@"student_group"]];
        }else if([name.text containsString:@"家长"]) {
            [avatar setImage:[UIImage imageNamed:@"parents_group"]];
        }
        
        unread =[[IMCache shareIMCache] getSessionBrageGroupid:packet.message.body.groupid userid:packet.to];
    }
    
    if (packet.message.body.hasPictureuri) {
        body.text = @"[图片]";
    }
    if (packet.message.body.hasAudiouri) {
        body.text = @"[语音]";
    }
    if (packet.message.body.hasContent) {
        body.text = packet.message.body.content;
    }
    tip.top=avatar.top-17;
    if (unread > 0) {
        [tip setHidden:NO];
        tipCount.text = [NSString stringWithFormat:@"%d", unread];
    } else {
        [tip setHidden:YES];
        tipCount.text = @"";
    }
    
    
    time.text = packet.message.body.sendtime;
    
    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:ChatVCID
                                   withStoryBoard:MessageStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
                                            ChatViewController *vc = (ChatViewController*)viewController;
                                            Packet *contact = (Packet*)[self.mostRecentMessages objectAtIndex:indexPath.row];
                                            if (contact.message.type==MessageTypeChat) {
                                                if ([contact.from isEqualToString:[RRTManager manager].loginManager.loginInfo.userId]) {
                                                    vc.UserId =[NSString stringWithFormat:@"%@",contact.to];
                                                    vc.UserName=contact.message.body.receiver;
                                                }else{
                                                    vc.UserId =[NSString stringWithFormat:@"%@",contact.from];
                                                    vc.UserName=contact.message.body.sender;
                                                }
                                            } else if(contact.message.type==MessageTypeGroupChat&&contact.message.body.hasGroupid) {
                                                vc.UserId =contact.message.body.groupid;
                                                vc.UserName=contact.message.body.groupname;
                                                vc.groupType=[contact.message.body.grouptype intValue];
                                            }
                                        }];
}

- (void)messageComming
{
    //    [self updateData:[RRTManager manager].imManager];
}

#pragma mark - DAContextMenuCell delegate
#pragma mark -
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
//    [super contextMenuCellDidSelectDeleteOption:cell];
    
    //    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //
    //    NSManagedObjectContext *context = [[RRTManager manager].imManager.xmppMessageArchivingStorage
    //                                       mainThreadManagedObjectContext];
    //
    //    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
    //                                                                objectAtIndex:indexPath.row];
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:
    //                @"messageStr CONTAINS[cd] %@ && messageStr CONTAINS[cd] %@",
    //                 mostMessage.streamBareJidStr,
    //                 mostMessage.bareJidStr];
    //
    //    NSEntityDescription *entity = [[RRTManager manager].imManager.xmppMessageArchivingStorage messageEntity:context];
    //    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    [request setEntity:entity];
    //
    //    [request setPredicate:predicate];
    //    NSArray *array = [context executeFetchRequest:request error:nil];
    //
    //    for (NSManagedObject *obj in array) {
    //        [context deleteObject:obj];
    //    }
    //
    //    [context deleteObject:mostMessage];
    //    [context save:nil];
    //
    //
    //    [self.mostRecentMessages removeObjectAtIndex:indexPath.row];
    //    [self.unreadCounts removeObjectAtIndex:indexPath.row];
    //
    //    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //    if ([self.mostRecentMessages count]>0) {
    //        nochatview.hidden=YES;
    //    }else{
    //        nochatview.hidden=NO;
    //    }
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    //    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //
    //    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
    //                                                                objectAtIndex:indexPath.row];
    //
    //    NSString *topString = [mostMessage.bToped boolValue] ? @"取消置顶" : @"置顶聊天";
    //
    //    int unread = [(NSNumber*)[self.unreadCounts objectAtIndex:indexPath.row] intValue];
    //
    //    NSString *unReadString = unread > 0 ? @"标记已读" : @"标记未读";
    //
    //
    //
    //
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"取消"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:unReadString, topString, nil];
    //    actionSheet.tag = indexPath.row;
    //    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex == 0) {
    //        //标记未读 或者 已读
    //        [self markUnread:actionSheet.tag];
    //    } else if (buttonIndex == 1) {
    //        //置顶聊天 或者 取消置顶
    //        [self topChat:actionSheet.tag];
    //    }
}

- (void)topChat:(int)index
{
    //    NSManagedObjectContext *context = [[RRTManager manager].imManager.xmppMessageArchivingStorage
    //                                       mainThreadManagedObjectContext];
    //
    //    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
    //                                                                objectAtIndex:index];
    //
    //    mostMessage.bToped = [NSNumber numberWithBool:![mostMessage.bToped boolValue]];
    //    mostMessage.topedTimestamp = [NSDate date];
    //
    //    [context save:nil];
    //
    //    [self updateData:[RRTManager manager].imManager];
}

- (void)markUnread:(int)index
{
    //    NSManagedObjectContext *context = [[RRTManager manager].imManager.xmppMessageArchivingStorage
    //                                       mainThreadManagedObjectContext];
    //
    //    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //
    //    NSEntityDescription *entity = [[RRTManager manager].imManager.xmppMessageArchivingStorage
    //                                   messageEntity:context];
    //    [request setEntity:entity];
    //
    //    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
    //                                                                objectAtIndex:index];
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:
    //                          @"messageStr CONTAINS[cd] %@ && messageStr CONTAINS[cd] %@",
    //                 mostMessage.streamBareJidStr,
    //                 mostMessage.bareJidStr];
    //
    //    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    //    [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
    //
    //    [request setPredicate:predicate];
    //
    //    int unread = [(NSNumber*)[self.unreadCounts objectAtIndex:index] intValue];
    //    if (unread > 0) {
    //        //标记已读
    //        NSArray *array = [context executeFetchRequest:request error:nil];
    //
    //        for (int i = [array count] - 1; i >= 0; i--) {
    //            XMPPMessageArchiving_Message_CoreDataObject *message =
    //            (XMPPMessageArchiving_Message_CoreDataObject*)[array objectAtIndex:i];
    //
    //            if ([message.bRead boolValue] == NO) {
    //                message.bRead = [NSNumber numberWithBool:YES];
    //            }
    //        }
    //    } else {
    //        //标记未读
    //        [request setFetchLimit:1];
    //        NSArray *array = [context executeFetchRequest:request error:nil];
    //
    //
    //        if ([array count] > 0) {
    //            XMPPMessageArchiving_Message_CoreDataObject *message =
    //            (XMPPMessageArchiving_Message_CoreDataObject*)[array objectAtIndex:0];
    //
    //            message.bRead = [NSNumber numberWithBool:NO];
    //        }
    //    }
    //
    //    [context save:nil];
    //
    //    [self updateData:[RRTManager manager].imManager];
}

#pragma mark - ubility
#pragma mark -


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"1"]) {
        [self bigData:S_Chat];
    } else if ([[NSString stringWithFormat:@"%@",[RRTManager manager].loginManager.loginInfo.userRole] isEqualToString:@"2"]){
        [self bigData:P_Chat];
    } else{
        [self bigData:T_Chat];
    }
}

@end

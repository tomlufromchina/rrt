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

@interface MessageTableViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong)NSMutableArray *mostRecentMessages;
@property (nonatomic, strong)NSMutableArray *unreadCounts;

@end

@implementation MessageTableViewController

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
    
    self.title = @"沟通";
    
    self.mostRecentMessages = [NSMutableArray array];
    self.unreadCounts = [NSMutableArray array];
    
    [self setExtraCellLineHidden:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    
    
    
    IMManager *imManager = [RRTManager manager].imManager;
    imManager.chatDelegate = self;
    
    [self updateData:imManager];
}

- (void)updateData:(IMManager*)imManager
{
    NSManagedObjectContext *context = [imManager.xmppMessageArchivingStorage
                                       mainThreadManagedObjectContext];
    
    NSEntityDescription *entity = [imManager.xmppMessageArchivingStorage contactEntity:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"streamBareJidStr == %@",
                              [[RRTManager manager].imManager jidStrFromUserId:[RRTManager manager].imManager.userId]];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp"
                                                               ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    //对数据排序，置顶的放最上面（置顶的时间）
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < [array count]; i++) {
        XMPPMessageArchiving_Contact_CoreDataObject *mostMessage =
        (XMPPMessageArchiving_Contact_CoreDataObject*)[array objectAtIndex:i];
        
        if ([mostMessage.bToped boolValue]) {
            [tmpArray removeObject:mostMessage];
            [tmpArray insertObject:mostMessage atIndex:0];
        }
    }
    
    [self.mostRecentMessages removeAllObjects];
    [self.mostRecentMessages addObjectsFromArray:tmpArray];

    [self.unreadCounts removeAllObjects];
    
    
    
    entity = [imManager.xmppMessageArchivingStorage messageEntity:context];
    [request setEntity:entity];
    [request setSortDescriptors:nil];

    for (int i = 0; i < [self.mostRecentMessages count]; i++) {
        XMPPMessageArchiving_Contact_CoreDataObject *mostMessage =
        (XMPPMessageArchiving_Contact_CoreDataObject*)[self.mostRecentMessages objectAtIndex:i];

        predicate = [NSPredicate predicateWithFormat:@"bRead == %@ && \
                                                         streamBareJidStr CONTAINS[cd] %@ && \
                                                         bareJidStr CONTAINS[cd] %@",
                     [NSNumber numberWithBool:NO],
                     mostMessage.streamBareJidStr,
                     mostMessage.bareJidStr];
        
        [request setPredicate:predicate];
         NSArray *array = [context executeFetchRequest:request error:nil];
        int unread = [array count];
        [self.unreadCounts addObject:[NSNumber numberWithInt:unread]];
        
        array = nil;
        predicate = nil;
    }
    
    
    [self.tableView reloadData];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAContextMenuCell *cell = (DAContextMenuCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    UIImageView *avatar = (UIImageView*)[cell viewWithTag:1];
    UILabel *name = (UILabel*)[cell viewWithTag:2];
    UILabel *body = (UILabel*)[cell viewWithTag:3];
    UILabel *time = (UILabel*)[cell viewWithTag:4];
    UIView *tip = (UIView*)[cell viewWithTag:5];
    UILabel *tipCount = (UILabel*)[cell viewWithTag:6];
    
    
    XMPPMessageArchiving_Contact_CoreDataObject *message =
    (XMPPMessageArchiving_Contact_CoreDataObject*)[self.mostRecentMessages objectAtIndex:indexPath.row];
    
    NSString *userId = [[RRTManager manager].imManager userIdFromJidStr:message.bareJidStr];
    Contact *contact = [DataManager contactForId:userId];
    if (contact) {
        name.text = contact.name;
        [avatar setImageWithURL:[NSURL URLWithString:contact.avatarUrl]
               placeholderImage:[UIImage imageNamed:@"default.png"]];
    } else {
        name.text = userId;
    }

    //FIXME:这里先用偷懒的办法判断最新的消息是否是图片或者语音
    NSString *bodyStr = message.mostRecentMessageBody;
    NSRange range = [bodyStr rangeOfString:@"http://nmapi.aedu.cn/"];
    if (range.location == NSNotFound) {
        body.text = bodyStr;
    } else {
        range = [bodyStr rangeOfString:@".png"];
        if (range.length > 0) {
            body.text = @"[图片]";
        } else {
            range = [bodyStr rangeOfString:@".aac"];
            if (range.length > 0) {
                body.text = @"[语音]";
            } else {
                body.text = bodyStr;
            }
        }
    }
    
    int unread = [(NSNumber*)[self.unreadCounts objectAtIndex:indexPath.row] intValue];
    if (unread > 0) {
        [tip setHidden:NO];
        tipCount.text = [NSString stringWithFormat:@"%d", unread];
    } else {
        [tip setHidden:YES];
    }
    
    //set time
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = message.mostRecentMessageTimestamp;
    fmt.dateFormat = @"MM-dd HH:mm";
    NSString *timeString = [fmt stringFromDate:date];
    time.text = timeString;

    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:ChatVCID
                                   withStoryBoard:MessageStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        ChatViewController *vc = (ChatViewController*)viewController;
        XMPPMessageArchiving_Contact_CoreDataObject *message =
        (XMPPMessageArchiving_Contact_CoreDataObject*)[self.mostRecentMessages objectAtIndex:indexPath.row];
        
        vc.toStr = [[RRTManager manager].imManager userIdFromJidStr:message.bareJidStr];
    }];

//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:LoginBoardName
//                                                             bundle:nil];
//    LoginViewController *loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:
//                                    LoginVCID];
//    loginVC.bFromLaunch = NO;
//    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:navController animated:YES completion:nil];
}


- (void)messageComming
{
    [self updateData:[RRTManager manager].imManager];
}

#pragma mark - DAContextMenuCell delegate
#pragma mark -
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    [super contextMenuCellDidSelectDeleteOption:cell];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSManagedObjectContext *context = [[RRTManager manager].imManager.xmppMessageArchivingStorage
                                       mainThreadManagedObjectContext];
    
    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
                                                                objectAtIndex:indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                @"messageStr CONTAINS[cd] %@ && messageStr CONTAINS[cd] %@",
                 mostMessage.streamBareJidStr,
                 mostMessage.bareJidStr];
    
    NSEntityDescription *entity = [[RRTManager manager].imManager.xmppMessageArchivingStorage messageEntity:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    [request setPredicate:predicate];
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (NSManagedObject *obj in array) {
        [context deleteObject:obj];
    }
    
    [context deleteObject:mostMessage];
    [context save:nil];
    
    
    [self.mostRecentMessages removeObjectAtIndex:indexPath.row];
    [self.unreadCounts removeObjectAtIndex:indexPath.row];

    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
                                                                objectAtIndex:indexPath.row];
    
    NSString *topString = [mostMessage.bToped boolValue] ? @"取消置顶" : @"置顶聊天";
    
    int unread = [(NSNumber*)[self.unreadCounts objectAtIndex:indexPath.row] intValue];
    
    NSString *unReadString = unread > 0 ? @"标记已读" : @"标记未读";
    
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:unReadString, topString, nil];
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //标记未读 或者 已读
        [self markUnread:actionSheet.tag];
    } else if (buttonIndex == 1) {
        //置顶聊天 或者 取消置顶
        [self topChat:actionSheet.tag];
    }
}

- (void)topChat:(int)index
{
    NSManagedObjectContext *context = [[RRTManager manager].imManager.xmppMessageArchivingStorage
                                       mainThreadManagedObjectContext];
    
    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
                                                                objectAtIndex:index];
    
    mostMessage.bToped = [NSNumber numberWithBool:![mostMessage.bToped boolValue]];
    mostMessage.topedTimestamp = [NSDate date];
    
    [context save:nil];
    
    [self updateData:[RRTManager manager].imManager];
}

- (void)markUnread:(int)index
{
    NSManagedObjectContext *context = [[RRTManager manager].imManager.xmppMessageArchivingStorage
                                       mainThreadManagedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [[RRTManager manager].imManager.xmppMessageArchivingStorage
                                   messageEntity:context];
    [request setEntity:entity];
    
    XMPPMessageArchiving_Contact_CoreDataObject *mostMessage = [self.mostRecentMessages
                                                                objectAtIndex:index];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                          @"messageStr CONTAINS[cd] %@ && messageStr CONTAINS[cd] %@",
                 mostMessage.streamBareJidStr,
                 mostMessage.bareJidStr];
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
    
    [request setPredicate:predicate];
    
    int unread = [(NSNumber*)[self.unreadCounts objectAtIndex:index] intValue];
    if (unread > 0) {
        //标记已读
        NSArray *array = [context executeFetchRequest:request error:nil];

        for (int i = [array count] - 1; i >= 0; i--) {
            XMPPMessageArchiving_Message_CoreDataObject *message =
            (XMPPMessageArchiving_Message_CoreDataObject*)[array objectAtIndex:i];
            
            if ([message.bRead boolValue] == NO) {
                message.bRead = [NSNumber numberWithBool:YES];
            }
        }
    } else {
        //标记未读
        [request setFetchLimit:1];
        NSArray *array = [context executeFetchRequest:request error:nil];
        
        
        if ([array count] > 0) {
            XMPPMessageArchiving_Message_CoreDataObject *message =
            (XMPPMessageArchiving_Message_CoreDataObject*)[array objectAtIndex:0];
            
            message.bRead = [NSNumber numberWithBool:NO];
        }
    }

    [context save:nil];

    [self updateData:[RRTManager manager].imManager];
}

#pragma mark - ubility
#pragma mark -
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end

//
//  MainViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MainViewController.h"
#import "BarBaseViewController.h"
#import "LeftViewController.h"

@interface MainViewController ()
{
    BarBaseViewController *content;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    LeftViewController *left = [[LeftViewController alloc] init];
    self.leftMenuViewController = left;
    
    content = [[BarBaseViewController alloc] init];
    self.contentViewController = content;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    
}

-(void)message:(NSNotification*)notefication{
    NSString* uid=[RRTManager manager].loginManager.loginInfo.userId;
    NSMutableArray* unreadarray=[[IMCache shareIMCache] queryPacketFriendSessionList:uid];
    int count=0;
    for (Packet *packet in unreadarray) {
        if (packet.message.type==MessageTypeChat) {
            if ([packet.from isEqualToString:uid]) {
                count +=[[IMCache shareIMCache] getSessionBrageFriendID:packet.to userid:packet.from];
            }else{
                count +=[[IMCache shareIMCache] getSessionBrageFriendID:packet.from userid:packet.to];
            }
        } else if(packet.message.type==MessageTypeGroupChat){
            count +=[[IMCache shareIMCache] getSessionBrageGroupid:packet.message.body.groupid userid:packet.to];
        }
    }
    [content addBudge:count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}


@end

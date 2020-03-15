//
//  Brage.m
//  RenrenTong
//
//  Created by 符其彬 on 14/12/24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "Brage.h"

@implementation Brage

-(void)awakeFromNib{
    self.image=[UIImage imageNamed:@"numtips"];
    self.frame=CGRectMake(0, 0, 40, 40);
    _val=0;
    _vallable=[[UILabel alloc] initWithFrame:CGRectMake(8, 12, 24, 16)];
    _vallable.text=[NSString stringWithFormat:@"%d",_val];
    _vallable.textAlignment=NSTextAlignmentCenter;
    _vallable.font=[UIFont systemFontOfSize:10];
    _vallable.textColor=[UIColor whiteColor];
    [self addSubview:_vallable];
    if (_val<=0) {
        self.hidden=YES;
    }
}

- (instancetype)init
{
    self=[super initWithImage:[UIImage imageNamed:@"numtips"]];
    if (self) {
        self.frame=CGRectMake(0, 0, 40, 40);
        _val=0;
        _vallable=[[UILabel alloc] initWithFrame:CGRectMake(5, 12, 24, 16)];
        _vallable.text=[NSString stringWithFormat:@"%d",_val];
        _vallable.textAlignment=NSTextAlignmentCenter;
        _vallable.font=[UIFont systemFontOfSize:10];
        _vallable.textColor=[UIColor whiteColor];
        [self addSubview:_vallable];
        if (_val<=0) {
            self.hidden=YES;
        }
    }
    return self;
}



-(void)setBrageNotifiCationChangeValue:(NSNotification*) noti{
//    if (![[noti object] isKindOfClass:[NSNumber class]]||![[noti object] isKindOfClass:[NSString class]]) {
//        return;
//    }
//    NSLog(@"%@",[noti object]);
//    NSString* uid=[RRTManager manager].loginManager.loginInfo.userId;
//    if ([_notificationID isEqualToString:@"zuoye"]) {
//       int val = [[IMCache shareIMCache] getPushBrage:uid type:PushTypeJob];
//        [self setBrageText:val];
//    }else if([_notificationID isEqualToString:@"tongzhi"]){
//        int val = [[IMCache shareIMCache] getPushBrage:uid type:PushTypeNotification];
//        [self setBrageText:val];
//    }else if([_notificationID isEqualToString:@"chengji"]){
//        int val = [[IMCache shareIMCache] getPushBrage:uid type:PushTypeScore];
//        [self setBrageText:val];
//    }else if([_notificationID isEqualToString:@"weiping"]){
//        
//    }else if([_notificationID isEqualToString:@"lianxiren"]){
//        int val = [[IMCache shareIMCache] getAllFriendBrage:uid];
//        [self setBrageText:val];
//    }else if ([_notificationID hasPrefix:@"Brage"]){
//            if ([[noti object] isKindOfClass:[NSNumber class]]) {
//                long fid=[[noti object] longValue];
//                if (fid>0) {
//                    int unread=0;
//                    unread =[[IMCache shareIMCache] getSessionBrageFriendID:[NSString stringWithFormat:@"%li",fid] userid:uid];
//                    [self setBrageText:unread];
//                }
//            }
//    }
}

-(void)setVal:(int)val{
    _val=val;
    if (_val>0) {
        self.hidden=NO;
    }else{
        self.hidden=YES;
    }
    if (_val>99) {
        _vallable.text=@"99+";
    }else{
        _vallable.text=[NSString stringWithFormat:@"%d",_val];
    }
}


@end

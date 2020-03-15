//
//  MessageModel.m
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "MessageModel.h"
@implementation MessageModel

@end

@implementation GroupModel

@end

@implementation GroupModelMsg
-(void)setGroupphoto
{
    if ([self.GroupName containsString:@"教师"]) {
     self.GroupPhoto = @"teacher_group";
    }else if ([self.GroupName  containsString:@"学生"]) {
        self.GroupPhoto = @"student_group";
    }else if([self.GroupName  containsString:@"家长"]) {
        self.GroupPhoto = @"parents_group";
    }
}

@end
@implementation GetFollows

@end
@implementation GetFollowsMsg

@end
@implementation GetFollowsMsglist

@end

@implementation GetInvitation

@end
@implementation GetInvitationMsg

@end
@implementation GetInvitationMsglist

@end
@implementation GetUserInfoBySJ_Search

@end
@implementation GetUserInfoBySJ_SearchMsg

@end
//######################
@implementation GetUserById

@end
@implementation GetUserByIdMsg

@end
@implementation GetUserByIdMsgList

@end
@implementation GetUserSpacePower

@end
@implementation GetUserSpacePowerMsg

@end
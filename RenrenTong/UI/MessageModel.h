//
//  MessageModel.h
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

/**
 *  即时聊天功能相关model放于此文件
 */

#import "JSONModel.h"
@protocol GroupModelMsg @end
@protocol GetFollowsMsglist @end
@protocol GetInvitationMsglist @end
@protocol GetUserInfoBySJ_SearchMsg  @end
@protocol GetUserSpacePowerMsg @end

@interface MessageModel : JSONModel

@end

/**
 *  获取群组列表model
 */
@interface GroupModelMsg: JSONModel
@property (nonatomic,strong) NSString <Optional>*GroupId;
@property (nonatomic,strong) NSString <Optional>*GroupName;
@property (nonatomic,strong) NSString <Optional>*GroupType;
@property (nonatomic,strong) NSString <Optional>*IsSystemGroup;
@property (nonatomic,strong) NSString <Optional>*GroupPhoto;
-(void)setGroupphoto;
@end

@interface GroupModel : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic,strong) NSArray <GroupModelMsg,Optional>*msg;
@end
//获取最新消息列表model  end >


/**
 *  获取好友列表model
 */
@interface GetFollowsMsglist: JSONModel
@property (nonatomic,strong) NSString <Optional>*FollowsCount;
@property (nonatomic,strong) NSString <Optional>*Introduction;
@property (nonatomic,strong) NSString <Optional>*IsFollowed;
@property (nonatomic,strong) NSString <Optional>*IsOnline;
@property (nonatomic,strong) NSString <Optional>*Phone;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*PinYin;
@property (nonatomic,strong) NSString <Optional>*Roles;
@property (nonatomic,strong) NSString <Optional>*Schools;
@property (nonatomic,strong) NSString <Optional>*Sex;
@property (nonatomic,strong) NSString <Optional>*TrueName;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserRole;
@end

@interface GetFollowsMsg : JSONModel
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray <GetFollowsMsglist,Optional>*list;
@end

@interface GetFollows : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic,strong) GetFollowsMsg <Optional>*msg;
@end
//获取好友列表model  end >

/**
 *  添加好友model
 */
@interface GetInvitationMsglist: JSONModel
@property (nonatomic,strong) NSString <Optional>*Body;
@property (nonatomic,strong) NSString <Optional>*DateTime;
@property (nonatomic,strong) NSString <Optional>*InvitationId;
@property (nonatomic,strong) NSString <Optional>*IsFollows;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*Remark;
@property (nonatomic,strong) NSString <Optional>*SenderPictureUrl;
@property (nonatomic,strong) NSString <Optional>*SenderUserId;
@property (nonatomic,strong) NSString <Optional>*SenderUserName;
@property (nonatomic,strong) NSString <Optional>*TypeId;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@end

@interface GetInvitationMsg : JSONModel
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray <GetInvitationMsglist,Optional>*list;
@end

@interface GetInvitation : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic,strong) GetInvitationMsg <Optional>*msg;
@end
//添加好友model end>

/**
 *  搜索添加好友model
 */
@interface GetUserInfoBySJ_SearchMsg: JSONModel
@property (nonatomic,strong) NSString <Optional>*HomeAreaCode;
@property (nonatomic,strong) NSString <Optional>*HomeAreaName;
@property (nonatomic,strong) NSString <Optional>*LatestNews;
@property (nonatomic,strong) NSString <Optional>*NickName;
@property (nonatomic,strong) NSString <Optional>*NowAreaCode;
@property (nonatomic,strong) NSString <Optional>*NowAreaName;
@property (nonatomic,strong) NSString <Optional>*ParentAccount;
@property (nonatomic,strong) NSString <Optional>*ParentId;
@property (nonatomic,strong) NSString <Optional>*ParentName;
@property (nonatomic,strong) NSString <Optional>*PicInfo;
@property (nonatomic,strong) NSString <Optional>*SchoolId;
@property (nonatomic,strong) NSString <Optional>*SchoolName;
@property (nonatomic,strong) NSString <Optional>*TrueName;
@property (nonatomic,strong) NSString <Optional>*UserAccount;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserType;
@property (nonatomic,strong) NSString <Optional>*isFriend;

@end


@interface GetUserInfoBySJ_Search : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSArray <GetUserInfoBySJ_SearchMsg,Optional>*msg;
@end

/**
 *  通过ID获取好友信息model
 */
@interface GetUserByIdMsgList: JSONModel
@property (nonatomic,strong) NSString <Optional>*AccountEmail;
@property (nonatomic,strong) NSString <Optional>*AccountMobile;
@property (nonatomic,strong) NSString <Optional>*Aliwangwang;
@property (nonatomic,strong) NSString <Optional>*Birthday;
@property (nonatomic,strong) NSString <Optional>*BlogThreadsCount;
@property (nonatomic,strong) NSString <Optional>*CardID;
@property (nonatomic,strong) NSString <Optional>*CardType;
@property (nonatomic,strong) NSString <Optional>*ClassName;
@property (nonatomic,strong) NSString <Optional>*ExperiencePoints;
@property (nonatomic,strong) NSString <Optional>*FavoritesCount;
@property (nonatomic,strong) NSString <Optional>*Fetion;
@property (nonatomic,strong) NSString <Optional>*FollowedCount;
@property (nonatomic,strong) NSString <Optional>*Introduction;
@property (nonatomic,strong) NSString <Optional>*IsFollowed;
@property (nonatomic,strong) NSString <Optional>*IsOnline;
@property (nonatomic,strong) NSString <Optional>*IsRequstFollowed;
@property (nonatomic,strong) NSString <Optional>*LunarBirthday;
@property (nonatomic,strong) NSString <Optional>*MicroblogsCount;
@property (nonatomic,strong) NSString <Optional>*Msn;
@property (nonatomic,strong) NSString <Optional>*NickName;
@property (nonatomic,strong) NSString <Optional>*NoteName;
@property (nonatomic,strong) NSString <Optional>*PhotosCount;
@property (nonatomic,strong) NSString <Optional>*NowAreaCode;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*QQ;
@property (nonatomic,strong) NSString <Optional>*Rank;
@property (nonatomic,strong) NSString <Optional>*ReputationPoints;
@property (nonatomic,strong) NSString <Optional>*Roles;
@property (nonatomic,strong) NSString <Optional>*School;
@property (nonatomic,strong) NSString <Optional>*SchoolName;
@property (nonatomic,strong) NSString <Optional>*Sex;
@property (nonatomic,strong) NSString <Optional>*Skype;
@property (nonatomic,strong) NSString <Optional>*TradePoints;
@property (nonatomic,strong) NSString <Optional>*TrueName;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@end

@interface GetUserByIdMsg: JSONModel

@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) GetUserByIdMsgList <Optional>*list;

@end

@interface GetUserById : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic,strong) GetUserByIdMsg <Optional>*msg;
@end
//根据ID获取好友信息 end>

/**
 *  设置好友资料权限设置
 */
@interface GetUserSpacePowerMsg: JSONModel

@property (nonatomic,assign) BOOL IsDisVisit;
@property (nonatomic,assign) BOOL IsPbDyn;

@end

@interface GetUserSpacePower : JSONModel

@property (nonatomic,assign) NSInteger st;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong)  NSArray <Optional,GetUserSpacePowerMsg>*msg;

@end
//设置好友资料权限设置 end>
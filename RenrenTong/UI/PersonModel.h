//
//  PersonModel.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

/**
 *  关于个人信息，修改个人信息的数据model在此文件中，需要添加相关model也放在此文件中
 *
 */


#import "JSONModel.h"
@protocol AeduNewModelItems @end

/**
 *  通过Token获取用户信息
 */
// 两级
@interface  PersonModelMsg : JSONModel
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*UserRole;
@property (nonatomic,strong) NSString <Optional>*RoleName;
@property (nonatomic,strong) NSString <Optional>*ExperiencePoints;
@property (nonatomic,strong) NSString <Optional>*SchoolName;
@property (nonatomic,strong) NSString <Optional>*SchoolId;
@property (nonatomic,strong) NSString <Optional>*ClassId;
@property (nonatomic,strong) NSString <Optional>*ClassName;
@property (nonatomic,strong) NSString <Optional>*IsUploadPhoto;
@property (nonatomic,strong) NSString <Optional>*MyMessageCount;
@property (nonatomic,strong) NSString <Optional>*MsmMessageCount;
@property (nonatomic,strong) NSString <Optional>*Point;

@end
// 一级
@interface PersonModel : JSONModel

@property (nonatomic,assign) NSInteger st;
@property (nonatomic, strong) PersonModelMsg *msg;

@end

/**
 *  教育资讯
 */

// 二级
@interface AeduNewModelItems : JSONModel

@property (nonatomic,strong) NSString <Optional>*NewsId;
@property (nonatomic,strong) NSString <Optional>*Title;
@property (nonatomic,strong) NSString <Optional>*Author;
@property (nonatomic,strong) NSString <Optional>*Brief;
@property (nonatomic,strong) NSString <Optional>*Detail;
@property (nonatomic,strong) NSString <Optional>*KeyWords;
@property (nonatomic,strong) NSString <Optional>*Describe;
@property (nonatomic,strong) NSString <Optional>*PublishDate;

@end

// 一级
@interface AeduNewModel : JSONModel
@property (nonatomic,assign) NSInteger result;
@property (nonatomic, strong) NSArray <Optional,AeduNewModelItems>*items;


@end

/**
 *  资料详情
 */

// 三级
@interface PersonailInformationList : JSONModel

@property (nonatomic,strong) NSString <Optional>*AccountEmail;
@property (nonatomic,strong) NSString <Optional>*BlogThreadsCount;
@property (nonatomic,strong) NSString <Optional>*ExperiencePoints;
@property (nonatomic,strong) NSString <Optional>*FavoritesCount;
@property (nonatomic,strong) NSString <Optional>*FollowedCount;
@property (nonatomic,strong) NSString <Optional>*MicroblogsCount;
@property (nonatomic,strong) NSString <Optional>*IsOnline;
@property (nonatomic,strong) NSString <Optional>*NickName;
@property (nonatomic,strong) NSString <Optional>*PhotosCount;
@property (nonatomic,strong) NSString <Optional>*PictureUrl;
@property (nonatomic,strong) NSString <Optional>*Rank;
@property (nonatomic,strong) NSString <Optional>*ReputationPoints;
@property (nonatomic,strong) NSString <Optional>*Roles;
@property (nonatomic,strong) NSString <Optional>*TradePoints;
@property (nonatomic,strong) NSString <Optional>*TrueName;
@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*SchoolName;
@property (nonatomic,strong) NSString <Optional>*ClassName;
@property (nonatomic,strong) NSString <Optional>*AccountMobile;
@property (nonatomic,strong) NSString <Optional>*Aliwangwang;
@property (nonatomic,strong) NSString <Optional>*Msn;
@property (nonatomic,strong) NSString <Optional>*Skype;
@property (nonatomic,strong) NSString <Optional>*Fetion;
@property (nonatomic,strong) NSString <Optional>*QQ;
@property (nonatomic,strong) NSString <Optional>*CardType;
@property (nonatomic,strong) NSString <Optional>*CardID;
@property (nonatomic,strong) NSString <Optional>*LunarBirthday;
@property (nonatomic,strong) NSString <Optional>*Birthday;
@property (nonatomic,strong) NSString <Optional>*Introduction;
@property (nonatomic,strong) NSString <Optional>*NowAreaCode;
@property (nonatomic,strong) NSString <Optional>*School;
@property (nonatomic,strong) NSString <Optional>*Sex;
@property (nonatomic,strong) NSString <Optional>*IsFollowed;
@property (nonatomic,strong) NSString <Optional>*IsRequstFollowed;
@property (nonatomic,strong) NSString <Optional>*NoteName;

@end

// 二级
@interface PersonailInformationMsg : JSONModel
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic, strong) PersonailInformationList *list;

@end

// 一级
@interface PersonailInformation : JSONModel
@property (nonatomic,assign) NSInteger st;
@property (nonatomic, strong) PersonailInformationMsg *msg;

@end



//#############################################

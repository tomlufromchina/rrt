//
//  Archive.h
//  RenrenTong
//
//  Created by aedu on 15/4/10.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

//关于班级文章功能的数据model在此文件中

#import "JSONModel.h"
@protocol ArchiveListMsgItem @end
@protocol  GetArchivePraise @end
@protocol ArchiveCategoryListItem @end

/**
 *  获取文章列表model
 */
@interface ArchiveListMsgItem : JSONModel

@property (nonatomic,strong) NSString <Optional>*ArchiveId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserPhoto;
@property (nonatomic,strong) NSString <Optional>*ArchiveTitle;
@property (nonatomic,strong) NSString <Optional>*ArchiveText;
@property (nonatomic,assign) NSInteger HitCount;
@property (nonatomic,strong) NSString <Optional>*PubTime;
@property (nonatomic,assign) BOOL IsDelete;
@property (nonatomic,assign) BOOL IsPraise;

@end

@interface ArchiveListMsg : JSONModel

@property (nonatomic,strong) NSNumber <Optional>*count;
@property (nonatomic,strong) NSNumber <Optional>*TotleCount;
@property (nonatomic,strong) NSArray < ArchiveListMsgItem,Optional>*items;

@end

@interface ArchiveList : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) ArchiveListMsg <Optional>*msg;

@end
//获取文章列表model end>


/**
 *  文章分类列表model
 */
@interface ArchiveCategoryListItem : JSONModel

@property (nonatomic,strong) NSString <Optional>*CategoryId;
@property (nonatomic,strong) NSString <Optional>*CategoryName;

@end

@interface ArchiveCategoryList : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) NSArray < ArchiveCategoryListItem,Optional>*items;

@end
//文章分类列表model end>

/**
 *  获取文章详情model
 */
@interface ArchiveDetail : JSONModel

@property (nonatomic,strong) NSString <Optional>*ArchiveId;
@property (nonatomic,strong) NSString <Optional>*ArchiveTitle;
@property (nonatomic,strong) NSString <Optional>*ArchiveText;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*LinkUrl;
@property (nonatomic,assign) NSInteger HitCount;
@property (nonatomic,strong) NSString <Optional>*PraiseCount;
@property (nonatomic,strong) NSNumber <Optional>*IsDelete;
@property (nonatomic,strong) NSString <Optional>*PubTime;
@property (nonatomic,strong) NSString <Optional>*UserFace;
@property (nonatomic,strong) NSArray <Optional,GetArchivePraise>*Praise;

@end

@interface GetArchivePraise : JSONModel

@property (nonatomic,strong) NSString <Optional>*UserId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserFace;

@end


@interface GetArchiveDetail : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) ArchiveDetail <Optional>*detail;
@property (nonatomic,strong) NSNumber <Optional>*IsPraise;

@end
//获取文章详情model end>
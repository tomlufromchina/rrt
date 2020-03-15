//
//  MyCurrentClassModel.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/21.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "JSONModel.h"
@protocol MyCurrentClassListModelitems @end

@protocol MyCurrentClassModelBulletinitems @end

@interface MyCurrentClassModel : JSONModel

@end


/**
 *  我的班级列表
 */
// 二级
@interface  MyCurrentClassListModelitems: JSONModel

@property (nonatomic,strong) NSString <Optional>*ClassId;
@property (nonatomic,strong) NSString <Optional>*ClassName;
@property (nonatomic,strong) NSString <Optional>*ClassFace;
@property (nonatomic,strong) NSString <Optional>*SchoolId;
@property (nonatomic,strong) NSString <Optional>*Slogan;


@end
// 一级
@interface MyCurrentClassListModel : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic, strong) NSArray <Optional,MyCurrentClassListModelitems>*items;

@end

/**
 *  班级公告
 */

@interface  MyCurrentClassModelBulletinitems: JSONModel

@property (nonatomic,strong) NSString <Optional>*ArchiveId;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserPhoto;
@property (nonatomic,strong) NSString <Optional>*ArchiveTitle;
@property (nonatomic,strong) NSString <Optional>*ArchiveText;
@property (nonatomic,strong) NSString <Optional>*HitCount;
@property (nonatomic,strong) NSString <Optional>*PubTime;

@end
// 一级
@interface MyCurrentClassModelBulletin : JSONModel

@property (nonatomic,assign) NSInteger result;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger TotalCount;
@property (nonatomic, strong) NSArray <Optional,MyCurrentClassModelBulletinitems>*items;

@end

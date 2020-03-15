//
//  TheHotTopicModel.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/21.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "JSONModel.h"
@protocol TheHotTopicModelMsg @end
@protocol TheHotTopicModelList @end

/**
 *  获取最新热门话题
 */

@interface TheHotTopicModelList : JSONModel
@property (nonatomic,strong) NSString <Optional>*ItemName;
@property (nonatomic,strong) NSString <Optional>*TagName;
@property (nonatomic,strong) NSString <Optional>*DisplayName;
@property (nonatomic,strong) NSString <Optional>*Description;
@property (nonatomic,strong) NSString <Optional>*FeaturedImage;
@property (nonatomic,strong) NSString <Optional>*ImagePath;
@property (nonatomic,strong) NSNumber <Optional>*IsFeatured;
@property (nonatomic,strong) NSString <Optional>*DateCreated;
@property (nonatomic,strong) NSString <Optional>*TagId;
@property (nonatomic,strong) NSString <Optional>*ItemCount;

@end

// 二级
@interface TheHotTopicModelMsg : JSONModel

@property (nonatomic,strong) NSString <Optional>*count;
@property (nonatomic,strong) NSString <Optional>*totalCount;
@property (nonatomic, strong) NSArray <Optional,TheHotTopicModelList>*list;

@end
// 一级
@interface TheHotTopicModel : JSONModel

@property (nonatomic,assign) NSInteger st;
@property (nonatomic, strong) TheHotTopicModelMsg <Optional>*msg;

@end


//
//  HotTopic.h
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotTopic : NSObject
@property(nonatomic, strong)NSString *ItemName;
@property(nonatomic, strong)NSNumber *TagId;
@property(nonatomic, strong)NSString *TagName;
@property(nonatomic, strong)NSString *FeaturedImage;
@property(nonatomic, assign)BOOL IsFeatured;
@property(nonatomic, strong)NSString *DateCreated;
@property(nonatomic, strong)NSString *DisplayName;
@property(nonatomic, strong)NSString *ImagePath;
@property(nonatomic, assign)int ItemCount;
@property(nonatomic, strong)NSString *Description;


@end

//
//  PhotoUITapGestureRecognizer.h
//  RenrenTong
//
//  Created by 唐彬 on 14-8-19.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectsEntity.h"

@interface PhotoUITapGestureRecognizer : UITapGestureRecognizer
@property(nonatomic,readwrite,strong)FriendDynamicDetail* fr;
@property (nonatomic,readwrite,strong)MyDynamic *My;
@property(nonatomic,readwrite,strong)UIImageView* img;
@property(nonatomic,readwrite,strong)WeiboList* wl;

@property (nonatomic,readwrite,strong) MicroblogDetail *md;
@property (nonatomic,readwrite,strong) RecentlyPhotos *RP;
@property (nonatomic,readwrite,strong) NewActivity *NA;
@property (nonatomic,readwrite,strong) SeacherObject *so;

@property (nonatomic, readwrite, strong) VisitorModel*Vm;
@end

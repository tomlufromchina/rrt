//
//  BaseRequest.h
//  WeiDianPing
//
//  Created by 唐彬 on 14-11-9.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject
@property(nonatomic,readwrite,strong)NSString* url;
@property(nonatomic,readwrite,strong)NSMutableArray* postdata;
@property(nonatomic,readwrite,assign)SEL sel;
@end

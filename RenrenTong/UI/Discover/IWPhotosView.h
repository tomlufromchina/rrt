//
//  IWPhotosView.h
//  9期微博
//
//  Created by teacher on 14-10-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWPhotosView : UIView

/**
 *  所有的子配图路径
 */
@property (nonatomic, strong) NSArray *picUrls;

/**
 *  计算配图容器自己的size
 *
 *  @param count 配图的个数
 *
 *  @return 容器的宽高
 */
+ (CGSize)sizeWithCount:(int)count;

@end

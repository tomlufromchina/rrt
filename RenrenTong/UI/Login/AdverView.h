//
//  AdverView.h
//  RenrenTong
//
//  Created by aedu on 15/3/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum AdverType
{
    StartPageAdver = 1,// 启动页广告
    HomePageAdver,// 首页弹框广告
    HomePageTopAdver,// 首页顶部广告
    UnLoginTopAdver,// 未登陆顶部广告 ( 访客模式 与 登陆界面 使用 )
    discoverPageAdver// 发现页广告
}AdverType;


@class AdverView;
@protocol AdverViewDelegate <NSObject>

- (void)clickTheImages:(int)tag andWithAdNameArray:(NSMutableArray *)adNameArray andWithLinkUrlArray:(NSMutableArray *)linkUrlArry;
-(void)removeAdverView;

@end

@interface AdverView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic)  UIScrollView *scrollView;
@property (weak, nonatomic)  UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *picArray;// 广告图片链接
@property (nonatomic, strong) NSMutableArray *adNameArray;// 广告名
@property (nonatomic, strong) NSMutableArray *linkUrlArray;// 跳转web链接
@property (nonatomic, weak) id<AdverViewDelegate> delegate;

@property (nonatomic, strong) NSString *adverType;

-(id)initWithFrame:(CGRect)frame AdverType:(AdverType)adverType;

@end

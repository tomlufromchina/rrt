//
//  PicturesScrollerView.h
//  HLJApp
//
//  Created by 何丽娟 on 15/4/7.
//  Copyright (c) 2015年 何丽娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureScrollerViewDelegate <NSObject>

@optional
-(void)back;
-(void)rightButtonEvent:(NSInteger)i;
@end

@interface PicturesScrollerView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,weak) id <PictureScrollerViewDelegate> pictureScrollerViewDelegate;

@property (nonatomic,strong) UILabel *newtitleLabel;
@property (nonatomic,strong) UIButton *navLeftButton;
@property (nonatomic, strong) UIButton *navigationRightButton;
@property (nonatomic, strong) UIView *navigationBackground;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL isShowNavigationBar;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,assign) NSInteger startIndex;
//如果有导航栏，右键操作需要的数据数组
@property (nonatomic,strong) NSArray *navigationRightDataAry;

/**
 *  手势冲突
 *
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

-(void)setUpNavigation:(NSString *)titleString navigationColor:(UIColor*)color;
@end

//
//  BaseViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "ReceiveMessage.h"
@interface BaseViewController : UIViewController

#pragma mark - show HUD
#pragma mark -
- (void)show;
- (void)showImage:(UIImage *)image status:(NSString *)string;
- (void)showWithStatus:(NSString*)status;
- (void)showProgress:(CGFloat)progress;
- (void)showProgress:(CGFloat)progress status:(NSString*)status;
- (void)showSuccessWithStatus:(NSString*)string;
- (void)showErrorWithStatus:(NSString *)string;
- (void)showWithTitle:(NSString *)title withTime:(NSTimeInterval)time;
- (void)showWithTitle:(NSString *)title defaultStr:(NSString *)defaultStr;
- (void)dismiss;
- (void)deleteFile:(NSMutableArray *)array;

//navigationBar
@property (nonatomic,strong) UIView   *navigationCenterView;    //导航栏中间的容器view
@property (nonatomic,strong) UILabel  *titleLabel;              //中间的容器控件默认子view为此标题控件
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) UIButton *navigationLeftButton;    //导航栏左侧按钮
@property (nonatomic,strong) UIButton *navigationRightButton;   //导航栏右侧按钮

/**
 * 数据提示界面（我的班级里面使用到）
 *
 *  @param message 提示信息
 */
-(void)showUploadView:(NSString*)message;
/**
 *  移除提示信息
 */
-(void)dismissUploadingView;
/**
 *  没有数据时提示界面
 *
 *  @param notifyText 提示信息
 */
-(void)showNoDataView:(NSString*)notifyText;
/**
 *  移除提示界面
 */
-(void)dismissNoDataView;
/**
 *  自定义导航栏
 */
-(void)setUpNavigation;
/**
 *  去除tableview多余线
 *
 *  @param tableView tableview
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView;
@end

//
//   .h
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "ReceiveMessage.h"
#import "OpenRemoteNotification.h"
@interface BaseTableViewController : UITableViewController

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

#pragma mark - refresh and load more
#pragma mark -
- (void)enableRefresh:(BOOL)bRefresh action:(SEL)action;
- (void)enableLoadMore:(BOOL)bLoadMore action:(SEL)action;

- (void)endRefresh;
- (void)endLoadMore;

@end

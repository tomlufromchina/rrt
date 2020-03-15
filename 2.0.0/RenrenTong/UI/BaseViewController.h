//
//  BaseViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

#pragma mark - show HUD
#pragma mark -
- (void)showWithStatus:(NSString*)status;
- (void)showProgress:(CGFloat)progress;
- (void)showProgress:(CGFloat)progress status:(NSString*)status;
- (void)showSuccessWithStatus:(NSString*)string;
- (void)showErrorWithStatus:(NSString *)string;
- (void)showWithTitle:(NSString *)title withTime:(NSTimeInterval)time;
- (void)showWithTitle:(NSString *)title defaultStr:(NSString *)defaultStr;
- (void)dismiss;
@end

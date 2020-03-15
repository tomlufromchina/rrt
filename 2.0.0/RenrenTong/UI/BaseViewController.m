//
//  BaseViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - ViewController lifeCycle
#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - show HUD
#pragma mark -
- (void)showWithStatus:(NSString*)status
{
    [SVProgressHUD showWithStatus:status];
}

- (void)showProgress:(CGFloat)progress
{
    [SVProgressHUD showProgress:progress];
}

- (void)showProgress:(CGFloat)progress status:(NSString*)status
{
    [SVProgressHUD showProgress:progress status:status];
}

- (void)showSuccessWithStatus:(NSString*)string
{
    [SVProgressHUD showSuccessWithStatus:string];
}

- (void)showErrorWithStatus:(NSString *)string
{
    [SVProgressHUD showErrorWithStatus:string];
}

- (void)showWithTitle:(NSString *)title withTime:(NSTimeInterval)time
{
    [SVProgressHUD showWithTitle:title withTime:time];
}

- (void)showWithTitle:(NSString *)title defaultStr:(NSString *)defaultStr
{
    [SVProgressHUD showWithTitle:title defaultStr:defaultStr];
}

- (void)dismiss
{
    [SVProgressHUD dismiss];
}

@end

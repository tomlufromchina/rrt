//
//  WithoutTheNetworkViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/1/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "WithoutTheNetworkViewController.h"

@interface WithoutTheNetworkViewController ()

@end

@implementation WithoutTheNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"关于网络异常问题";
    
    self.headerTitile.top = 20;
    self.headerTitile.left = 10;
    self.headerTitile.width = SCREENWIDTH - 20;
    self.headerTitile.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    self.lineView.top = self.headerTitile.bottom + 15;
    self.lineView.left = 10;
    self.lineView.width = SCREENWIDTH - 20;
    
    self.label1.top = self.lineView.bottom + 20;
    self.label1.left = 10;
    self.label1.width = SCREENWIDTH - 20;
    
    self.label2.top = self.label1.bottom + 20;
    self.label2.left = 10;
    self.label2.width = SCREENWIDTH - 20;
    
    self.label3.top = self.label2.bottom + 10;
    self.label3.left = 10;
    self.label3.width = SCREENWIDTH - 20;

}

@end

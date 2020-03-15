//
//  WebViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-19.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : BaseViewController

@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pushUrl;// 作为判断的是否显示 暂无通知书

@end

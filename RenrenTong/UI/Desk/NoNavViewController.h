//
//  NoNavViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 15-2-12.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoNavViewController : BaseViewController{
    UIView* statusBarView;
}
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pushUrl;// 作为判断的是否显示 暂无通知书
@end

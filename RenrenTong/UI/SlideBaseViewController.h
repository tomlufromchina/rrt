//
//  SlideBaseViewController.h
//  HLJ_Project
//  Created by 何丽娟 on 15/5/9.
//  Copyright (c) 2015年 何丽娟. All rights reserved.
//
#import "BaseViewController.h"
#import "RESideMenu.h"
/**
 *  左右侧滑vc,需要通过父vc（ResideMenu类）进行界面跳转，否则不能跳转成功，因此需继承此类。
 */
@interface SlideBaseViewController : BaseViewController

@property (nonatomic,readonly,strong) RESideMenu *sideMenuViewController;

@end

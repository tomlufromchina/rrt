//
//  BarBaseViewController.h
//  HLJ_Project

//  Created by 何丽娟 on 15/5/9.
//  Copyright (c) 2015年 何丽娟. All rights reserved.
//

#import "SlideBaseViewController.h"
/**
 *  在有侧滑的框架中，tabBar只能自定义，因此此VC用与管理自定义TabBarVC。
 */
#import "CurrentTeacherViewController.h"
#import "CurrentGuarDianViewController.h"
#import "CurrentStudiesViewController.h"
@interface BarBaseViewController :UIViewController
-(void)addBudge:(NSInteger)budgeNum;
@end

//
//  MainViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    //设置TabBar的背景色
    [[UITabBar appearance] setBarTintColor:appColor];
//    //设置TabBar选中项的图片和文字颜色
//    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    NSArray *images = [NSArray arrayWithObjects:
                       @"maintab_desk_b.png",
                       @"maintab_talk_b.png",
                       @"maintab_find_b.png",
                       @"maintab_contacts_b.png",
                       @"maintab_setting_b.png", nil];
    
    NSArray *selectedImages = [NSArray arrayWithObjects:
                               @"maintab_desk_a.png",
                               @"maintab_talk_a.png",
                               @"maintab_find_a.png",
                               @"maintab_contacts_a.png",
                               @"maintab_setting_a.png", nil];
    
    NSArray *titles = [NSArray arrayWithObjects:@"书桌", @"沟通", @"发现", @"联系人", @"设置", nil];
    
    for (int i = 0; i < 5; i++) {
        UITabBarItem *item = (UITabBarItem*)[self.tabBar.items objectAtIndex:i];
        
        item.title = [titles objectAtIndex:i];
        //item未选中状态下，文字的颜色
        [item setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],
                                                    NSForegroundColorAttributeName, nil]
                            forState:UIControlStateNormal];
        //item选中状态下文字的颜色
        [item setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                                    NSForegroundColorAttributeName, nil]
                            forState:UIControlStateSelected];
        
        //item未选中状态下的图片，因为系统默认会将图片和文字变灰，所以要加UIImageRenderingModeAlwaysOriginal
        UIImage *image = [[UIImage imageNamed:[images objectAtIndex:i]]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = image;
        
        //item选中状态下的图片
        UIImage *selectedImage = [[UIImage imageNamed:[selectedImages objectAtIndex:i]]
                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = selectedImage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

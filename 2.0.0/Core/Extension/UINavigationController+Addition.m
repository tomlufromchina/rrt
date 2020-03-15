//
//  UINavigationController+Addition.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-4.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "UINavigationController+Addition.h"

@implementation UINavigationController (Push)

- (void)pushViewController:(NSString*)viewControllerId
            withStoryBoard:(NSString*)storyBoardId
                 withBlock:(void(^)(UIViewController *viewController))block
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardId bundle:nil];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:viewControllerId];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];

    //注意：从A界面跳转到B界面，如果B界面上不想看到后退按钮上的文字，需要在A界面上设置backItem，而不是在B上设置navigationItem。
    //如下：
    UIViewController *lastVC = self.topViewController;
    [lastVC.navigationItem setBackBarButtonItem:backItem];

    if (block) {
        block(vc);
    }
    
    [self pushViewController:vc animated:YES];
}

@end

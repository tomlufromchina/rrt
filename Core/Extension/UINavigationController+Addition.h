//
//  UINavigationController+Addition.h
//  RenrenTong
//
//  Created by jeffrey on 14-9-4.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController (Push)

- (void)pushViewController:(NSString*)viewControllerId
            withStoryBoard:(NSString*)storyBoardId
                 withBlock:(void(^)(UIViewController *viewController))block;

@end

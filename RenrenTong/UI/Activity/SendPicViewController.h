//
//  SendPicViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-7-10.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPicViewController : BaseViewController

@property (nonatomic, assign) BOOL isHideRightNavigationButton;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) CommonSuccessBlock block;

@end

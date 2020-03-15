//
//  HotTopicSubDetailViewController.h
//  RenrenTong
//
//  Created by aedu on 15/4/22.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "AllTendency.h"

@interface HotTopicSubDetailViewController : BaseViewController

@property (nonatomic,strong) TheMyTendencyList *model;

@property (nonatomic,strong) NSString *replayUserId;
-(void)replayToUser:(NSString*)replyUserId;

@end

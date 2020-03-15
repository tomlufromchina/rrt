//
//  TheSendRecordViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@protocol TheSendRecordViewControllerDelegate <NSObject>

- (void)clickTableViewCell:(int)isSendName WithIsPublishToClassMaster:(int)isPublishToClassMaster;

@end

@interface TheSendRecordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) int isPublishToClassMaster;// 给班主任发送
@property (nonatomic, assign) int isSendName;// 姓名发送
@property(nonatomic, weak)id<TheSendRecordViewControllerDelegate> delegate;


@end

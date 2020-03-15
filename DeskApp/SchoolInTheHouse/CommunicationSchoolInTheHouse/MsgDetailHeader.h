//
//  MsgDetailHeader.h
//  RenrenTong
//
//  Created by aedu on 15/2/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MsgDetailHeaderDelegate <NSObject>

- (void)consultTeacher;

@end

@interface MsgDetailHeader : UIView

@property (strong, nonatomic) UILabel *msgLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *msgIcon;

@property (strong, nonatomic) UIButton *consultTeacher;
@property (strong, nonatomic) UIView *line;
@property(nonatomic, weak)id<MsgDetailHeaderDelegate> delagate;

@end

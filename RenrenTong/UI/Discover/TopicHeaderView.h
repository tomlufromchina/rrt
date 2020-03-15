//
//  TopicHeaderView.h
//  RenrenTong
//
//  Created by aedu on 15/3/26.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicHeaderView : UIView
@property (weak, nonatomic)  UILabel *topicName;
@property (weak, nonatomic)  UILabel *topicDetail;
@property (weak, nonatomic)  UIImageView *bgView;
@property (strong, nonatomic)NSString  *detailString;


@end

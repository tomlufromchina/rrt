//
//  PushNoticeCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titltImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

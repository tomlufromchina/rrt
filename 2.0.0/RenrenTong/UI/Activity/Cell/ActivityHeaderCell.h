//
//  ActivityHeaderCell.h
//  RenrenTong
//
//  Created by jeffrey on 14-7-7.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@property (weak, nonatomic) IBOutlet UIView *countView;

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *messageAvatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;


@end

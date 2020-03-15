//
//  CommunityServiceCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-17.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@interface CommunityServiceCell : UITableViewCell
{
    BOOL isanimating;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UIButton *pressButton;
@property (weak, nonatomic) IBOutlet UIButton *dicussButton;
@property (weak, nonatomic) IBOutlet UIButton *pressAndDicussShowButton;
@property (weak, nonatomic) IBOutlet UILabel *pressLabel;
@property (weak, nonatomic) IBOutlet UIView *pressView;
@property (weak, nonatomic) IBOutlet UIView *conmentView;
@property (weak, nonatomic) IBOutlet UIView *praiseAndDiscussView;


@property (nonatomic,strong) MyDynamic *selfDyamic;
@property (strong, nonatomic) MLEmojiLabel *content;
@property (strong, nonatomic) UIView *photoview;

- (IBAction)praiseAndDiscussButton:(UIButton *)sender;
- (IBAction)pressBtton:(UIButton *)sender;
- (IBAction)dicessButton:(UIButton *)sender;

@end

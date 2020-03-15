//
//  RecordDetailCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@protocol RecordDetailCellDelegate <NSObject>

@optional
//用来传对象 给评论
- (void)commentCellClicked:(MyDynamic *)friendDynamicDetail;
- (void)praiseCellClicked: (MyDynamic *)friendDynamicDetail;

@end
@interface RecordDetailCell : UITableViewCell
{
    BOOL isanimating;
}

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeStr;
@property (weak, nonatomic) IBOutlet UIView *praiseAndDiscussView;
@property (weak, nonatomic) IBOutlet UIView *conmentView;
@property (weak, nonatomic) IBOutlet UILabel *praiseName;
@property (weak, nonatomic) IBOutlet UIButton *preseBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *discuseButton;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *prieseviewdetail;

@property (nonatomic,strong) MyDynamic *selfDyamic;
@property (strong, nonatomic) MLEmojiLabel *content;
@property (strong, nonatomic) UIView *photoview;
@property (weak, nonatomic)id<RecordDetailCellDelegate> delegate;

- (IBAction)praiseAndDiscussButton:(UIButton *)sender;
- (IBAction)praiseButton:(UIButton *)sender;
- (IBAction)discussButton:(UIButton *)sender;

@end
